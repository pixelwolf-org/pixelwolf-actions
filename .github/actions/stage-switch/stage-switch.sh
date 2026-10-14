#!/usr/bin/env bash
#
# stage-switch.sh — Sends a start/stop request to StageKeeper and waits for it to finish.
#
# StageKeeper stops the stage environment on a schedule and never starts anything by itself. This script lets a CI job
# start a project's resources (e.g. before end-to-end tests) or stop them (e.g. after the tests). It:
#
#   1. Publishes the request to the StageKeeper SNS topic, with a unique `request_id`.
#   2. Waits for the "StageKeeper result: {...}" log line holding that `request_id` (unless STAGE_WAIT=false).
#   3. On start, waits until the started resources are available (unless STAGE_WAIT_FOR_READY=false).
#
# Called by action.yml, which maps the action inputs to the STAGE_* environment variables below. It runs on GitHub
# hosted runners (bash, jq, AWS CLI v2 and GNU coreutils are preinstalled) with AWS credentials already configured.
#
# Environment:
#   STAGE_ACTION            start | stop.
#   STAGE_PROJECTS          Projects as <customer>-<project>, comma or newline separated.
#   STAGE_RESOURCES         Optional resource types (ecs, rds, ec2, asg, eventbridge or full type names).
#   STAGE_CLUSTERS          Optional ECS clusters. Only ECS services are switched when set.
#   STAGE_NAMES             Optional globs matched against resource names, ids and ARNs.
#   STAGE_FORCE             true | false. Start: also start resources StageKeeper did not stop.
#   STAGE_DRY_RUN           true | false. Only log what would be switched.
#   STAGE_WAIT              true | false. Wait for StageKeeper to process the request.
#   STAGE_WAIT_FOR_READY    true | false. Start: wait until the started resources are available.
#   STAGE_TIMEOUT_MINUTES   Overall timeout, in minutes.
#   STAGE_TOPIC_ARN         StageKeeper SNS topic. Its region is used for every AWS call.
#   STAGE_LOG_GROUP         StageKeeper Lambda log group.

set -euo pipefail

readonly RESULT_MARKER='StageKeeper result:'
readonly RESOURCE_TYPES='ecs rds ec2 asg eventbridge ecs-service rds-instance rds-cluster ec2-instance autoscaling-group eventbridge-rule'
readonly POLL_INTERVAL=10

die() {
  echo "::error::$*"
  exit 1
}

# Writes `name=value` to the step outputs (no-op outside GitHub Actions).
set_output() {
  if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    echo "$1=$2" >>"$GITHUB_OUTPUT"
  fi
}

# Appends Markdown to the job summary (no-op outside GitHub Actions).
summary() {
  if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
    echo "$*" >>"$GITHUB_STEP_SUMMARY"
  fi
}

# Converts a comma/newline separated list into a JSON array of trimmed, non-empty strings.
to_json_list() {
  jq -cRn '[inputs | splits(",") | gsub("^\\s+|\\s+$"; "") | select(length > 0)]' <<<"$1"
}

check_bool() {
  [[ "$2" == "true" || "$2" == "false" ]] || die "Input '$1' must be 'true' or 'false', got '$2'."
}

# Seconds left before the overall deadline.
remaining() {
  echo $((DEADLINE - $(date +%s)))
}

# -- Inputs ------------------------------------------------------------------------------------------------------------

ACTION="${STAGE_ACTION:-}"
FORCE="${STAGE_FORCE:-false}"
DRY_RUN="${STAGE_DRY_RUN:-false}"
WAIT="${STAGE_WAIT:-true}"
WAIT_FOR_READY="${STAGE_WAIT_FOR_READY:-true}"
TIMEOUT_MINUTES="${STAGE_TIMEOUT_MINUTES:-20}"
TOPIC_ARN="${STAGE_TOPIC_ARN:?STAGE_TOPIC_ARN is required}"
LOG_GROUP="${STAGE_LOG_GROUP:?STAGE_LOG_GROUP is required}"

[[ "$ACTION" == "start" || "$ACTION" == "stop" ]] || die "Input 'action' must be 'start' or 'stop', got '$ACTION'."
check_bool force "$FORCE"
check_bool dry-run "$DRY_RUN"
check_bool wait "$WAIT"
check_bool wait-for-ready "$WAIT_FOR_READY"
[[ "$TIMEOUT_MINUTES" =~ ^[1-9][0-9]*$ ]] || die "Input 'timeout-minutes' must be a positive integer, got '$TIMEOUT_MINUTES'."
[[ "$ACTION" == "start" || "$FORCE" == "false" ]] || die "Input 'force' is only valid with 'action: start'."

PROJECTS="$(to_json_list "${STAGE_PROJECTS:-}")"
RESOURCES="$(to_json_list "${STAGE_RESOURCES:-}")"
CLUSTERS="$(to_json_list "${STAGE_CLUSTERS:-}")"
NAMES="$(to_json_list "${STAGE_NAMES:-}")"

[[ "$PROJECTS" != "[]" ]] || die "Input 'projects' is required (e.g. 'pixelwolf-sabia')."

for resource in $(jq -r '.[]' <<<"$RESOURCES"); do
  [[ " $RESOURCE_TYPES " == *" $resource "* ]] || die "Unknown resource '$resource'. Accepted values: ${RESOURCE_TYPES// /, }."
  if [[ "$CLUSTERS" != "[]" && "$resource" != "ecs" && "$resource" != "ecs-service" ]]; then
    die "Input 'clusters' only applies to ECS services; remove it or set 'resources: ecs'."
  fi
done

# Every AWS call goes to the region of the StageKeeper topic, whatever region the job credentials were set up for.
AWS_REGION="$(cut -d: -f4 <<<"$TOPIC_ARN")"
[[ -n "$AWS_REGION" ]] || die "Input 'topic-arn' is not a valid SNS topic ARN: '$TOPIC_ARN'."
export AWS_REGION AWS_DEFAULT_REGION="$AWS_REGION"

DEADLINE=$(($(date +%s) + TIMEOUT_MINUTES * 60))
REQUEST_ID="ci-${GITHUB_RUN_ID:-local}-${GITHUB_RUN_ATTEMPT:-0}-$(od -An -N4 -tx4 /dev/urandom | tr -d ' \n')"
set_output request-id "$REQUEST_ID"

# -- 1. Publish the request --------------------------------------------------------------------------------------------

MESSAGE="$(
  jq -cn \
    --arg action "$ACTION" \
    --arg request_id "$REQUEST_ID" \
    --argjson projects "$PROJECTS" \
    --argjson resources "$RESOURCES" \
    --argjson clusters "$CLUSTERS" \
    --argjson names "$NAMES" \
    --argjson force "$FORCE" \
    --argjson dry_run "$DRY_RUN" '
    {action: $action, projects: $projects, force: $force, dry_run: $dry_run, request_id: $request_id}
    + (if ($resources | length) > 0 then {resource_types: $resources} else {} end)
    + (if ($clusters | length) > 0 then {clusters: $clusters} else {} end)
    + (if ($names | length) > 0 then {names: $names} else {} end)'
)"

# Logs are searched from slightly before the publish, to tolerate clock skew between the runner and AWS.
START_TIME_MS=$((($(date +%s) - 60) * 1000))

echo "Sending StageKeeper request: $MESSAGE"
aws sns publish --topic-arn "$TOPIC_ARN" --message "$MESSAGE" --query MessageId --output text >/dev/null
echo "Request ${REQUEST_ID} sent."

if [[ "$WAIT" == "false" ]]; then
  set_output status sent
  summary "StageKeeper \`${ACTION}\` request \`${REQUEST_ID}\` sent for \`$(jq -r 'join(", ")' <<<"$PROJECTS")\` (not waited)."
  exit 0
fi

# -- 2. Wait for the StageKeeper result --------------------------------------------------------------------------------

echo "::group::Waiting for StageKeeper to process the request (timeout: ${TIMEOUT_MINUTES} min)"
RESULT=""
while [[ -z "$RESULT" ]]; do
  # JSON output: the CLI merges every result page into one document (text output would print one line per page).
  line="$(
    aws logs filter-log-events \
      --log-group-name "$LOG_GROUP" \
      --start-time "$START_TIME_MS" \
      --filter-pattern "\"${RESULT_MARKER}\" \"${REQUEST_ID}\"" \
      --output json |
      jq -r 'first(.events[]?.message) // empty'
  )"

  if [[ -n "$line" ]]; then
    RESULT="$(jq -c . <<<"${line#*"$RESULT_MARKER"}")"
    break
  fi

  (($(remaining) > 0)) || die "Timed out after ${TIMEOUT_MINUTES} min waiting for StageKeeper. Check ${LOG_GROUP} for request ${REQUEST_ID}."
  echo "Not processed yet, checking again in ${POLL_INTERVAL}s..."
  sleep "$POLL_INTERVAL"
done
echo "::endgroup::"

STATUS="$(jq -r .status <<<"$RESULT")"
set_output status "$STATUS"
set_output result "$RESULT"
set_output switched "$(jq '.switched // [] | length' <<<"$RESULT")"

summary "### StageKeeper \`${ACTION}\`$([[ "$DRY_RUN" == "true" ]] && echo ' (dry run)')"
summary ""
summary "Request \`${REQUEST_ID}\` for \`$(jq -r 'join(", ")' <<<"$PROJECTS")\`: **${STATUS}**."
summary ""
jq -r '
  def rows($label; $items): $items[] | "| \($label) | \(if type == "object" then "\(.type) `\(.id)`" else . end) |";
  "| Result | Resource |", "|---|---|",
  rows("switched"; .switched // []), rows("cleaned"; .cleaned // []), rows("skipped"; .skipped // []),
  rows("excluded"; .excluded // []), rows("failed"; .failed // [])' <<<"$RESULT" >>"${GITHUB_STEP_SUMMARY:-/dev/null}"

echo "StageKeeper result: $(jq '{status, switched: [.switched[]? | "\(.type) \(.id)"], skipped, failed}' <<<"$RESULT")"

case "$STATUS" in
  ok) ;;
  skipped) echo "::warning::StageKeeper skipped the request (weekend)." ;;
  error) die "StageKeeper could not process the request: $(jq -r .error <<<"$RESULT")" ;;
  failed) die "StageKeeper failed to ${ACTION}: $(jq -r '.failed | join(", ")' <<<"$RESULT")" ;;
  *) die "Unexpected StageKeeper status '${STATUS}'." ;;
esac

if [[ "$ACTION" == "start" && "$FORCE" == "false" ]] && jq -e '.skipped | length > 0' <<<"$RESULT" >/dev/null; then
  echo "::notice::Some resources were skipped (already running, in transition or not stopped by StageKeeper). Set 'force: true' to start resources StageKeeper did not stop."
fi

# -- 3. Wait for the started resources ---------------------------------------------------------------------------------

if [[ "$ACTION" != "start" || "$DRY_RUN" == "true" || "$WAIT_FOR_READY" == "false" ]]; then
  exit 0
fi

# Runs an AWS CLI waiter bounded by the overall deadline.
wait_for() {
  local label="$1"
  shift
  local left
  left="$(remaining)"
  ((left > 0)) || die "${label} did not become available before the timeout."
  echo "Waiting for ${label}..."
  timeout "$left" "$@" || die "${label} did not become available before the timeout."
}

# Auto Scaling groups have no CLI waiter: polls until the desired number of instances is InService.
wait_for_asg() {
  local name="$1" desired in_service
  echo "Waiting for autoscaling-group ${name}..."
  while :; do
    read -r desired in_service < <(
      aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$name" --output json |
        jq -r '.AutoScalingGroups[0] | "\(.DesiredCapacity) \([.Instances[] | select(.LifecycleState == "InService")] | length)"'
    )
    ((${in_service:-0} >= ${desired:-1})) && return 0
    (($(remaining) > 0)) || die "autoscaling-group ${name} did not become available before the timeout."
    sleep "$POLL_INTERVAL"
  done
}

echo "::group::Waiting for the started resources"
# StageKeeper reports resources in start order (databases first), so they are awaited in the same order.
while IFS=$'\t' read -r type id arn cluster; do
  [[ -n "$type" ]] || continue
  case "$type" in
    rds-cluster) wait_for "rds-cluster ${id}" aws rds wait db-cluster-available --db-cluster-identifier "$id" ;;
    rds-instance) wait_for "rds-instance ${id}" aws rds wait db-instance-available --db-instance-identifier "$id" ;;
    ec2-instance) wait_for "ec2-instance ${id}" aws ec2 wait instance-running --instance-ids "$id" ;;
    autoscaling-group) wait_for_asg "$id" ;;
    ecs-service) wait_for "ecs-service ${id}" aws ecs wait services-stable --cluster "$cluster" --services "$arn" ;;
    eventbridge-rule) ;; # Enabled immediately.
    *) echo "::warning::Not waiting for unknown resource type '${type}' (${id})." ;;
  esac
done < <(jq -r '.switched[]? | [.type, .id, .arn, (.cluster // "")] | @tsv' <<<"$RESULT")
echo "::endgroup::"

echo "Every started resource is available."

# Stage Switch

A GitHub Action that starts or stops the stage resources of a project through
[StageKeeper](https://github.com/pixelwolf-org/pixelwolf-stagekeeper), and waits until they are ready.

StageKeeper stops the whole stage environment on a schedule and **never starts anything by itself**. Use this action
when a CI job needs a project running, for example to run end-to-end tests against stage, and to stop it again when
the job is done.

How it works:

1. Publishes a `start` or `stop` request to the StageKeeper SNS topic, tagged with a unique `request_id`.
2. Waits for StageKeeper to process it: StageKeeper logs a `StageKeeper result: {...}` line holding the `request_id`,
   which the action finds in CloudWatch Logs. The step fails if StageKeeper fails to switch any resource.
3. On `start`, waits until every started resource is available: RDS clusters and instances available, EC2 instances
   running, Auto Scaling groups with their desired capacity `InService` and ECS services stable. Databases are started
   first, so they are awaited first.

## Features

- Starts or stops a project (or several) with one step, using the same names as `pixelwolf stage start|stop`.
- Narrows the request to resource types, ECS clusters or resource names.
- Waits for the request and for the started resources, with a single overall timeout.
- Fails the step when StageKeeper cannot switch a resource, and lists every resource in the job summary.
- Dry-run mode to check which resources a request would touch.

## Usage

### Start the project before end-to-end tests, stop it afterwards

```yaml
jobs:
  e2e:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - name: 'Checkout Code'
        uses: actions/checkout@v7

      - name: 'Setup aws credentials for StageKeeper'
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: ${{ vars.AWS_STAGEKEEPER_ROLE_ARN }}
          aws-region: us-east-1
          # Covers starting the project, running the tests and stopping it.
          role-duration-seconds: 7200

      - name: 'Start stage'
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/stage-switch@main
        with:
          action: start
          projects: pixelwolf-sabia

      - name: 'Run end-to-end tests'
        run: bun run test:e2e

      - name: 'Stop stage'
        if: always()
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/stage-switch@main
        with:
          action: stop
          projects: pixelwolf-sabia
```

### Start only the API services, without waiting for them

```yaml
- name: 'Start the APIs'
  uses: pixelwolf-org/pixelwolf-actions/.github/actions/stage-switch@main
  with:
    action: start
    projects: pixelwolf-sabia
    resources: ecs
    names: '*-api'
    wait-for-ready: false
```

### Use the result in later steps

```yaml
- name: 'Start stage'
  id: stage
  uses: pixelwolf-org/pixelwolf-actions/.github/actions/stage-switch@main
  with:
    action: start
    projects: pixelwolf-sabia

- name: 'Show what was started'
  env:
    RESULT: ${{ steps.stage.outputs.result }}
  run: echo "$RESULT" | jq -r '.switched[] | "\(.type) \(.id)"'
```

## Inputs

### `action`

- **Description**: What to do with the project resources.
- **Type**: `start` | `stop`
- **Required**: Yes

### `projects`

- **Description**: Projects to switch, as `<customer>-<project>` (built from the `Customer` and `Project` tags, e.g.
  `Customer=Pixelwolf` and `Project=Sabia` is `pixelwolf-sabia`). Comma or newline separated.
- **Required**: Yes

### `resources`

- **Description**: Only switch these resource types. Comma or newline separated.
- **Accepted values**: `ecs`, `rds`, `ec2`, `asg`, `eventbridge`, or the full type names `ecs-service`, `rds-instance`,
  `rds-cluster`, `ec2-instance`, `autoscaling-group`, `eventbridge-rule`.
- **Default**: every type
- **Required**: No

### `clusters`

- **Description**: Only switch the ECS services of these clusters. Comma or newline separated. Cannot be combined with
  non-ECS `resources`.
- **Required**: No

### `names`

- **Description**: Only switch resources whose name, id or ARN matches one of these globs (e.g., `*-api`). Comma or
  newline separated.
- **Required**: No

### `force`

- **Description**: Start only. Also start resources that were not stopped by StageKeeper (for example, stopped by hand).
  By default only resources StageKeeper stopped are started, with the capacity they had before.
- **Type**: `bool` (`true` | `false`)
- **Default**: `false`
- **Required**: No

### `dry-run`

- **Description**: Only report what would be switched, without changing anything.
- **Type**: `bool` (`true` | `false`)
- **Default**: `false`
- **Required**: No

### `wait`

- **Description**: Wait for StageKeeper to process the request, and fail the step if it fails. When `false`, the action
  only publishes the request.
- **Type**: `bool` (`true` | `false`)
- **Default**: `true`
- **Required**: No

### `wait-for-ready`

- **Description**: Start only. Also wait until the started resources are available. Ignored when `wait` is `false`.
- **Type**: `bool` (`true` | `false`)
- **Default**: `true`
- **Required**: No

### `timeout-minutes`

- **Description**: Maximum time to wait for StageKeeper and the started resources. RDS databases usually take 5 to 10
  minutes to start.
- **Type**: `int`
- **Default**: `20`
- **Required**: No

### `topic-arn`

- **Description**: ARN of the StageKeeper SNS topic. Its region is used for every AWS call.
- **Default**: `arn:aws:sns:us-east-1:490004652867:pixelwolf-stagekeeper-infrastructure-switch-scheduler`
- **Required**: No

### `log-group`

- **Description**: CloudWatch log group of the StageKeeper Lambda function.
- **Default**: `/aws/lambda/pixelwolf-stagekeeper-infra-switcher`
- **Required**: No

## Outputs

### `request-id`

Unique id of the request (`ci-<run id>-<attempt>-<random>`), echoed in the StageKeeper logs.

### `status`

StageKeeper result status: `ok`, `failed`, `skipped` (StageKeeper ignored the request because of the weekend),
`error` (the run aborted, e.g. invalid configuration), or `sent` when `wait` is `false`.

### `switched`

Number of resources started or stopped.

### `result`

Full StageKeeper result, as JSON:

```json
{
  "request_id": "ci-123-1-9f2c4a1b",
  "action": "start",
  "dry_run": false,
  "status": "ok",
  "switched": [
    {
      "type": "ecs-service",
      "id": "pixelwolf-sabia-api",
      "arn": "arn:aws:ecs:...:service/pixelwolf-sabia/pixelwolf-sabia-api",
      "cluster": "pixelwolf-sabia"
    }
  ],
  "cleaned": [],
  "skipped": ["ecs-service `pixelwolf-sabia-worker`"],
  "excluded": [],
  "failed": []
}
```

## Notes

- **AWS credentials** must be configured beforehand with `aws-actions/configure-aws-credentials`. Assume the
  `pixelwolf-stagekeeper-github-actions` role, available as the `AWS_STAGEKEEPER_ROLE_ARN` organization variable. It
  is managed by StageKeeper (`terraform/github-actions.tf`), can be assumed for up to 4 hours and only grants what
  the action needs:

  | Permission                                                       | Resource                     | Used for                    |
  | ---------------------------------------------------------------- | ---------------------------- | --------------------------- |
  | `sns:Publish`                                                    | StageKeeper SNS topic        | Sending the request         |
  | `logs:FilterLogEvents`                                           | StageKeeper Lambda log group | `wait`                      |
  | `ecs:DescribeServices`                                           | ECS services                 | `wait-for-ready`, ECS       |
  | `rds:DescribeDBInstances`, `rds:DescribeDBClusters`              | RDS instances and clusters   | `wait-for-ready`, RDS       |
  | `ec2:DescribeInstances`, `autoscaling:DescribeAutoScalingGroups` | `*`                          | `wait-for-ready`, EC2 / ASG |

  To use another role, grant it the same permissions.

- **Other AWS steps**: `configure-aws-credentials` replaces the credentials of the job. When the job also uses another
  role (e.g., to deploy), configure the StageKeeper role again before each `stage-switch` step.
- **Only resources StageKeeper stopped are started** unless `force: true`. Resources that are already running are not
  awaited, and resources still stopping are skipped (a notice is printed when anything is skipped).
- **Stop in an `if: always()` step**, so the project is stopped even when the tests fail. The scheduled stop catches
  anything left running anyway.
- **Requests from different jobs are independent**: each job only waits for its own `request_id`.
- Requires StageKeeper with `request_id` support
  ([pixelwolf-stagekeeper#20](https://github.com/pixelwolf-org/pixelwolf-stagekeeper/pull/20)). With an older
  StageKeeper, use `wait: false`.

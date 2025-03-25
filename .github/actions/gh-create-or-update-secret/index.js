const { Octokit } = require('@octokit/rest');
const _sodium = require('libsodium-wrappers');
const core = require('@actions/core');

async function encrypt(text, key) {
  await _sodium.ready;
  const sodium = _sodium;
  return sodium.to_base64(
    sodium.crypto_box_seal(
      sodium.from_string(text),
      sodium.from_base64(key, sodium.base64_variants.ORIGINAL),
    ),
    sodium.base64_variants.ORIGINAL,
  );
}

function getRepository() {
  const githubRepository = process.env.GITHUB_REPOSITORY;

  if (!githubRepository) {
    throw new Error('GITHUB_REPOSITORY environment variable is not defined');
  }

  const [repoOwner, repoName] = githubRepository.split('/');
  if (!repoOwner || !repoName) {
    throw new Error(`Invalid GITHUB_REPOSITORY format: ${githubRepository}`);
  }
  return { repoOwner, repoName };
}

async function updateSecret({
                              githubToken,
                              secretName,
                              secretValue,
                              basePath,
                            }) {
  const octokit = new Octokit({ auth: githubToken });
  const { repoOwner, repoName } = getRepository();

  const { data: publicKey } = await octokit.request(`GET ${basePath}/public-key`, {
    owner: repoOwner,
    repo: repoName,
    headers: { 'X-GitHub-Api-Version': '2022-11-28' },
  });

  const encryptedValue = await encrypt(secretValue, publicKey.key);

  await octokit.request(`PUT ${basePath}/{secret_name}`, {
    owner: repoOwner,
    repo: repoName,
    secret_name: secretName,
    encrypted_value: encryptedValue,
    key_id: publicKey.key_id,
    headers: { 'X-GitHub-Api-Version': '2022-11-28' },
  });
}

async function updateDependabotSecret(params) {
  const basePath = '/repos/{owner}/{repo}/dependabot/secrets';
  await updateSecret({ ...params, basePath });
}

async function updateRepositorySecret(params) {
  const basePath = '/repos/{owner}/{repo}/actions/secrets';
  await updateSecret({ ...params, basePath });
}

const ACTIONS = new Map([
  ['repository', updateRepositorySecret],
  ['repository-dependabot', updateDependabotSecret],
]);

async function run() {
  try {
    const secretName = core.getInput('secret-name', { required: true });
    const secretValue = core.getInput('secret-value', { required: true });
    const secretType = core.getInput('secret-type', { required: true });
    const githubToken = core.getInput('github-token', { required: true });

    const handler = ACTIONS.get(secretType);

    if (!handler) {
      throw new Error(`Invalid secret type: ${secretType}. Options are: ${Array.from(ACTIONS.keys()).join(', ')}.`);
    }

    await handler({ githubToken, secretName, secretValue });

    console.log(`Secret '${secretName}' was successfully updated.`);
  } catch (error) {
    core.setFailed(`Action failed with error: ${error.message}`);
  }
}

run();

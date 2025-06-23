const { Octokit } = require('@octokit/rest');
const _sodium = require('libsodium-wrappers');
const core = require('@actions/core');

const API_VERSION = '2022-11-28';

const SECRET_TYPES = {
  repository: {
    actions: '/repos/{owner}/{repo}/actions/secrets', dependabot: '/repos/{owner}/{repo}/dependabot/secrets',
  }, organization: {
    actions: '/orgs/{org}/actions/secrets', dependabot: '/orgs/{org}/dependabot/secrets',
  },
};

/**
 * Encrypts text using libsodium's crypto_box_seal with a public key
 *
 * @param {string} text - The text to encrypt
 * @param {string} key - Base64 encoded public key to encrypt with
 * @returns {Promise<string>} Base64 encoded encrypted value
 */
async function encrypt(text, key) {
  await _sodium.ready;
  const sodium = _sodium;
  return sodium.to_base64(sodium.crypto_box_seal(sodium.from_string(text), sodium.from_base64(key, sodium.base64_variants.ORIGINAL)), sodium.base64_variants.ORIGINAL);
}

/**
 * Gets the repository owner and name from GITHUB_REPOSITORY environment variable
 *
 * @returns {{owner: string, repo: string}} Object containing repository owner and name
 * @throws {Error} If GITHUB_REPOSITORY is not defined or has an invalid format
 */
function getRepository() {
  const githubRepository = process.env.GITHUB_REPOSITORY;

  if (!githubRepository) {
    throw new Error('GITHUB_REPOSITORY environment variable is not defined');
  }

  const [owner, repo] = githubRepository.split('/');
  if (!owner || !repo) {
    throw new Error(`Invalid GITHUB_REPOSITORY format: ${githubRepository}`);
  }
  return { owner, repo };
}

/**
 * Updates a repository or organization secret
 *
 * @param {Object} params - Parameters for updating the secret
 * @param {string} params.githubToken - GitHub access token
 * @param {string} params.secret - Name of the secret to update
 * @param {string} params.secretValue - Value of the secret
 * @param {string} params.secretType - Type of the secret (actions or dependabot)
 * @param {string} params.scope - Scope of the secret (repository or organization)
 * @returns {Promise<void>}
 */
async function updateSecret({ githubToken, secret, secretValue, secretType, scope }) {
  const octokit = new Octokit({ auth: githubToken });
  const path = SECRET_TYPES[scope][secretType];
  const { owner, repo } = getRepository();
  const requestParams = scope === 'repository' ? { owner, repo } : { org: owner };

  try {
    const { data: publicKey }  = await octokit.request(`GET ${path}/public-key`, {
      ...requestParams, headers: { 'X-GitHub-Api-Version': API_VERSION },
    });

    if (scope === 'organization') {
      requestParams.visibility = 'private';
    }

    await octokit.request(`PUT ${path}/{secret_name}`, {
      secret_name: secret,
      encrypted_value: await encrypt(secretValue, publicKey.key),
      key_id: publicKey.key_id,
      ...requestParams,
      headers: { 'X-GitHub-Api-Version': API_VERSION },
    });
  } catch (error) {
    throw new Error(`Failed to update secret: ${error.message}`);
  }
}

/**
 * The main function that runs the GitHub Action
 * Reads input parameters, validates the inputs, and updates the specified secret
 *
 * @returns {Promise<void>}
 */
async function run() {
  try {
    const secret = core.getInput('secret-name', { required: true });
    const secretValue = core.getInput('secret-value', { required: true });
    const scope = core.getInput('scope', { required: true });
    const secretType = core.getInput('secret-type', { required: true });
    const githubToken = core.getInput('github-token', { required: true });

    if (!['repository', 'organization'].includes(scope)) {
      throw new Error(`Invalid scope: ${scope}. Options are: repository, organization`);
    }

    if (!['actions', 'dependabot'].includes(secretType)) {
      throw new Error(`Invalid secret type: ${secretType}. Options are: actions, dependabot`);
    }

    await updateSecret({
      githubToken, secret, secretValue, secretType, scope,
    });

    console.log(`Secret '${secret}' was successfully updated.`);
  } catch (error) {
    core.setFailed(`Action failed with error: ${error.message}`);
  }
}

run();
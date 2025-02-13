const core = require('@actions/core');
const jwt = require('jsonwebtoken');

try {
  const privateKey = core.getInput('private-key');
  const iss = core.getInput('iss');
  const expiresIn = core.getInput('expires-in');

  const payload = {
    iss: iss
  };

  const token = jwt.sign(
    payload, privateKey, {
      algorithm: 'RS256',
      expiresIn
    }
  );

  core.setOutput('token', token);
} catch (error) {
  core.setFailed(`Error generating JWT: ${error.message}`);
}
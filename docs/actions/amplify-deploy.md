# AWS Amplify Deploy Action

This GitHub Action facilitates the deployment of applications to AWS Amplify. It is designed to work seamlessly with your CI/CD workflows, providing an automated way to deploy your web applications.

## Features

- Deploys applications to AWS Amplify
- Supports branch creation if it doesn't exist
- Configurable using GitHub Actions inputs
- Uses AWS CLI for deployment operations

## Usage

To use this action in your workflow, include the following step:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to AWS Amplify
        uses: ./actions/amplify-deploy
        with:
          app-id: 'app-id'
          branch-name: 'main'
          create-branch: 'true'
          access-token: 'your-github-access-token'
```

## Inputs

### `app-id`
- **Description**: The ID of your AWS Amplify application.
- **Required**: Yes

### `branch-name`
- **Description**: The branch name to deploy.
- **Required**: Yes

### `create-branch`
- **Description**: Flag to create the branch if it doesn't exist.
- **Required**: No
- **Default**: 'false'

### `access-token`
- **Description**: GitHub Access Token for authentication.
- **Required**: No
- **Default**: ''

## Steps
### Setup Node.js
- Description : Sets up the latest Node.js environment to run the AWS Amplify CLI.
### Install AWS Amplify CLI
- Description : Installs the AWS Amplify CLI globally using npm.
### Update Token
- Description : Updates the AWS Amplify app with the provided GitHub access token if specified.

### Create AWS Amplify Feature Branch
- Description : Creates a new branch in AWS Amplify if the create-branch input is set to 'true'.
### Deploy to AWS Amplify
- Description : Initiates a deployment job to AWS Amplify for the specified branch.

## Notes
- Ensure the provided GitHub access token has the necessary permissions to interact with AWS Amplify.
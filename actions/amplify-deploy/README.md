# AWS Amplify Deploy Action

A GitHub Action to deploy applications to AWS Amplify. This action facilitates the deployment process by automating branch creation and deployment tasks.

## Features

- Deploys specified branches to AWS Amplify
- Optionally creates branches if they do not exist
- Updates GitHub access tokens for authentication
- Utilizes AWS Amplify CLI for deployment management

## Usage

This action can be integrated into any GitHub workflow where AWS Amplify deployment is required.

```yaml
name: Deploy to AWS Amplify

on:
  push:
    branches:
      - main
      - feature/*

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to AWS Amplify
        uses: pixelwolf-org/pixelwolf-actions/actions/amplify-deploy@main
        with:
          app-id: ${{ secrets.AWS_AMPLIFY_APP_ID }}
          branch-name: ${{ github.ref_name }}
          create-branch: 'true'
          access-token: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs
### app-id
- Description : The ID of your AWS Amplify application.
- Required : Yes
### branch-name
- Description : The name of the branch to deploy.
- Required : Yes
### create-branch
- Description : Flag to create the branch if it doesn't exist.
- Required : No
- Default : 'false'
### access-token
- Description : GitHub Access Token for authentication.
- Required : No
- Default : ''
## Outputs
This action does not produce explicit outputs.

## Steps
### Setup Node.js
- Description : Configures the environment with the latest Node.js version.
### Install AWS Amplify CLI
- Description : Installs the AWS Amplify CLI globally to manage deployments.
### Update Token
- Description : Updates the AWS Amplify app with the provided GitHub access token if specified.
### Create AWS Amplify Feature Branch
- Description : Creates a new branch in AWS Amplify if the create-branch input is set to 'true'.
### Deploy to AWS Amplify
- Description : Initiates the deployment process for the specified branch.
## Notes
Ensure that the necessary AWS credentials and GitHub tokens are configured in your GitHub repository secrets to allow this action to authenticate and perform operations on your AWS account.
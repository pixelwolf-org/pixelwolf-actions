# AWS Amplify Branch Delete Action

A GitHub Action to delete a branch from an AWS Amplify application. This action is useful for cleaning up branches that are no longer needed in your Amplify environment.

## Features

- Deletes a specified branch from an AWS Amplify application
- Utilizes the AWS Amplify CLI for branch management
- Configurable via inputs for flexibility

## Usage

This action can be used in any GitHub workflow where you need to manage branches in AWS Amplify.

```yaml
name: Delete Amplify Branch

on:
  workflow_dispatch:

jobs:
  delete-branch:
    runs-on: ubuntu-latest
    steps:
      - name: Delete Amplify Branch
        uses: pixelwolf-org/pixelwolf-actions/actions/amplify-branch-delete@main
        with:
          app-id: ${{ secrets.AWS_AMPLIFY_APP_ID }}
          branch-name: 'feature-branch-to-delete'
```

## Inputs
### app-id
- Description : The ID of your AWS Amplify application.
- Required : Yes
### branch-name
- Description : The name of the branch to delete.
- Required : Yes
## Outputs
This action does not produce explicit outputs.

## Steps
### Setup Node.js
- Description : Sets up the latest Node.js environment to run the AWS Amplify CLI.
### Install AWS Amplify CLI
- Description : Installs the AWS Amplify CLI globally to manage branches.
### Delete Branch
- Description : Executes the command to delete the specified branch from the AWS Amplify application.
## Notes
This action is part of a suite of tools designed to manage AWS Amplify applications efficiently. Ensure that the necessary AWS credentials are configured in your GitHub repository secrets to allow this action to authenticate and perform operations on your AWS account.
# Web Stage CI/CD Workflow

A reusable GitHub Actions workflow for staging and feature preview environments. This workflow runs CI checks and deploys to AWS Amplify when pull requests are created or updated.

## Features

- Automated CI checks using web-ci workflow
- Automatic deployment to AWS Amplify
- Feature branch preview environments
- Uses AWS OIDC for secure authentication

## Triggers

The workflow runs on the following pull request events:
- opened
- synchronize
- reopened

## Permissions

The workflow requires the following permissions:
- `id-token: write` - Required for AWS OIDC authentication
- `contents: write` - Required for repository access
- `pull-requests: write` - Required for PR interactions

## Required Secrets

- `AWS_STAGE_AMPLIFY_APP_ID` - The ID of your Stage AWS Amplify application
- `AWS_REGION` - The AWS region where your Amplify app is located
- `AWS_STAGE_DEPLOY_OIDC_ROLE_ARN` - The AWS Stage IAM Role ARN for OIDC authentication

## Jobs

### CI
Runs the web-ci workflow for code quality checks

### Deploy Preview
Deploys the application to AWS Amplify with the following features:
- Creates feature branches automatically
- Uses branch name from PR or ref
- Configures AWS credentials using OIDC

## Usage

```yaml
name: Stage CI/CD

on:
  pull_request:
    types: [opened, synchronize, reopened]

permissions:
  id-token: write
  contents: write
  pull-requests: write

jobs:
  stage-ci-cd:
    uses: pixelwolf-org/pixelwolf-actions/workflows/web-stage-ci-cd@main
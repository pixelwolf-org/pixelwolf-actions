# Web Production CI/CD Workflow

A reusable GitHub Actions workflow for production deployment. This workflow runs CI checks and deploys to AWS Amplify when changes are pushed to the main branch.

## Features

- Automated CI checks using web-ci workflow
- Automatic deployment to production AWS Amplify environment
- Cleanup of feature preview environments
- Uses AWS OIDC for secure authentication

## Triggers

The workflow runs on:
- Push events to the `main` branch

## Permissions

The workflow requires the following permissions:
- `id-token: write` - Required for AWS OIDC authentication
- `contents: write` - Required for repository access
- `pull-requests: write` - Required for PR interactions

## Required Secrets

- `AWS_PROD_AMPLIFY_APP_ID` - The ID of your Production AWS Amplify application
- `AWS_REGION` - The AWS region where your Amplify app is located
- `AWS_PROD_DEPLOY_OIDC_ROLE_ARN` - The AWS Production IAM Role ARN for OIDC authentication
- `AWS_STAGE_AMPLIFY_APP_ID` - The ID of your Staging AWS Amplify application (for cleanup)
- `AWS_STAGE_DEPLOY_OIDC_ROLE_ARN` - The AWS Staging IAM Role ARN (for cleanup)

## Jobs

### CI
Runs the web-ci workflow for code quality checks

### Deploy Production
Deploys the application to AWS Amplify Production environment:
- Deploys to main branch
- Uses production AWS credentials
- No branch creation needed

### Clean Up
Removes feature preview branches from staging environment:
- Only runs for feature branches
- Skips cleanup for 'main' and 'stage' branches
- Uses staging environment credentials

## Usage

```yaml
name: Production CI/CD

on:
  push:
    branches:
      - main

permissions:
  id-token: write
  contents: write
  pull-requests: write

jobs:
  prod-ci-cd:
    uses: pixelwolf-org/pixelwolf-actions/workflows/web-prod-ci-cd@main
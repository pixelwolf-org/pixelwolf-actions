# Workflow to Deploy Web Application to AWS Amplify Stage Environment

## Description
This workflow automates the CI/CD pipeline for web applications to AWS Amplify staging environment. It leverages GitHub Actions to run tests, build, and deploy preview environments for pull requests. By integrating AWS OpenID Connect (OIDC), it securely configures credentials for deployment.

## Features
- Runs automated CI checks (format, lint, build)
- Creates preview environments for pull requests
- Uses AWS OIDC for secure and seamless AWS credential management
- Automatically deploys to feature branches
- Triggered on pull request events

## Actions

For more details, check the `github-actions` documentation:

- [pixelwolf-org/web-ci](../../workflows/web-ci)
- [pixelwolf-org/amplify-deploy](../../actions/amplify-deploy)
- [actions/checkout](https://github.com/actions/checkout)
- [aws-actions/configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials)

## Required Secrets

### `AWS_STAGE_AMPLIFY_APP_ID`
- **Description**: The ID of your Staging AWS Amplify application
- **Example**: `d987654321`

### `AWS_REGION`
- **Description**: The AWS region where your Amplify app is located
- **Example**: `us-east-1`

### `AWS_STAGE_DEPLOY_OIDC_ROLE_ARN`
- **Description**: The AWS IAM Role ARN for staging environment
- **Example**: `arn:aws:iam::123456789012:role/GithubActionsAmplifyStage`

## Required Scripts

Your package.json should include these scripts:
```json
{
  "scripts": {
    "format": "prettier --write .",
    "lint": "next lint",
    "build": "next build"
  }
}
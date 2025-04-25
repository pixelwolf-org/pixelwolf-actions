# Web CD Workflow

A GitHub Actions workflow for continuous deployment (CD) of web applications to Vercel. This workflow automates the deployment process by loading environment variables from AWS S3 and deploying the application to Vercel.

## Features

- Checks out the code from the repository
- Sets up AWS credentials using OIDC
- Downloads environment variables from S3
- Deploys the application to Vercel
- Comments the deployment URL on pull requests (for preview deployments)

## Usage

This workflow is triggered by a workflow call and is designed to be reusable across different projects or branches.

```yaml
name: Deploy Web App

on:
  push:
    branches:
      - main

jobs:
  deploy:
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-cd.yml@main
    with:
      env-s3-path: 's3://your-bucket/path/to/env-file'
      org-id: 'your-vercel-org-id'
      project-id: 'your-vercel-project-id'
      environment: 'production'
    secrets: inherit
```

## Inputs

| Name          | Description                                               | Required | Default   |
| ------------- | --------------------------------------------------------- | -------- | --------- |
| `env-s3-path` | Path to the environment file in S3 bucket                 | Yes      | -         |
| `org-id`      | Vercel organization ID                                    | Yes      | -         |
| `project-id`  | Vercel project ID                                         | Yes      | -         |
| `environment` | Deployment environment (preview, production)              | No       | `preview` |
| `prod`        | Flag to indicate if a production build should be created. | No       | `false`   |

## Outputs

| Name             | Description                     |
| ---------------- | ------------------------------- |
| `deployment-url` | URL of the deployed application |

## Required Secrets

The workflow requires the following secrets to be set in your GitHub repository:

- `AWS_STAGE_DEPLOY_OIDC_ROLE_ARN`: The ARN of the AWS IAM role to assume for OIDC authentication
- `AWS_REGION`: The AWS region where your S3 bucket is located
- `VERCEL_TOKEN`: Your Vercel API token for authentication

## Workflow Steps

1. **Checkout Repository**: Checks out the code from your repository
2. **Setup AWS Credentials**: Configures AWS credentials using OIDC for secure authentication
3. **Download Environment File**: Retrieves environment variables from the specified S3 path
4. **Vercel Deploy**: Deploys the application to Vercel using the provided configuration
5. **Deploy Comment** (for preview deployments): Adds a comment with the deployment URL to the pull request

## Notes

- For preview deployments, the workflow automatically comments the deployment URL on the associated pull request
- The workflow uses OIDC (OpenID Connect) for secure AWS authentication
- Environment variables are loaded from S3, providing a secure way to manage sensitive configuration
- Make sure your AWS role has appropriate permissions to access the S3 bucket containing your environment file

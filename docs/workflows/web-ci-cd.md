# Production CI/CD Workflow

A GitHub Actions workflow that combines continuous integration (CI) and continuous deployment (CD) for web applications. This workflow runs tests and validation checks on your codebase and then deploys the application to Vercel if all checks pass.

## Features

- Complete CI/CD pipeline in a single workflow
- Runs all CI checks (formatting, linting, building, testing)
- Deploys to Vercel after successful CI
- Configurable test options (unit tests, E2E tests)
- Environment variables loaded securely from AWS S3
- Production or preview deployment options

## Usage

This workflow is triggered by a workflow call and is designed to be reusable across different projects or branches.

```yaml
name: Production CI/CD

on:
  pull_request:
    types: [closed]
    branches:
      - main

jobs:
  deploy:
    if: github.event.pull_request.merged == true
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-ci-cd.yml@main
    with:
      env-s3-path: 's3://your-bucket/path/to/env-file'
      org-id: 'your-vercel-org-id'
      project-id: 'your-vercel-project-id'
      environment: 'production'
      prod: 'true'
      run-unit-tests: 'true'
      run-e2e-tests: 'false'
    secrets: inherit
```

## Inputs

| Name             | Description                                  | Required | Default   |
| ---------------- | -------------------------------------------- | -------- | --------- |
| `env-s3-path`    | Path to the environment file in S3 bucket    | Yes      | -         |
| `org-id`         | Vercel organization ID                       | Yes      | -         |
| `project-id`     | Vercel project ID                            | Yes      | -         |
| `environment`    | Deployment environment (preview, production) | No       | `preview` |
| `prod`           | Should build production build                | No       | `false`   |
| `run-unit-tests` | Whether to run unit tests                    | No       | `true`    |
| `run-e2e-tests`  | Whether to run E2E tests                     | No       | `false`   |

## Required Secrets

The workflow requires the following secrets to be set in your GitHub repository:

- `AWS_STAGE_DEPLOY_OIDC_ROLE_ARN`: The ARN of the AWS IAM role to assume for OIDC authentication
- `AWS_REGION`: The AWS region where your S3 bucket is located
- `VERCEL_TOKEN`: Your Vercel API token for authentication

## Workflow Structure

This workflow consists of two main jobs that run sequentially:

1. **CI Job**: Runs all continuous integration checks
2. **CD Job**: Deploys the application to Vercel if CI passes

### CI Job Steps

1. Checkout repository
2. Setup AWS credentials using OIDC
3. Download environment variables from S3
4. Setup Bun environment
5. Install dependencies
6. Run format check
7. Lint code
8. Build application
9. Run unit tests (if enabled)
10. Run E2E tests with Playwright (if enabled)

### CD Job Steps

1. Checkout repository
2. Setup AWS credentials
3. Download environment variables from S3
4. Deploy to Vercel
5. Comment deployment URL on pull request (for preview deployments)

## Permissions

The workflow requires the following GitHub permissions:

- `id-token: write`: For OIDC authentication with AWS
- `contents: write`: For accessing repository contents
- `pull-requests: write`: For commenting on pull requests
- `packages: read`: For accessing GitHub packages
- `issues: write`: For creating comments on issues

## Notes

- The CD job only runs if the CI job completes successfully
- For production deployments, set `environment` to 'production' and `prod` to 'true'
- The workflow uses OIDC (OpenID Connect) for secure AWS authentication
- Environment variables are loaded from S3, providing a secure way to manage sensitive configuration
- Make sure your AWS role has appropriate permissions to access the S3 bucket containing your environment file
- The workflow requires specific scripts to be defined in your package.json for the CI portion

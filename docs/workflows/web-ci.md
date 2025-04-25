# Web CI Workflow

A GitHub Actions workflow for continuous integration (CI) of web applications using Bun for faster builds. This workflow automates the testing and validation process by running various checks on your codebase.

## Features

- Checks out the code from the repository
- Sets up AWS credentials using OIDC
- Downloads environment variables from S3
- Sets up Bun environment with dependency caching
- Installs dependencies
- Runs format check
- Lints the code
- Builds the application
- Runs unit tests (optional)
- Runs E2E tests with Playwright (optional)

## Usage

This workflow is triggered by a workflow call and is designed to be reusable across different projects or branches.

```yaml
name: CI Web App

on:
  pull_request:
    branches:
      - main

jobs:
  test:
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-ci.yml@main
    with:
      env-s3-path: 's3://your-bucket/path/to/env-file'
      run-unit-tests: 'true'
      run-e2e-tests: 'false'
    secrets: inherit
```

## Inputs

| Name             | Description                               | Required | Default |
| ---------------- | ----------------------------------------- | -------- | ------- |
| `env-s3-path`    | Path to the environment file in S3 bucket | Yes      | -       |
| `run-unit-tests` | Whether to run unit tests                 | No       | `true`  |
| `run-e2e-tests`  | Whether to run E2E tests                  | No       | `false` |

## Required Secrets

The workflow requires the following secrets to be set in your GitHub repository:

- `AWS_STAGE_DEPLOY_OIDC_ROLE_ARN`: The ARN of the AWS IAM role to assume for OIDC authentication
- `AWS_REGION`: The AWS region where your S3 bucket is located

## Workflow Steps

1. **Checkout Repository**: Checks out the code from your repository
2. **Setup AWS Credentials**: Configures AWS credentials using OIDC for secure authentication
3. **Download Environment File**: Retrieves environment variables from the specified S3 path
4. **Log Environment Variables**: Displays loaded environment variables for debugging
5. **Setup Bun**: Configures Bun runtime with dependency caching
6. **Install Dependencies**: Installs project dependencies using Bun
7. **Format Check**: Verifies code formatting using Prettier
8. **Lint**: Runs linting checks on the codebase
9. **Build Web App**: Builds the application in CI environment
10. **Run Unit Tests** (optional): Executes unit tests if enabled
11. **Install Playwright Browser** (optional): Sets up Playwright for E2E testing if enabled
12. **Run Playwright Tests** (optional): Executes E2E tests if enabled
13. **Upload Playwright Report** (optional): Uploads test reports as artifacts if E2E tests are run

## Notes

- The workflow uses OIDC (OpenID Connect) for secure AWS authentication
- Environment variables are loaded from S3, providing a secure way to manage sensitive configuration
- Make sure your AWS role has appropriate permissions to access the S3 bucket containing your environment file
- For E2E tests, Playwright reports are uploaded as artifacts and retained for 30 days
- The workflow requires specific scripts to be defined in your package.json:
  - `format-check`: For checking code formatting
  - `lint`: For linting the code
  - `build:ci`: For building the application in CI environment
  - `test`: For running unit tests (if enabled)

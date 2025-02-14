# Web CI/CD Workflow

A reusable GitHub Actions workflow for web applications that handles CI checks and deployment to AWS Amplify. This workflow can be used for both staging and production environments.

## Features

- Runs automated CI checks using web-ci workflow
- Deploys applications to AWS Amplify
- Uses AWS OIDC for secure authentication
- Optional cleanup of feature preview branches
- Configurable for different environments

## Usage

```yaml
name: Production CI/CD

on:
  push:
    branches:
      - prod

permissions:
  id-token: write
  contents: write
  pull-requests: write

jobs:
  web-ci-cd:
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-ci-cd.yml@feature/web-ci-cd
    with:
      app-id: ${{ vars.AWS_PROD_AMPLIFY_APP_ID }}
      branch-name: 'prod'
      aws-region: ${{ vars.AWS_REGION }}
      role-arn: ${{ vars.AWS_PROD_DEPLOY_OIDC_ROLE_ARN }}
      clean-up: 'true'
```

```yaml
name: Stage CI/CD

on:
  push:
    branches:
      - stage

permissions:
  id-token: write
  contents: write
  pull-requests: write

jobs:
  web-ci-cd:
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-ci-cd.yml@feature/web-ci-cd
    with:
      app-id: ${{ vars.AWS_STAGE_AMPLIFY_APP_ID }}
      branch-name: 'stage'
      aws-region: ${{ vars.AWS_REGION }}
      role-arn: ${{ vars.AWS_STAGE_DEPLOY_OIDC_ROLE_ARN }}
      clean-up: 'true'
```

```yaml
name: Preview CI/CD

on:
  pull_request:
    types: [opened, synchronize, reopened]

permissions:
  id-token: write
  contents: write
  pull-requests: write

jobs:
  web-ci-cd:
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-ci-cd.yml@feature/web-ci-cd
    with:
      app-id: ${{ vars.AWS_STAGE_AMPLIFY_APP_ID }}
      branch-name: ${{ github.head_ref }}
      aws-region: ${{ vars.AWS_REGION }}
      role-arn: ${{ vars.AWS_STAGE_DEPLOY_OIDC_ROLE_ARN }}
      clean-up: 'false'
```


## Inputs

### `app-id`
- **Description**: The ID of your AWS Amplify application
- **Required**: Yes

### `branch-name`
- **Description**: The branch name to deploy (e.g., 'stage', 'main')
- **Required**: No
- **Default**: Current branch name

### `aws-region`
- **Description**: The AWS region where your Amplify app is located
- **Required**: Yes

### `role-arn`
- **Description**: The AWS IAM Role ARN for OIDC authentication
- **Required**: Yes

### `clean-up`
- **Description**: Flag to control if preview branches should be deleted after deployments
- **Required**: No
- **Default**: 'false'

## Outputs

This action does not produce explicit outputs.

## Jobs

### CI
Runs the web-ci workflow for code quality checks

### Deploy
Deploys the application to AWS Amplify with the following features:
- Configures AWS credentials using OIDC
- Creates feature branches automatically (except for 'stage' and 'main')
- Deploys to specified branch

### Clean-up
Optional job that removes feature preview branches:
- Only runs when clean-up input is 'true'
- Uses same AWS credentials as deployment
- Recommended to set as 'true' for preview ci-cd workflows on pull requests close, to maintain clean environments


## Notes

> Important: Ensure that you add the `GH_APP_PRIVATE_KEY` secret to your repository. This is crucial for the pipeline as it is a dependency for the access token generation action.


Create 3 different files for CI/CD workflows inside your project:

1. Create `.github/workflows/prod-ci-cd.yml` for production deployments.
2. Create `.github/workflows/stage-ci-cd.yml` for stage deployments.
3. Create `.github/workflows/preview-ci-cd.yml` for previews deployments.
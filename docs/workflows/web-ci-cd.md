# Web CI/CD Workflow

A reusable GitHub Actions workflow for web applications that handles CI checks and deployment to AWS Amplify. This workflow can be used for both staging and production environments.

## Features

- Runs automated CI checks using web-ci workflow
- Deploys applications to AWS Amplify
- Uses AWS OIDC for secure authentication
- Optional cleanup of feature preview branches
- Configurable for different environments

## Usage

### Production Pipeline Setup

For production deployments, create a file named `.github/workflows/web-prod-ci-cd.yml` with the following workflow configuration. This workflow:

- Triggers on pushes to the main branch
- Uses AWS production role and Amplify app ID
- Deploys the application to AWS Amplify
- Cleans up preview branches after successful deployment

Here's the workflow configuration:


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
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-ci-cd.yml@main
    with:
      app-id: ${{ vars.AWS_PROD_AMPLIFY_APP_ID }}
      branch-name: 'prod'
      aws-region: ${{ vars.AWS_REGION }}
      role-arn: ${{ vars.AWS_PROD_DEPLOY_OIDC_ROLE_ARN }}
      clean-up: 'true'
```

### Stage Pipeline Setup

For stage deployments, create a file named `.github/workflows/web-stage-ci-cd.yml` with the following workflow configuration. This workflow:

- Triggers on pushes to the stage branch
- Uses AWS stage role and Amplify app ID
- Deploys the application to AWS Amplify
- Cleans up preview branches after successful deployment

Here's the workflow configuration:

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
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-ci-cd.yml@main
    with:
      app-id: ${{ vars.AWS_STAGE_AMPLIFY_APP_ID }}
      branch-name: 'stage'
      aws-region: ${{ vars.AWS_REGION }}
      role-arn: ${{ vars.AWS_STAGE_DEPLOY_OIDC_ROLE_ARN }}
      clean-up: 'true'
```

### Previews Pipeline Setup

For preview deployments, create a file named `.github/workflows/web-preview-ci-cd.yml` with the following workflow configuration. This workflow:

- Triggers on pull-requests
- Uses AWS stage role and Amplify app ID
- Deploys the application to AWS Amplify

Here's the workflow configuration:

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
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-ci-cd.yml@main
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

## Notes

> Important: Ensure that you add the `GH_APP_PRIVATE_KEY` secret to your repository. This is crucial for the pipeline as it is a dependency for the access token generation action.


Create 3 different files for CI/CD workflows inside your project:

1. Create `.github/workflows/prod-ci-cd.yml` for production deployments.
2. Create `.github/workflows/stage-ci-cd.yml` for stage deployments.
3. Create `.github/workflows/preview-ci-cd.yml` for previews deployments.
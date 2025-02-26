# Web CI/CD Workflow

A reusable GitHub Actions workflow for web applications that handles CI checks and deployment to Vercel. This workflow can be used for both staging and production environments.

## Features

- Runs automated CI checks using web-ci workflow
- Deploys applications to Vercel
- Uses Vercel OIDC for secure authentication
- Configurable for different environments
- Comments the deployment URL on the pull request

## Usage

### Production Pipeline Setup

For production deployments, create a file named `.github/workflows/web-prod-ci-cd.yml` with the following workflow configuration. This workflow:

- Triggers on pushes to the main branch
- Uses Vercel organization ID and project ID
- Deploys the application to Vercel

Here's the workflow configuration:

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
  issues: write

jobs:
  web-ci-cd:
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-ci-cd.yml@main
    with:
      org-id: ${{ vars.VERCEL_ORG_ID }}
      project-id: ${{ vars.VERCEL_PROJECT_ID }}
      environment: 'production'
      prod: 'true'
    secrets: inherit
```

### Stage Pipeline Setup

For stage deployments, create a file named `.github/workflows/web-stage-ci-cd.yml` with the following workflow configuration. This workflow:

- Triggers on pushes to the stage branch
- Uses Vercel organization ID and project ID
- Deploys the application to Vercel

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
  issues: write

jobs:
  web-ci-cd:
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-ci-cd.yml@main
    with:
      org-id: ${{ vars.VERCEL_ORG_ID }}
      project-id: ${{ vars.VERCEL_PROJECT_ID }}
      environment: 'development'
      prod: 'true'
    secrets: inherit
```

### Previews Pipeline Setup

For preview deployments, create a file named `.github/workflows/web-preview-ci-cd.yml` with the following workflow configuration. This workflow:

- Triggers on pull requests
- Uses Vercel organization ID and project ID
- Deploys the application to Vercel

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
  issues: write

jobs:
  web-ci-cd:
    uses: pixelwolf-org/pixelwolf-actions/.github/workflows/web-ci-cd.yml@main
    with:
      org-id: ${{ vars.VERCEL_ORG_ID }}
      project-id: ${{ vars.VERCEL_PROJECT_ID }}
      environment: 'preview'
      prod: 'false'
    secrets: inherit
```

## Inputs

### `org-id`

- **Description**: The ID of your Vercel organization.
- **Required**: Yes

### `project-id`

- **Description**: The ID of your Vercel project.
- **Required**: Yes

### `environment`

- **Description**: The environment to deploy (e.g., preview, production).
- **Required**: No
- **Default**: 'preview'

### `prod`

- **Description**: Flag to indicate if a production build should be created.
- **Required**: No
- **Default**: 'false'

## Required Variables and Secrets

> Important: Ensure that you add the following variables to your repository:
>
> - `VERCEL_ORG_ID`: The ID of your Vercel organization.
> - `VERCEL_PROJECT_ID`: The ID of your Vercel project.

> Important: Ensure that you add the following secrets to your repository:
>
> - `VERCEL_TOKEN`: This token is required for authentication with Vercel.

## Outputs

### `deployment-url`

- **Description**: The URL of the deployed application.
- **Produced by**: The `cd` job in the workflow.

## Notes

- Ensure that the provided Vercel token has the necessary permissions to deploy to your Vercel project.
- The deployment URL will be commented on the pull request after a successful deployment.

Create 3 different files for CI/CD workflows inside your project:

1. Create `.github/workflows/prod-ci-cd.yml` for production deployments.
2. Create `.github/workflows/stage-ci-cd.yml` for stage deployments.
3. Create `.github/workflows/preview-ci-cd.yml` for preview deployments.

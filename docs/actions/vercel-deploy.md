# Vercel Deploy Action

This GitHub Action facilitates the deployment of applications to Vercel. It is designed to work seamlessly with your CI/CD workflows, providing an automated way to deploy your web applications.

## Features

- Deploys applications to Vercel
- Supports environment configuration for different deployment scenarios
- Configurable using GitHub Actions inputs
- Uses Vercel CLI for deployment operations

## Usage

To use this action in your workflow, include the following step:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Vercel
        uses: ./actions/vercel-deploy
        with:
          vercel-token: 'your-vercel-token'
          org-id: 'your-vercel-org-id'
          project-id: 'your-vercel-project-id'
          environment: 'preview' # 'production' / 'development' / 'preview'
          prod: 'false' # Set to 'true' for production builds
```

## Inputs

### `vercel-token`

- **Description**: The token used for authentication with Vercel.
- **Required**: Yes

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

## Notes

- Ensure the provided Vercel token has the necessary permissions to deploy to your Vercel project.
- The action uses the Vercel CLI, which will be installed during the action execution.

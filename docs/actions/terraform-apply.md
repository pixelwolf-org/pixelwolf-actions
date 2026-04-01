# Terraform Apply

Applies Terraform changes for infrastructure. Requires AWS credentials configured in the workflow and GitHub Access token to access `pixelwolf-terraform` modules.

## Features

- **Automated Terraform Execution**: Automatically initializes, validates, and applies Terraform configurations.
- **S3-based State Management**: Stores Terraform state files in an AWS S3 bucket.
- **Environment-Specific Configurations**: Supports different environments such as stage and production.

## Usage

To use this GitHub Action, add the following step to your workflow:

```yaml
name: 'My Workflow'

on:
  push:
    branches:
      - main

jobs:
  my-job:
    name: 'My Job'
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout Code'
        uses: actions/checkout@v4

      - name: 'Setup aws credentials with OIDC'
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_INFRA_OIDC_ROLE_ARN }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: 'Generate access-token to download Pixelwolf Terraform Modules'
        id: gh-app-token
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/gh-app-access-token@main
        with:
          app-id: 'app-id'
          installation-id: 'app-installation-id'
          private-key: ${{ secrets.GH_APP_PRIVATE_KEY }}

      - name: 'Run Terraform Apply'
        uses: pixelwolf-org/pixelwolf-actions/actions/terraform-apply@main
        with:
          customer-name: 'pixelwolf'
          project-name: 'example-project'
          access-token: ${{ steps.gh-app-token.outputs.access-token }}
          aws-region: ${{ secrets.AWS_REGION }}
          environment: 'stage'
          working-directory: './terraform'
```

## Inputs

### `customer-name`

- **Description**: Unique customer identifier for managing infrastructure.
- **Type**: `string`
- **Required**: Yes

### `project-name`

- **Description**: Project name within the customer environment.
- **Type**: `string`
- **Required**: Yes

### `access-token`

- **Description**: GitHub access token for authenticating Pixelwolf Terraform module access.
- **Type**: `string`
- **Required**: Yes

### `aws-region`

- **Description**: AWS region where the infrastructure will be deployed.
- **Type**: `string`
- **Default**: `us-east-1`
- **Required**: No

### `environment`

- **Description**: Deployment environment (e.g., stage, prod).
- **Type**: `string`
- **Default**: `stage`
- **Required**: No

### `working-directory`

- **Description**: Path to the Terraform configuration files.
- **Type**: `string`
- **Default**: `./terraform`
- **Required**: No

### `terraform-bucket`

- **Description**: S3 bucket name for Terraform state storage.
- **Type**: `string`
- **Default**: `null`
- **Required**: No

## Outputs

No explicit outputs are provided. The action logs execution process to the console.

## Notes

- **AWS Credentials**: Ensure AWS credentials are properly configured in the workflow.
- **State Management**: Terraform state is stored in an S3 bucket and DynamoDB table for state locking.
- **Git Configuration**: Git access is configured dynamically using the provided GitHub App token.

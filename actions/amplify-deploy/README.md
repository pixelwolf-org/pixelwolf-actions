# AWS Amplify Deploy

A GitHub Action to automate the deployment of applications to AWS Amplify. This action handles branch creation (optional) and deployment of your application using the AWS Amplify CLI.

## Features

- Automated deployments to AWS Amplify
- Optional branch creation with pull request preview enabled
- Uses AWS OIDC for secure authentication
- Supports multiple environments through branch deployments

## Inputs

### `app-id`
- **Description**: The ID of your AWS Amplify application
- **Required**: Yes

### `branch-name`
- **Description**: The branch name to deploy
- **Required**: Yes

### `aws-region`
- **Description**: The AWS region where your Amplify app is located
- **Required**: Yes

### `role-arn`
- **Description**: The AWS IAM Role ARN for OIDC authentication
- **Required**: Yes

### `create-branch`
- **Description**: Whether to create the branch if it doesn't exist
- **Required**: No
- **Default**: "false"

## Outputs

No explicit outputs are provided. The action logs deployment progress to the console.

## Usage

### Basic Example

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Deploy to Amplify
        uses: pixelwolf-org/pixelwolf-actions/actions/amplify-deploy@main
        with:
          app-id: 'd1234567890'
          branch-name: 'main'
          aws-region: 'us-east-1'
          role-arn: ${{ secrets.AWS_ROLE_ARN }}
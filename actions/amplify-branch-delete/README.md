# AWS Amplify Branch Delete

A GitHub Action to automate the deletion of branches in AWS Amplify applications. This action safely removes specified branches using the AWS Amplify CLI.

## Features

- Automated branch deletion in AWS Amplify
- Uses AWS OIDC for secure authentication
- Simple integration with existing workflows

## Inputs

### `app-id`
- **Description**: The ID of your AWS Amplify application
- **Required**: Yes

### `branch-name`
- **Description**: The name of the branch to delete
- **Required**: Yes

### `aws-region`
- **Description**: The AWS region where your Amplify app is located
- **Required**: Yes

### `role-arn`
- **Description**: The AWS IAM Role ARN for OIDC authentication
- **Required**: Yes

## Outputs

No explicit outputs are provided. The action logs deletion progress to the console.

## Usage

### Basic Example

```yaml
jobs:
  cleanup:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Delete Amplify Branch
        uses: pixelwolf-org/pixelwolf-actions/actions/amplify-branch-delete@main
        with:
          app-id: 'd1234567890'
          branch-name: 'feature/old-feature'
          aws-region: 'us-east-1'
          role-arn: ${{ secrets.AWS_ROLE_ARN }}
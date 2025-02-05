# Deploy Lambda Function

This GitHub Action updates an AWS Lambda function with a new ECR container image.

## Features

- **Automated Deployment**: Deploys an updated container image to an AWS Lambda function.

## Usage

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Setup aws credentials with OIDC
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_OIDC_ROLE_ARN }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Deploy Lambda Function
        uses: pixelwolf-org/pixelwolf-actions/actions/deploy-lambda@main
        with:
          function-name: "my-lambda-function"
          image: "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-repo:latest"
```

## Inputs

### `function-name`
- **Description**: The name of the AWS Lambda function to update.
- **Type**: `string`
- **Required**: Yes

### `image`
- **Description**: The URI of the new container image to deploy to the Lambda function.
- **Type**: `string`
- **Required**: Yes

## Outputs

This action does not produce explicit outputs.

## Notes

- **AWS Credentials**: Ensure the `aws-actions/configure-aws-credentials` action is configured with the necessary AWS access key and secret access key in your workflow.
- **Permissions**: The IAM role or user associated with your AWS credentials must have permission to update the Lambda function image.
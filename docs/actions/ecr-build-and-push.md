# ECR Build and Push

A GitHub Action to build a Docker image and push it to an Amazon Elastic Container Registry (ECR). This action streamlines the process of containerizing your application and publishing it to AWS.

## Features

- **Automated Tagging**: Derives the Docker image tag from the GitHub commit hash if no custom tag is provided.
- **ECR Authentication**: Automatically handles authentication with Amazon ECR using `aws-actions/amazon-ecr-login`.
- **Flexible Build Context**: Supports custom build contexts for the Docker image.
- **Push to ECR**: Publishes both the specific tag and the `latest` tag to the specified ECR repository.

## Inputs

### `repository`
- **Description**: The name of the ECR repository to push the Docker image to.
- **Type**: `string`
- **Required**: Yes

### `tag`
- **Description**: The Docker image tag. If not provided, defaults to the GitHub commit hash.
- **Type**: `string`
- **Required**: No

### `context`
- **Description**: The build context for the Docker image. Can be a path or URL.
- **Type**: `string`
- **Default**: .
- **Required**: No

### `dockerfile`
- **Description**: The path to the Dockerfile.
- **Type**: `string`
- **Default**: `./Dockerfile`
- **Required**: No

## Outputs

### `image`
- **Description**: The full URI of the Docker image pushed to the ECR repository.

## Usage

Below is an example of how to use this action in your GitHub workflow:

```yaml
name: Build and Push to ECR

on:
  push:
    branches:
      - main

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Build and Push Docker Image
        id: build
        uses: pixelwolf-org/pixelwolf-actions/actions/ecr-build-and-push@feature/web-ci-cd
        with:
          repository: my-ecr-repo
          tag: v1.0.0
          context: ./app

      - name: Print Image URI
        run: |
          echo "Docker Image URI: ${{ steps.build.outputs.image }}"
```

## Notes

- **AWS Credentials**: Ensure the aws-actions/configure-aws-credentials action is configured with the necessary AWS access key and secret access key in your workflow.
- **Permissions**: The IAM role or user associated with your AWS credentials must have permissions to push to the specified ECR repository.
- **Registry Authentication**: This action handles ECR login automatically using the `aws-actions/amazon-ecr-login` action.
- **Default Tagging**: If no tag is provided, the first 7 characters of the current GitHub commit hash are used.

---

For additional information, consult the [AWS ECR documentation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html).
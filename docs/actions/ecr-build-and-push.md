# ECR Build and Push

A GitHub Action to build a Docker image and push it to Amazon Elastic Container Registry (ECR).
This action streamlines the process of containerizing your application and publishing it to AWS.

## Features

* **Automated Tagging**: Uses a custom tag if provided, otherwise falls back to the GitHub commit hash.
* **ECR Authentication**: Automatically handles authentication with Amazon ECR using `aws-actions/amazon-ecr-login`.
* **Flexible Build Context**: Supports custom build contexts for the Docker image.
* **Digest Reference**: Exposes the built image by digest for reliable deployment.

## Inputs

### `repository`

* **Description**: The name of the ECR repository where the Docker image will be pushed.
* **Type**: `string`
* **Required**: Yes

### `tag`

* **Description**: The Docker image tag. Defaults to the short Git commit hash if not provided.
* **Type**: `string`
* **Required**: No

### `platform`

* **Description**: Target platform for the Docker image build (e.g., `linux/amd64`, `linux/arm64`).
* **Type**: `string`
* **Default**: `linux/arm64`
* **Required**: No

### `context`

* **Description**: The build context for the Docker image. Can be a local path or a URL.
* **Type**: `string`
* **Default**: `.`
* **Required**: No

### `dockerfile`

* **Description**: The path to the Dockerfile.
* **Type**: `string`
* **Default**: `./Dockerfile`
* **Required**: No

## Outputs

### `image`

* **Description**: The full image URI (including digest) of the built and pushed Docker image in ECR.

## Usage

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

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v6
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Build and Push Docker Image
        id: build
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/ecr-build-and-push@main
        with:
          repository: my-ecr-repo
          tag: v1.0.0
          context: ./app
          dockerfile: ./app/Dockerfile
          platform: linux/amd64
```

## Notes

* **AWS Credentials**: Ensure `aws-actions/configure-aws-credentials` is configured with appropriate AWS access keys.
* **Permissions**: The IAM role/user must have permissions to push to the target ECR repository.
* **Registry Authentication**: ECR login is automatically handled using `aws-actions/amazon-ecr-login`.
* **Default Tagging**: If no `tag` is provided, the first seven characters of the Git commit SHA are used.

---

For additional information, consult the [AWS ECR documentation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html).

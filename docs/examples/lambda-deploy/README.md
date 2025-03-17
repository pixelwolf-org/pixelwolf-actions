# Workflow to Deploy Docker Image to ECS

## Description

This workflow automates the deployment of a Docker image to a Lambda Function. It leverages GitHub Actions to build, push, and deploy Docker images. By integrating AWS OpenID Connect (OIDC), it securely configures credentials for deployment.

## Features

- Automatically builds and pushes a Docker image to Amazon Elastic Container Registry (ECR).
- Deploys the Docker image to a Lambda Function.
- Uses AWS OIDC for secure and seamless AWS credential management.
- Configurable variables for flexibility across different environments.

## Actions

For more details, check the `github-actions` documentation:

- [pixelwolf-org/ecr-build-and-push](../../actions/ecr-build-and-push)
- [pixelwolf-org/lambda-deploy](../../actions/lambda-deploy)
- [actions/checkout](https://github.com/actions/checkout)
- [aws-actions/configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials)

## Placeholders

The following placeholders should be replaced by real values before use:

### `<env>`

**Description**: The environment to which the workflow deploys.

**Options**: `STAGE`, `PROD`

### `<branch>`

- **Description**: The branch that triggers the deployment workflow.
- **Options**: `main`, `stage`

### `<ecr-repository-name>`

- **Description**: The name of the Amazon ECR repository where the Docker image will be stored.
- e.g. `my-ecr-app-repo`

### `<function-name>`

- **Description**: The name of the lambda function to be deployed.
- e.g. `my-lambda-function`.

## Notes

- Do not forget to configure secrets (`AWS_REGION`, `OIDC_ROLE`) on the GitHub repository.
- Check if the `OIDC-role` was already created on AWS with appropriated permissions.
- Replace the placeholders with real values before using the workflow.

# Workflow to Deploy Docker Image to ECS

## Description

This workflow automates the deployment of a Docker image to an Amazon Elastic Container Service (ECS) cluster. It leverages GitHub Actions to build, push, and deploy Docker images. By integrating AWS OpenID Connect (OIDC), it securely configures credentials for deployment.

## Features

- Automatically builds and pushes a Docker image to Amazon Elastic Container Registry (ECR).
- Deploys the Docker image to an ECS service.
- Uses AWS OIDC for secure and seamless AWS credential management.
- Configurable variables for flexibility across different environments.

## Actions

For more details, check the `github-actions` documentation:

- [pixelwolf-org/ecr-build-and-push](https://github.com/pixelwolf-org/pixelwolf-actions/tree/main/actions/ecr-build-and-push)
- [pixelwolf-org/ecs-deploy](https://github.com/pixelwolf-org/pixelwolf-actions/tree/main/actions/ecs-deploy)
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

### `<ecs-cluster>`

- **Description**: The name of the ECS cluster where the service is deployed.
- e.g. `my-ecs-cluster`.

### `<ecs-service>`

- **Description**: The name of the ECS service to deploy to.
- e.g. `my-ecs-service`

### `<ecs-container>`

- **Description**: The name of the ECS container definition to update.
- e.g. `my-container`

### `<ecs-task-definition>`

- **Description**: The task definition family name for the ECS service.
- e.g. `my-task-family`

### `<aws-oidc-role-arn>`

- **Description**: The AWS IAM role ARN to assume via OIDC for authentication.
- e.g. `my-app-deploy-role`

## Notes

- Do not forget to configure secrets (`AWS_REGION`, `OIDC_ROLE`) on the GitHub repository.
- Check if the `OIDC-role` was already created on AWS with appropriated permissions.
- Replace the placeholders with real values before using the workflow.

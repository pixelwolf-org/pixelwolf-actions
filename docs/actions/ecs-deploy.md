# ECS Deploy

A GitHub Action to automate the deployment of an Amazon ECR image to Amazon ECS. This action updates the ECS task definition with the new image and deploys it to the specified service in the ECS cluster.

## Features

- Automates task definition updates with the latest container image.
- Deploys updated task definitions to the specified ECS service.
- Ensures service stability after deployment.

## Inputs

### `ecr-image`
- **Description**: The URI of the Amazon ECR image to deploy.
- **Required**: Yes

### `ecs-cluster`
- **Description**: The name of the Amazon ECS cluster.
- **Required**: Yes

### `ecs-service`
- **Description**: The name of the Amazon ECS service.
- **Required**: Yes

### `ecs-container`
- **Description**: The name of the container in the ECS task definition to update.
- **Required**: Yes

### `ecs-task-definition`
- **Description**: The family name of the Amazon ECS task definition.
- **Required**: Yes

## Outputs

No explicit outputs are provided. The action logs deployment progress to the console.

## Usage

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Set AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Deploy to ECS
        uses: pixelwolf-org/pixelwolf-actions/actions/ecs-deploy@feature/web-ci-cd
        with:
          ecr-image: my-account-id.dkr.ecr.us-east-1.amazonaws.com/my-image:latest
          ecs-cluster: my-cluster
          ecs-service: my-service
          ecs-container: my-container
          ecs-task-definition: my-task-definition
```

## Notes

- Ensure that the AWS credentials are properly configured in your workflow.
- The `aws-actions/amazon-ecs-render-task-definition` and `aws-actions/amazon-ecs-deploy-task-definition` actions are used internally.
- Logs provide detailed deployment information for troubleshooting.
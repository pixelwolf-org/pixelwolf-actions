# ECS Deploy

A GitHub Action to automate the deployment of an Amazon ECR image to Amazon ECS.
This action updates the ECS task definition with the new image and deploys it to the specified service in the ECS cluster.

## Features

* Automates task definition updates with the latest container image.
* Deploys updated task definitions to the specified ECS service.
* Optionally waits for service stability after deployment.
* Provides validation for boolean and integer inputs.

## Inputs

### `ecr-image`

* **Description**: The URI of the Amazon ECR image to deploy.
* **Required**: Yes

### `ecs-cluster`

* **Description**: The name of the Amazon ECS cluster.
* **Required**: Yes

### `ecs-service`

* **Description**: The name of the Amazon ECS service.
* **Required**: Yes

### `ecs-container`

* **Description**: The name of the container in the ECS task definition to update.
* **Required**: Yes

### `ecs-task-definition`

* **Description**: The family name (or full ARN) of the Amazon ECS task definition.
* **Required**: Yes

### `ecs-wait-for-service-stability`

* **Description**: Whether to wait for the ECS service to reach a stable state after deployment.
* **Type**: `bool` (`true` | `false`)
* **Default**: `false`
* **Required**: No

### `ecs-wait-for-service-stability-timeout`

* **Description**: The number of minutes to wait for the ECS service to reach stability (if enabled).
* **Type**: `int`
* **Default**: `5`
* **Required**: No

## Outputs

This action has no explicit outputs.
Deployment details and progress are logged to the console.

## Usage

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Deploy to ECS
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/ecs-deploy@main
        with:
          ecr-image: my-account-id.dkr.ecr.us-east-1.amazonaws.com/my-image:latest
          ecs-cluster: my-cluster
          ecs-service: my-service
          ecs-container: my-container
          ecs-task-definition: my-task-definition
          ecs-wait-for-service-stability: true
          ecs-wait-for-service-stability-timeout: 10
```

## Notes

* Ensure AWS credentials are configured using `aws-actions/configure-aws-credentials`.
* The action internally uses:
  * [`aws-actions/amazon-ecs-render-task-definition`](https://github.com/aws-actions/amazon-ecs-render-task-definition)
  * [`aws-actions/amazon-ecs-deploy-task-definition`](https://github.com/aws-actions/amazon-ecs-deploy-task-definition)
* Input validation ensures:
  * `ecs-wait-for-service-stability` must be `"true"` or `"false"`.
  * `ecs-wait-for-service-stability-timeout` must be an integer greater than 0.
* Detailed logs are provided for visibility and troubleshooting.
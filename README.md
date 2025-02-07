# Pixelwolf Actions

Welcome to the **Pixelwolf Actions** repository! This repository serves as the centralized hub for all custom GitHub Actions utilized across our organization. By consolidating reusable actions in one place, we streamline pipeline development, ensure consistency, and enhance the scalability of our CI/CD workflows.

## Purpose

The **Pixelwolf Actions** repository is built to:

1. **Enhance Reusability**: Share custom GitHub Actions across projects, eliminating redundant code and logic.  
2. **Standardize Pipelines**: Enforce consistency and best practices across all CI/CD workflows.  
3. **Simplify Maintenance**: Centralize updates to custom actions, enabling seamless improvements across multiple projects.

## Actions

| **Action Name**                                     | **Description**                                   |
|-----------------------------------------------------|---------------------------------------------------|
| [ruff-lint](./actions/ruff-lint/)                   | Runs the Ruff linter to identify coding issues.   |
| [ruff-format](./actions/ruff-format/)               | Ensures consistent code formatting with Ruff.     |
| [ecr-build-and-push](./actions/ecr-build-and-push/) | Builds and pushes Docker images to AWS ECR.       |
| [ecs-deploy](./actions/ecs-deploy/)                 | Deploys an Amazon ECR image to an ECS cluster.    |
| [lambda-deploy](./actions/lambda-deploy/)           | Deploys an Amazon ECR image to a Lambda Function. |

## Workflows

### [Deploy a Docker Image to ECS](./examples/ecs-deploy)
This example demonstrates how to use the `ecr-build-and-push` and `ecs-deploy` actions to build, push, and deploy a Docker image to an ECS cluster.

### [Deploy a Docker Image to Lambda Function](./examples/lambda-deploy)
This example demonstrates how to use the `ecr-build-and-push` and `lambda-deploy` actions to build, push, and deploy a Docker image to a Lambda Function.

## Contributing

### Repository Structure

All custom actions are organized under the `./actions` directory to maintain a consistent structure:  

```
pixelwolf-actions/ 
├── README.md 
├── actions/ 
│   ├── my-action/ 
│   │   ├── action.yml 
│   │   └── README.md 
├── examples/ 
│   ├── my-example/ 
│   │   ├── workflow.yml 
│   │   └── README.md 
```

**Key Components**

- **`README.md`**: High-level documentation for the repository.  
- **`actions/`**: Contains subdirectories for each action. 
  - **`my-action/`**: Each action folder includes:
    - **`action.yml`**: Defines the action's metadata and functionality.  
    - **`README.md`**: Provides action-specific documentation, including input parameters, output details, and usage examples.  
- **`examples/`**: Includes example workflows and related documentation for better understanding and usage:
  - **`my-example/`**: Each example folder includes:
    - **`workflow.yml`**: Demonstrates how to implement a complete workflow by using the actions.
    - **`README.md`**: Provides workflow documentation, including placeholder, used actions and configurations.

We welcome contributions to improve and expand our custom actions. Follow these guidelines when contributing:

### Adding a New Action

1. Create a new folder under `./actions/` with the action name (e.g., `new-action`).  
2. Add an `action.yml` file to define the action's functionality.  
3. Include a `README.md` with clear documentation for inputs, outputs, and usage examples.  
4. Test the action in a sample workflow before pushing changes to the repository.  

### Updating an Existing Action

1. Update the relevant files in the action's directory.  
2. Test your changes in a workflow to ensure they work as expected.  
3. Revise the action's documentation (`README.md`) if necessary.

### Guidelines

- Follow naming conventions and keep actions modular and reusable.  
- Maintain thorough documentation to simplify onboarding and usage.  
- Rigorously test all changes before committing.

## Notes

This repository is **internal** and must not be shared publicly.  

All actions are tailored to work seamlessly with our organization's standard CI/CD pipelines. If you encounter issues or have suggestions, please send a pull request.

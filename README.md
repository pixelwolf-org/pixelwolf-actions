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
| [amplify-branch-delete](./actions/amplify-branch-delete/) | Deletes an AWS Amplify branch. |
| [amplify-deploy](./actions/amplify-deploy/)         | Deploys to AWS Amplify.                           |


## Workflows

| **Workflow Name**                                     | **Description**                                   |
|-----------------------------------------------------|---------------------------------------------------|
| [web-ci](./workflows/web-ci.yml)                    | Web CI Workflow for continuous integration.       |
| [web-ci-cd](./workflows/web-ci-cd.yml)              | Production CI/CD that runs when a pull request to main is closed. |


## Contributing

### Repository Structure

All custom actions are organized under the `./actions` directory to maintain a consistent structure:  

```
.
└── pixelwolf-actions/
    ├── .github/
    │   ├── actions/
    │   │   └── action-name.yml
    │   └── workflows/
    │       └── workflow-name.yml
    └── docs/
        ├── actions/
        │   └── action-name.md
        ├── workflows/
        │   └── workflow-name.md
        └── examples/
            └── examples-docs.md
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
- **`workflows/`**: Contains reusable workflow templates that can be referenced across projects:
  - **`my-workflow/`**: Each workflow folder includes:
    - **`workflow.yml`**: Defines the reusable workflow configuration.
    - **`README.md`**: Documents the workflow's purpose, inputs, and implementation details.

We welcome contributions to improve and expand our custom actions. Follow these guidelines when contributing:

### Adding a New Action

1. Create a new folder under `./actions/` with the action name (e.g., `new-action`).  
2. Add an `action.yml` file to define the action's functionality.  
3. Include a `README.md` with clear documentation for inputs, outputs, and usage examples.  
4. Test the action in a sample workflow before pushing changes to the repository.  

### Adding a New Workflow

1. Create a new folder under `./workflows/` with the workflow name (e.g., `new-workflow`).
2. Add a `workflow.yml` file to define the reusable workflow configuration.
3. Include a `README.md` with comprehensive documentation covering:
   - Purpose and use cases
   - Required inputs and configurations
   - Implementation examples
4. Test the workflow in a sample project before committing.

### Updating an Existing Action or Workflow

1. Update the relevant files in the action's or workflow's directory.  
2. Test your changes thoroughly to ensure they work as expected.  
3. Revise the documentation (`README.md`) to reflect any modifications.
4. If updating a workflow, verify compatibility with existing implementations.

### Guidelines

- Follow naming conventions and keep actions modular and reusable.  
- Maintain thorough documentation to simplify onboarding and usage.  
- Rigorously test all changes before committing.

## Notes

This repository is **internal** and must not be shared publicly.  

All actions are tailored to work seamlessly with our organization's standard CI/CD pipelines. If you encounter issues or have suggestions, please send a pull request.


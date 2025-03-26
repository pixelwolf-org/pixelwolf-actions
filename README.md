# Pixelwolf Actions


Welcome to the **Pixelwolf Actions** repository! This repository serves as the centralized hub for all custom GitHub Actions utilized across our organization.

## Table of Contents

- [Pixelwolf Actions](#pixelwolf-actions)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Purpose](#purpose)
  - [Actions](#actions)
    - [Deployment](#deployment)
    - [Python](#python)
    - [Utilities](#utilities)
  - [Workflows](#workflows)
  - [Contributing](#contributing)
    - [Repository Structure](#repository-structure)
    - [Adding a New Action](#adding-a-new-action)
    - [Adding a New Workflow](#adding-a-new-workflow)
    - [Updating an Existing Action or Workflow](#updating-an-existing-action-or-workflow)
    - [Guidelines](#guidelines)
  - [Notes](#notes)

## Overview

The **Pixelwolf Actions** repository is built to enhance reusability, standardize pipelines, and simplify maintenance. By sharing custom GitHub Actions across projects, we eliminate redundant code and logic, enforce best practices, and enable seamless improvements across multiple projects. 

This documentation provides an overview of the available actions, example workflows, and guidelines for contributing to the repository.


## Purpose

The **Pixelwolf Actions** repository is built to:

1. **Enhance Reusability**: Share custom GitHub Actions across projects, eliminating redundant code and logic.  
2. **Standardize Pipelines**: Enforce consistency and best practices across all CI/CD workflows.  
3. **Simplify Maintenance**: Centralize updates to custom actions, enabling seamless improvements across multiple projects.

## Actions

### Deployment

| **Action Name**                                                  | **Description**                                   |
|------------------------------------------------------------------|---------------------------------------------------|
| [amplify-branch-delete](./docs/actions/amplify-branch-delete.md) | Deletes an AWS Amplify branch.                    |
| [amplify-deploy](./docs/actions/amplify-deploy.md)               | Deploys to AWS Amplify.                           |
| [ecr-build-and-push](./docs/actions/ecr-build-and-push.md)       | Builds and pushes Docker images to AWS ECR.       |
| [ecs-deploy](./docs/actions/ecs-deploy.md)                       | Deploys an Amazon ECR image to an ECS cluster.    |
| [lambda-deploy](./docs/actions/lambda-deploy.md)                 | Deploys an Amazon ECR image to a Lambda Function. |
| [terraform-apply](./docs/actions/terraform-apply.md)             | Applies Terraform changes for infrastructure.     |


### Python

| **Action Name**                                | **Description**            |
|------------------------------------------------|----------------------------|
| [setup-python](./docs/actions/setup-python.md) | Sets up Python and Poetry. |

### Utilities

| **Action Name**                                                            | **Description**                                             |
|----------------------------------------------------------------------------|-------------------------------------------------------------|
| [gh-app-access-token](./docs/actions/gh-app-access-token.md)               | Generates GitHub App Short Lived access-token.              |
| [gh-create-or-update-secret](./docs/actions/gh-create-or-update-secret.md) | Create or update a secret via the GitHub API.               |
| [jwt](./docs/actions/jwt.md)                                               | Generates a JWT using the specified issuer and private key. |
| [pr-changed-files](./docs/actions/pr-changed-files.md)                     | Retrieves a list of changed files in a pull request (PR).   |

## Workflows

| **Workflow Name**                          | **Description**                                                   |
|--------------------------------------------|-------------------------------------------------------------------|
| [web-ci](./docs/workflows/web-ci.md)       | Web CI Workflow for continuous integration.                       |
| [web-ci-cd](./docs/workflows/web-ci-cd.md) | Production CI/CD that runs when a pull request to main is closed. |


## Contributing

### Repository Structure

All custom actions are organized under the `./actions` directory to maintain a consistent structure:  

```
.
└── pixelwolf-actions/
    ├── .github/
    │   ├── actions/
    │   │   └── action-name/
    │   │       └── action-name.yml
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
- **`.github/actions/`**: Contains subdirectories for each action. 
  - **`action-name/action.yml`**: Defines the action's metadata and functionality.  
- **`.github/workflows/`**: Contains reusable workflow templates that can be referenced across projects:
  - **`workflow-name.yml`**: Defines the reusable workflow configuration.
- **`docs/`**: Includes documentation for actions, workflows, and examples:
  - **`actions/`**: Contains documentation for each action.
    - **`action-name.md`**: Provides action-specific documentation, including input parameters, output details, and usage examples.
  - **`workflows/`**: Contains documentation for each workflow.
    - **`workflow-name.md`**: Documents the workflow's purpose, inputs, and implementation details.
  - **`examples/`**: Includes example workflows and related documentation for better understanding and usage.
    - **`examples-docs.md`**: Provides workflow documentation, including placeholder, used actions, and configurations.

We welcome contributions to improve and expand our custom actions. Follow these guidelines when contributing:

### Adding a New Action

1. Create a new file under `.github/actions/action-name/` with the action name (e.g., `action.yml`).  
2. Include an `action-name.md` readme in `docs/actions/` with comprehensive documentation covering:
   - **Comprehensive Action Description**: Explain the purpose of the action and provide a step-by-step overview of how it operates.
   - **Feature List**: Highlight the key functionalities and capabilities offered by the action.  
   - **Usage Guide**: Provide detailed instructions on how to set up and execute the action.  
   - **Inputs Reference**: Document all input parameters, including descriptions, expected values, and defaults.
   - **Outputs Reference**: List and explain the action outputs, detailing their format and usage.
   - **Important Notes & Requirements**: Include any prerequisites, warnings, or special configurations necessary for proper action execution. 
3. Test the action in a sample workflow before pushing changes to the repository.  

### Adding a New Workflow

1. Create a new file under `.github/workflows/` with the workflow name (e.g., `new-workflow.yml`).
2. Include a `workflow-name.md` readme in `docs/workflows/` with comprehensive documentation covering:
   - **Comprehensive Workflow Description**: Explain the purpose of the workflow and provide a step-by-step overview of how it operates.  
   - **Feature List**: Highlight the key functionalities and capabilities offered by the workflow.
   - **Usage Guide**: Provide detailed instructions on how to set up and execute the workflow, including code examples.
   - **Inputs Reference**: Document all input parameters, including descriptions, expected values, and defaults.
   - **Outputs Reference**: List and explain the workflow outputs, detailing their format and usage.
   - **Important Notes & Requirements**: Include any prerequisites, warnings, or special configurations necessary for proper workflow execution.

### Updating an Existing Action or Workflow

1. Update the relevant files in the action's or workflow's directory.  
2. Test your changes thoroughly to ensure they work as expected.  
3. Revise the documentation to reflect any changes.
4. Verify compatibility with existing implementations.

### Guidelines

- Follow naming conventions and keep actions modular and reusable.  
- Maintain thorough documentation to simplify onboarding and usage.  
- Rigorously test all changes before committing.

## Notes

This repository is **internal** and must not be shared publicly.  

All actions are tailored to work seamlessly with our organization's standard CI/CD pipelines. If you encounter issues or have suggestions, please send a pull request.
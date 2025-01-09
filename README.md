# Pixelwolf Actions

Welcome to the **Pixelwolf Actions** repository! This internal repository centralizes all custom GitHub Actions used across our organization, simplifying the construction and maintenance of pipelines. By hosting reusable actions in one place, we ensure consistency, efficiency, and scalability for our CI/CD workflows.

## Purpose

The **Pixelwolf Actions** repository is designed to:

1. **Promote Reusability**: Share custom actions across projects to avoid duplicating logic.
2. **Standardize Pipelines**: Ensure consistency and best practices in our CI/CD workflows.
3. **Simplify Maintenance**: Centralize action updates, making it easy to propagate improvements across projects.

## Actions

| Action Name                             | Description                            |
|-----------------------------------------|----------------------------------------|
| [ruff-lint](.github/actions/ruff-lint/) | Runs Ruff linter on the project files. |


## Repository Structure

All the actions must be stored on the `.github/actions` folder, as seen bellow:

```
pixelwolf-actions/ 
├── README.md 
├── .github/ 
│ ├── actions/ 
│ │ ├── action-1/ 
│ │ │ ├── action.yml 
│ │ │ └── README.md 
│ │ ├── action-2/ 
│ │ │ ├── action.yml 
│ │ │ └── README.md 
│ │ └── action-n/ 
│ │ ├── action.yml 
│ │ └── README.md
```

- **`README.md`**: Repository overview and usage guide.
- **`.github/actions/`**: Contains subdirectories for each custom action. Each action has:
  - `action.yml`: Defines the action's metadata and execution logic.
  - `README.md`: Documentation specific to the action, including inputs, outputs, and usage examples.

## Usage Example

```yaml
name: Example Workflow

on:
  push:
    branches:
      - main

jobs:
  example:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Run Linter
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/ruff-lint@main
```

## Contributing

### Adding a New Action

1. Create a new directory under `.github/actions/` with the desired action name (e.g., `action-new).
2. Add an `action.yml` file to define the action.
3. Write a `README.md` file with detailed documentation for the new action.
4. Test the action in a workflow before pushing it to the repository.

### Updating an Existing Action
1. Modify the relevant files in the action's subdirectory.
2. Test the updates in a workflow to ensure functionality.
3. Update the action's `README.md` if necessary.

### Guidelines

- Follow naming conventions and organizational best practices.
- Ensure actions are modular, reusable, and well-documented.
- Test all changes thoroughly.

## Notes

This repository is internal to our organization and should not be shared publicly.

All actions are designed for compatibility with our standard CI/CD pipelines.

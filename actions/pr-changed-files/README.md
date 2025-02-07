# Get Changed Files

This action retrieves a list of changed files in a pull request (PR), with optional filtering based on file extensions or patterns.

## Features

- **Retrieve Changed Files**: Automatically fetches the files that have changed for a PR workflow trigger.
- **File Filtering**: Users can specify file extensions or patterns to refine the output.

## Usage

```yaml
name: 'CI Workflow'
description: 'Runs checks on pull requests'

run-name: 'Checks for PR #${{ github.event.pull_request.number }}'

on:
  pull_request:
    types: [opened, reopened, synchronize]
    branches: ['*']

permissions:
  checks: write
  contents: write

jobs:
  my-job:
    name: My Job
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Get Changed Python Files
        uses: pixelwolf-org/pixelwolf-actions/actions/ecs-deploy@main
        id: changed-files
        with:
          filter: '*.py'
```

> ⚠️ This action is designed to work exclusively with workflows triggered by the `on: pull_request` configuration. Additionally, setting `fetch-depth: 0` during the checkout step is essential for the action to function correctly.

## Inputs

### `filter`
- **Description**: A space-separated list of file extensions or patterns to include in the output (e.g., `*.py *.html`). If not specified, all changed files will be returned.
- **Type**: String
- **Required**: No

## Outputs

### `changed-files`
- **Description**: A space-separated list of changed files that match the specified filters.

## Notes

- **Filtering Options**: You can filter specific files or extensions and exclude others:
  - **Exclude**: Use `':(exclude)path'` or `':(exclude)*.py'`
  - **Include**: Use `'path/to/file.txt'` or `'*.txt'`
  
  **Examples**:
  - Include only Python files while excluding a specific file: `'*.py :(exclude)src/config.py'`
  - Exclude multiple extensions: `':(exclude)*.json :(exclude)*.md'`

---

For more information about `git-diff`, refer to the [git documentation](https://git-scm.com/docs/git-diff).

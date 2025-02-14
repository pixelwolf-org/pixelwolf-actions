# Web CI Workflow

A GitHub Actions workflow for continuous integration (CI) of web applications. This workflow is designed to ensure code quality and consistency by running a series of checks on the codebase.

## Features

- Checks out the code from the repository
- Sets up the latest Node.js environment
- Installs dependencies
- Formats the code
- Lints the code
- Builds the application

## Usage

This workflow is triggered by a workflow call and is designed to be reusable across different projects or branches.

```yaml
name: Web CI Workflow

on:
  workflow_call:

jobs:
  ci:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
      contents: write

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 'latest'

      - name: Install dependencies
        run: npm install

      - name: Format code
        run: npm run format

      - name: Lint
        run: npm run lint

      - name: Build
        run: npm run build
```
## Inputs
This workflow does not require any specific inputs as it is designed to run standard CI checks.

## Outputs
This workflow does not produce explicit outputs.
  
## Notes

Important: to run this workflow successfully, make sure to implement the format, lint and build scripts inside your package.json

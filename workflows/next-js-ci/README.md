# Next.js CI Workflow

A reusable GitHub Actions workflow for Next.js projects that handles code formatting, linting, and building. This workflow uses `bun` as the package manager for faster execution.

## Features

- Automated code formatting using Prettier
- Next.js linting checks
- Production build verification
- Uses Bun for improved performance

## Inputs

### `node-version`
- **Description**: The version of Node.js to use
- **Default**: `'latest'`
- **Required**: No

## Permissions

The workflow requires the following permissions:
- `pull-requests: write`
- `contents: write`

## Usage

### Basic Example

```yaml
name: CI

on:
  pull_request:
    branches: [main, stage]

jobs:
  ci:
    permissions:
      contents: write
      pull-requests: write
    uses: pixelwolf-org/pixelwolf-actions/workflows/next-ci-workflow.yml
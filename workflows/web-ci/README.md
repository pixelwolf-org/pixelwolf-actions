# Web CI Workflow

A reusable GitHub Actions workflow for web projects that handles code formatting, linting, and building. This workflow uses `npm` as the package manager.

## Features

- Automated code formatting
- Code linting
- Production build verification
- Uses Node.js with npm

## Inputs

No required inputs. The workflow uses default configurations:
- Node.js version: 'latest'

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
    uses: pixelwolf-org/pixelwolf-actions/workflows/web-ci@main

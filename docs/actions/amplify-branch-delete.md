# AWS Amplify Branch Delete Action

A GitHub Action to delete a branch from an AWS Amplify application. This action is useful for cleaning up branches that are no longer needed in your Amplify environment.

## Features

- Deletes a specified branch from an AWS Amplify application
- Utilizes the AWS Amplify CLI for branch management
- Configurable via inputs for flexibility

## Usage

This action can be used in any GitHub workflow where you need to manage branches in AWS Amplify.

```yaml
name: Delete Amplify Branch

on:
  workflow_dispatch:

jobs:
  delete-branch:
    runs-on: ubuntu-latest
    steps:
      - name: Delete Amplify Branch
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/amplify-branch-delete@main
        with:
          app-id: 'app-id'
          branch-name: 'feature-branch-to-delete'
```

## Inputs

### `app-id`
- Description : The ID of your AWS Amplify application.
- Required : Yes
### `branch-name`
- Description : The name of the branch to delete.
- Required : Yes
  
## Outputs
This action does not produce explicit outputs.
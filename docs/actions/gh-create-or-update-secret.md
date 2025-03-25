# Create or Update Secret

A GitHub Action to create or update a secret via the GitHub API.

## Features

- Create or update a secret in repository.
- Create or update a secret in repository dependabot.
- Supports secure access using GitHub tokens.

## Usage

```yaml
name: 'Update Repository Secret Workflow'

on:
  push:
    branches:
      - '*'

jobs:
  update-secret:
    runs-on: ubuntu-latest
    steps:
      - name: 'Update Repository Secret'  
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/gh-create-or-update-secret@main
        with:
          secret-name: 'MY_SECRET'
          secret-value: 'Value'
          secret-type: 'repository'
          github-token: '<github-token>'
```

## Inputs

### secret-name

- **Description**: The name of the secret to be created or updated in the repository.
- **Required**: Yes

### secret-value

- **Description**: The value to be stored in the secret.
- **Required**: Yes

### secret-type

- **Description**: The type of secret to be created or updated (e.g., repository).
- **Required**: Yes
- **Default**: `repository`
- **Options**: `repository`, `repository-dependabot`

### github-token

- **Description**: A Personal Access Token or GitHub Actions token with sufficient permissions to manage secrets in the repository.
- **Required**: Yes

## Outputs

This action does not produce explicit outputs.

## Notes

- Ensure the `github-token` used has sufficient permissions to manage secrets in the repository.
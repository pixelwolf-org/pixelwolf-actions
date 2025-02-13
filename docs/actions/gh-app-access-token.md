# GitHub App Token Generator

Generates GitHub App Short Lived access-token.

## Features

- **Access Token Retrieval**: Generates GitHub App Short Lived access-token.

## Usage

```yaml
name: 'My Workflow'

on:
  push:
    branches:
      - 'main'

jobs:
  generate-gh-app-token:
    runs-on: ubuntu-latest
    steps:
      - name: 'Generate Token'
        id: gh-app-token
        uses: pixelwolf-org/pixelwolf-actions/actions/gh-app-token@main
        with:
          app-id: your-app-id
          installation-id: your-app-installation-id
          private-key: ${{ secrets.GH_APP_PRIVATE_KEY }}
```

## Inputs

### app-id

- **Description**: GitHub App ID
- **Type**: String
- **Required**: Yes

### installation-id

- **Description**: GitHub App Installation ID
- **Type**: String
- **Required**: Yes

### private-key

- **Description**: GitHub App private key (PEM format)
- **Type**: String
- **Required**: Yes

## Outputs

### access-token

- **Description**: The GitHub App installation access-token

## Notes

- **Private Key**: Ensure that you have created the secret `GH_APP_PRIVATE_KEY` or are using an existing organization secret. This private key is essential for generating the JWT token for your GitHub App.
- **JWT Action Dependency**: This action requires the use of the GitHub Action JWT to function properly.


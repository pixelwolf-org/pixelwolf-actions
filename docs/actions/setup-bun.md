# Setup Bun Action

This GitHub Action installs Bun and configures it for use with GitHub Packages. It is designed to work seamlessly with your CI/CD workflows, providing an automated way to set up Bun in your build environment.

## Features

- Installs the latest version of Bun
- Configures Bun to work with GitHub Packages
- Sets up authentication for private packages in the pixelwolf-org scope
- Adds Bun to the PATH for subsequent workflow steps

## Usage

To use this action in your workflow, include the following step:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Setup Bun
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/setup-bun@main
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

### `github-token`

- **Description**: GitHub token for accessing GitHub Packages
- **Required**: No
- **Default**: `${{ github.token }}`

## How It Works

The action performs the following steps:

1. Installs Bun using the official installation script
2. Adds Bun to the PATH for use in subsequent workflow steps
3. Creates a `bunfig.toml` configuration file that sets up authentication for the pixelwolf-org scope to access private packages from GitHub Packages

## Notes

- This action is specifically configured for the pixelwolf-org scope on GitHub Packages
- The GitHub token provided must have appropriate permissions to access the required packages
- The action uses the composite runs type, making it efficient and reusable across workflows

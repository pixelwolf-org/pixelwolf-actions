# Ruff Linter GitHub Action

This GitHub Action runs the [Ruff linter](https://github.com/charliermarsh/ruff) on your project files, helping you maintain clean and consistent code.

## Features
- Lint specific files or directories.
- Optionally use a custom Ruff configuration file.
- Set the minimum severity level for reported issues.

## Inputs

### `files` (Optional)
- **Description**: Comma-separated paths of files or directories to check. If not provided, the linter will run on all files.
- **Default**: `.`

### `config` (Optional)
- **Description**: Path to a custom Ruff configuration file.
- **Default**: Not set.

## Outputs
This action does not produce any specific outputs but logs the linting process and results.

## Usage

### Basic Example

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      ...

      - name: Run Ruff Linter
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/ruff-lint@main
```

### Advanced Example

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      ...

      - name: Run Ruff Linter with custom config
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/ruff-lint@main
        with:
          files: 'src/, tests/'
          config: '.ruff-config.toml'
```

## Notes

- Ensure `poetry` is installed and configured in your environment.
- Use this action in conjunction with other CI tools to maintain high code quality.
- See [Ruff's documentation](https://docs.astral.sh/ruff/) for more details on formatting options and configurations.


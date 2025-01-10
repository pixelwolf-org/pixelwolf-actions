# Ruff Ruff Format

A GitHub Action to run `ruff format --check` on specified or all project files, ensuring consistent code formatting. This action uses `poetry` to execute Ruff.

## Features

- Flexible file selection: Specify files or directories, or run on all files by default.
- Support for custom Ruff configuration files.

## Inputs

### `files`
- **Description**: Comma-separated paths of files or directories to check.
- **Default**: `.`
- **Required**: No

### `config`
- **Description**: Path to a custom Ruff configuration file.
- **Required**: No

## Outputs

No explicit outputs are provided. The action logs results of the format check to the console.

## Usage

### Basic Example

```yaml
jobs:
  format-check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      ...

      - name: Run Ruff Format Check
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/ruff-format@main
```

### Advanced Example

```yaml
jobs:
  format-check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      ...

      - name: Run Ruff Format Check
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/ruff-format@main
        with:
          files: "src/, tests/"
          config: ".ruff.toml"
```

## Notes

- Ensure `poetry` is installed and configured in your environment.
- Use this action in conjunction with other CI tools to maintain high code quality.
- See [Ruff's documentation](https://docs.astral.sh/ruff/) for more details on formatting options and configurations.

# Setup Python Environment

Sets up Python and Poetry with optional caching for dependencies.

## Features

- **Python Setup**: Installs a specified Python version.
- **Poetry Installation**: Installs Poetry with a specified version or the latest available.
- **Dependency Caching**: Optionally enables caching for Poetry and pip dependencies.

## Usage

```yaml
- uses: pixelwolf-org/pixelwolf-actions/actions/setup-python@main
  with:
    python-version: "3.10"
    poetry-version: "1.8.4"
    use-cache: "true"
```

## Inputs

### `python-version`
- **Description**: Python version to install. Example: `"3.12"`
- **Type**: string
- **Required**: Yes

### `poetry-version`
- **Description**: Poetry version to install. Leave empty for the latest version.
- **Type**: string
- **Required**: No

### `use-cache`
- **Description**: Enable caching for Poetry and pip dependencies.
- **Type**: boolean
- **Default**: "true"
- **Required**: No

## Outputs

No explicit outputs are provided. The action logs execution process to the console.

## Notes

- **Virtual Environment**: Poetry is configured to use in-project virtual environments.
- **Cache Strategy**: The cache key is based on OS, Python version, Poetry version, and `poetry.lock`.

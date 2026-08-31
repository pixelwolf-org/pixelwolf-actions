# Setup Python Environment

Sets up Python and Poetry or uv with optional caching for dependencies.

## Features

- **Python Setup**: Installs a specified Python version.
- **Package Manager Support**: Supports both [Poetry](https://python-poetry.org/) and [uv](https://github.com/astral-sh/uv).
- **Dependency Caching**: Optionally enables caching for Poetry, uv, and pip dependencies.

## Usage

### Using Poetry (Default)

```yaml
steps:
  - name: Checkout Code
    uses: actions/checkout@v7

  - name: Setup Python Environment
    uses: pixelwolf-org/pixelwolf-actions/.github/actions/setup-python@main
    with:
      python-version: '3.12'
```

### Using uv

```yaml
steps:
  - name: Checkout Code
    uses: actions/checkout@v7

  - name: Setup Python Environment
    uses: pixelwolf-org/pixelwolf-actions/.github/actions/setup-python@main
    with:
      python-version: '3.12'
      package-manager: 'uv'
```

## Inputs

### `python-version`

- **Description**: Python version to install. Example: `"3.12"`
- **Type**: string
- **Required**: Yes

### `package-manager`

- **Description**: Package manager to use. Options: `poetry`, `uv`.
- **Type**: string
- **Default**: `"poetry"`
- **Required**: No

### `poetry-version`

- **Description**: Poetry version to install. Leave empty for the latest version.
- **Type**: string
- **Required**: No

### `uv-version`

- **Description**: uv version to install. Leave empty for the latest version.
- **Type**: string
- **Required**: No

### `use-cache`

- **Description**: Enable caching for Poetry/uv and pip dependencies.
- **Type**: boolean
- **Default**: "true"
- **Required**: No

## Outputs

No explicit outputs are provided. The action logs execution process to the console.

## Notes

- **Virtual Environment**: When using Poetry, it is recommended to configure it to use in-project virtual environments (`poetry config virtualenvs.in-project true`).
- **Cache Strategy**: The cache key is based on OS, Python version, package manager, version, and the respective lock file (`poetry.lock` or `uv.lock`).

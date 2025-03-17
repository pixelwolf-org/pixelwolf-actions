# S3 to Environment Variables Action

This GitHub Action downloads an environment file from AWS S3 and exports its variables for use in subsequent workflow steps. It provides a secure way to manage and access environment variables stored in S3 during your CI/CD workflows.

## Features

- Downloads environment files from AWS S3
- Automatically exports variables to GitHub Actions environment
- Handles comments and empty lines in environment files
- Secure handling of sensitive information
- Automatic cleanup of downloaded files

## Usage

To use this action in your workflow, include the following step:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Load Environment Variables from S3
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/s3-to-env@main
        with:
          env-s3-path: 's3://your-bucket/path/to/env-file'
```

## Prerequisites

- AWS credentials must be configured in your GitHub Actions workflow
- The AWS role/user must have permissions to read from the specified S3 bucket
- The environment file in S3 should follow the standard `.env` file format

## Inputs

### `env-s3-path`

- **Description**: The full S3 path to the environment file (e.g., 's3://bucket-name/path/to/file')
- **Required**: Yes

## Environment File Format

The action expects the environment file to be in standard `.env` format:

```env
KEY1=value1
KEY2=value2
# This is a comment
KEY3=value3 # Inline comment
```

The action will:

- Skip empty lines and comments (lines starting with #)
- Remove inline comments
- Trim whitespace
- Export each valid key-value pair

## Notes

- Environment variables are exported using GitHub Actions' `GITHUB_ENV` file
- For security, only variable names (not values) are printed to the logs
- The downloaded environment file is automatically cleaned up after processing
- Make sure your AWS credentials are properly configured before using this action

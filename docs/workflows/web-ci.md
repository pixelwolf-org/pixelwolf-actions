# Web CI Workflow

A GitHub Actions workflow for continuous integration (CI) of web applications. This workflow is designed to ensure code quality and consistency by running a series of checks on the codebase.

## Features

- Checks out the code from the repository
- Sets up Bun environment with dependency caching
- Configures GitHub Package Registry access
- Installs dependencies
- Runs format check
- Lints the code
- Builds the application
- Runs unit tests (optional)
- Runs E2E tests with Playwright (optional)

## Usage

This workflow is triggered by a workflow call and is designed to be reusable across different projects or branches.

```yaml
name: Web CI Workflow

on:
  workflow_call:
    inputs:
      should-run-unit-tests:
        description: 'Should run unit tests'
        required: false
        default: 'true'
        type: string
      should-run-e2e-tests:
        description: 'Should run E2E tests'
        required: false
        default: 'false'
        type: string

jobs:
  ci:
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
      contents: write
      packages: read

    steps:
      - uses: actions/checkout@v4

      - name: 'Setup Bun'
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/setup-bun@main
        with:
          github-token: ${{ github.token }}

      - name: 'Install dependencies'
        run: bun install --frozen-lockfile
        shell: bash

      - name: 'Run format (Prettier) check'
        run: bun run format-check

      - name: 'Lint'
        run: bun run lint

      - name: 'Build web app'
        run: bun run build:ci

      - name: 'Run unit tests'
        if: ${{ inputs.should-run-unit-tests == 'true' }}
        run: bun run test

      - name: 'Install Playwright Chromium browser'
        if: ${{ inputs.should-run-e2e-tests == 'true' }}
        run: bunx playwright install chromium --with-deps

      - name: 'Run Playwright tests'
        if: ${{ inputs.should-run-e2e-tests == 'true' }}
        run: bunx playwright test
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.supabase-url }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.supabase-anon-key }}

      - name: 'Upload Playwright report'
        if: ${{ inputs.should-run-e2e-tests == 'true' }}
        uses: actions/upload-artifact@v4
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 30
```

## Inputs

| Name                    | Description               | Required | Default |
| ----------------------- | ------------------------- | -------- | ------- |
| `should-run-unit-tests` | Whether to run unit tests | No       | `true`  |
| `should-run-e2e-tests`  | Whether to run E2E tests  | No       | `false` |

## Outputs

This workflow does not produce explicit outputs, but when E2E tests are run, it uploads the Playwright report as an artifact that can be downloaded from the GitHub Actions UI.

## Notes

Important: to run this workflow successfully, make sure to implement the following scripts in your package.json:

- `format-check`: For checking code formatting (typically using Prettier)
- `lint`: For linting the code
- `build:ci`: For building the application in CI environment
- `test`: For running unit tests (if enabled)

Additionally, if E2E tests are enabled, ensure you have Playwright configured properly in your project.

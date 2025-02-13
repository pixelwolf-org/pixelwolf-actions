# Generate JWT Token

Generates a JSON Web Token (JWT) using the specified issuer and private key. The token can optionally include an expiration time.

## Features

- **Issuer Support**: Allows specifying the JWT issuer (`iss`) for authentication.
- **Private Key Signing**: Utilizes a private key to sign the JWT, ensuring security.
- **Expiration Time**: Optionally specify a token expiration time in seconds (e.g., 1h or 30m), defaulting to 1 hour.

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
      - name: 'Generate JWT Token'
        id: jwt-token
        uses: pixelwolf-org/pixelwolf-actions/.github/actions/jwt@feature/web-ci-cd
        with:
          iss: 'issuer'
          private-key: 'private-key-pem'
          expires-in: '10m'
```

## Inputs

### `iss`

- **Description**: The issuer of the JWT, typically your organization or application name.
- **Type**: `string`
- **Required**: Yes

### `private-key`

- **Description**: The private key used to sign the JWT. Ensure this key is kept secure.
- **Type**: `string`
- **Required**: Yes

### `expires-in`

- **Description**: The expiration time for the JWT in seconds (e.g., "1h" for 1 hour, "30m" for 30 minutes). Defaults to "1h" if not provided.
- **Type**: `string`
- **Default**: `1h`
- **Required**: No

## Outputs

### `token`

- **Description**: The generated JWT token that can be used for authentication or authorization purposes.

## Notes

- **Security Consideration**: Ensure that the `private-key` is securely managed. If possible, use GitHub Secrets to store sensitive data.
- **Expiration Format**: The expiration time must be specified in a valid format, such as "1h" for one hour or "30m" for thirty minutes. Invalid formats may result in errors.

## Contributing

We welcome contributions that enhance the functionality and usability of this action. Please follow the steps below to get started:

1. **Prepare Your Local Environment**:
   - Navigate to the action folder:
     ```bash
     cd ./actions/jwt/
     ```
   - Install the necessary dependencies:
     ```bash
     npm install
     ```

2. **Make Your Changes**:
   - Modify the action code as needed. Ensure you add appropriate comments and documentation for clarity.

3. **Review the Action Documentation**:
   - Take a moment to review the action's `./actions/jwt/README.md` file and ensure it is updated with any new features or changes you've made.

4. **Build the Action**:
   - Before committing your changes, build the action to ensure everything is set up correctly:
     ```bash
     npm run build
     ```

5. **Testing**:
   - Test your changes locally to ensure the action works as expected.

6. **Submit a Pull Request**:
   - When you are ready, submit a pull request with a clear description of the changes made and the rationale behind them. 
 

### Contribution Guidelines
- Please adhere to our coding standards and style guide.
- Ensure that your code is well-documented and includes comments where necessary.
- Follow the existing naming conventions and patterns used in the codebase.
- Review your code for any potential errors or issues before submitting the pull request.


# Contributing to PSFive9Admin

Thanks for your interest in contributing. This module is community-maintained and developed in the open.

## Report Issues

- Search existing issues before opening a new one.
- Include PowerShell version (`$PSVersionTable.PSVersion`).
- Include OS and environment details.
- Provide the full error message and a minimal repro script.

## Request Features

- Describe the Five9 API method or behavior you need.
- Explain the business use case and expected output.
- If possible, reference the official Five9 API documentation.

## Development Setup

1. Clone the repo.
2. Open a PowerShell 7 session.
3. Import the module from the repo root:
   ```powershell
   Import-Module ./PSFive9Admin.psd1 -Force
   ```

## Code Style

- Keep functions in the appropriate `Public/` or `Private/` folder.
- Use consistent parameter naming and verb-noun cmdlet names.
- Prefer clear, explicit variable names over abbreviations.

## Tests

- Run the scripts in the `Tests/` folder before submitting a PR.
- Use `Get-Credential` in any new test scripts.

## Adding New API Methods

1. Find the method in the WSDL:
   ```bash
   grep -A 10 "methodName" Public/AdminWebService/Five9Admin.wsdl
   ```
2. Add the method to `Add-Five9SoapMethods.ps1`.
3. Add parameter mappings if needed.
4. Test in both PowerShell 5.1 and PowerShell 7+ if possible.

## Pull Requests

- Keep changes focused and scoped.
- Update docs when behavior changes.
- Add or update tests when applicable.

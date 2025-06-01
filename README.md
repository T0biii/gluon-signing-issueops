# Gluon Firmware Manifest Signing IssueOps

This repository provides an automated GitHub IssueOps workflow for signing Gluon firmware sysupgrade manifests. It enables maintainers to request and approve firmware manifest signatures via GitHub Issues, with signatures generated and posted automatically after approval from the repository owner.

## Usage

### 1. Requesting a Signature
- Open a new issue using the "Request firmware signature" issue form.
- Fill in the required fields:
  - **Version**: The firmware version (letters, numbers, dot, underscore, dash only)
  - **Release channel**: Select one of `stable`, `testing`, or `experimental`

### 2. Approving a Signature
- The repository owner reviews the issue and, if appropriate, comments:
  > Approve signature
- The workflow will:
  - Download the manifest from the configured firmware URL
  - Sign the manifest using the private key
  - Post the signature as a comment
  - Close the issue

## Setup

### Required Secrets
- `FIRMWARE_SIGNING_KEY`: The private key (in PEM format) used for signing manifests. Add this as a repository secret.

### Repository Variables
- `FIRMWARE_BASE_URL`: The base URL for firmware downloads. E.g.: `https://firmware.ffmuc.net`

### Required Labels
- `signing-request`: Add this label to your repository to categorize signature request issues.

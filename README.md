# Test Tripal GitHub Action

This repo provides a Github Action to make automated testing workflows for Tripal Extension modules easy! It will spin up a specialized docker container, install your module with it's depencies

## Inputs

### `modules-to-install`

**Required** A space-separated list of the machine names of all modules to enable for automated testing. This should include dependencies.

## Outputs

*None yet implemented.* 

## Example usage

uses: actions/test-tripal-action@v1
with:
  modules-to-install: 'tripal tripal_chado'

# Test Tripal GitHub Action

This repo provides a Github Action to make automated testing workflows for Tripal Extension modules easy! It will spin up a specialized docker container, install your module with it's dependencies.

## Inputs

### `directory-name`

**Required** The name of the directory your Tripal module or package was checked out into.

### `modules`

**Required** A space-separated list of module machine names indicating which modules to install before running tests.

### `php-version`

**Optional** The version of PHP you would like tested. This must match one of the current PHP versions TripalDocker is available in (e.g. 8.0 and 8.1).

**Default Value:** 8.1

### `pgsql-version`

The version of PostgreSQL you would like your tests run against. This must match one of the current versions TripalDocker is available in (e.g. 13).

**Default Value:** 13

### `drupal-version`

The version of Drupal you would like your tests run against. This must match one of the current versions TripalDocker is available in (e.g. 9.4.x-dev, 9.5.x-dev).

**Default Value:** 9.5.x-dev


## Outputs

*None yet implemented.*

## Example usage

```yml
uses: actions/test-tripal-action@v1
with:
  directory-name: mymodule
  modules-to-install: 'dependency1 dependency2 mymodule'
```

## Future Development

We will add an additional parameter in the future that allows you to supply a bash script to download and prepare any pre-requisites for your module.

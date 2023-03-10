# Test Tripal GitHub Action

This repo provides a Github Action to make automated testing workflows for Tripal Extension modules easy! It will spin up a specialized docker container, install your module with it's dependencies.


## Example usage

```yml
uses: tripal/test-tripal-action@v1
with:
  directory-name: mypackage
  modules-to-install: 'module1 module2'  
```

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

### `phpunit-command-options`

A string to be appended to the end of the PHPUnit command. See the following examples for how you may use this option:

- `--testsuite MyCustomTestSuite`: only run tests in a specific Test suite as configured in your phpunit.xml.
- `--group MyGroupName`: runs tests with the "@group MyGroupName" added to their docblock headers.
- `--filter testMySpecificMethod`: runs the testMySpecificMethod method specifically. This option can also be used to more generally filter your tests using regular expressions.
- `--coverage-clover /var/www/drupal9/web/modules/mydir/clover.xml`: to run code coverage with the output format matching that for CodeClimate and place the file in a specific directory.

For a full listing of options for the PHPUnit [see the docs](https://docs.phpunit.de/en/9.6/textui.html).

## Outputs

*None yet implemented.*

## Future Development

We will add an additional parameter in the future that allows you to supply a bash script to download and prepare any pre-requisites for your module.

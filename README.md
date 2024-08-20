# Test Tripal GitHub Action

This repo provides a Github Action to make automated testing workflows for Tripal Extension modules easy! It will spin up a specialized docker container, install your module with it's dependencies.


## Example usage

The following examples for a module named `my_tripal_extension` uses this action in a matrix to automate testing across multiple php and drupal versions.

### Basic Automated Testing

```yml
name: PHPUnit
on: [push]
jobs:
  run-tests:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        php-version:
          - "8.1"
          - "8.2"
          - "8.3"
        pgsql-version:
          - "13"
          - "16"
        drupal-version:
          - "10.2.x-dev"
          - "10.3.x-dev"
          - "10.4.x-dev"
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
      - name: Run Automated testing
        uses: tripal/test-tripal-action@v1.6
        with:
          directory-name: my_tripal_extension
          modules: my_tripal_extension
          php-version: ${{ matrix.php-version }}
          pgsql-version: ${{ matrix.pgsql-version }}
          drupal-version: ${{ matrix.drupal-version }}
```

### CodeClimate Test Coverage

The following example assumes you have setup PHPUnit to support test coverage reporting and registered your repo with CodeClimate Quality.

Once that is complete, you can find the CodeClimate "Test Reporter ID" by going to Repo Settings > Test Coverage and copying the "Test Reporter ID" on the CodeClimate Quality page for your repo (i.e. https://codeclimate.com/github/[organization]/[repo]).

This CodeClimate "Test Reporter ID" should then be saved as a secret in your repository on Github by going to Settings > Secrets and Variables > Actions on your repos github page (i.e. https://github.com/[organization]/[repo]/settings/secrets/actions) and adding a repository secret with a name of `CODECLIMATE_TEST_REPORTER_ID` and a value matching the CodeClimate "Test Reporter ID".

Once you've completed those steps you can now create a workflow like the following which runs this action on a specific Drupal-PHP-PostgreSQL version (this should be the best supported version). This workflow uses the github secret as an arguement to this Github Action so that the generated clover.xml can be pushed to CodeClimate.

You can confirm the workflow has worked by going to the CodeClimate Quality page for your repo (i.e. https://codeclimate.com/github/[organization]/[repo]). On the Repo Settings > Test Coverage page near the bottom there is a Recent Reports section and you should see a report appearing here when the workflow completes successfully.

```yml
name: Test Code Coverage (CodeClimate)
on: [push]
jobs:
  run-tests:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
      - name: Run Automated testing + report coverage
        uses: tripal/test-tripal-action@v1.6
        with:
          directory-name: my_tripal_extension
          modules: my_tripal_extension
          php-version: 8.3
          pgsql-version: 16
          drupal-version: 10.4.x-dev
          codeclimate-reporter-id: ${{ secrets.CODECLIMATE_TEST_REPORTER_ID }}
```

## Inputs

### `directory-name`

**Required** The name of the directory your Tripal module or package was checked out into.

### `modules`

**Required** A space-separated list of module machine names indicating which modules to install before running tests.

### `php-version`

**Optional** The version of PHP you would like tested. This must match one of the current PHP versions TripalDocker is available in (e.g. 8.1, 8.2, 8.3).

**Default Value:** 8.3

### `pgsql-version`

The version of PostgreSQL you would like your tests run against. This must match one of the current versions TripalDocker is available in (e.g. 13).

**Default Value:** 13

### `drupal-version`

The version of Drupal you would like your tests run against. This must match one of the current versions TripalDocker is available in (e.g. 10.0.x-dev, 10.1.x-dev, 10.2.x-dev).

**Default Value:** 10.2.x-dev

### `phpunit-command-options`

A string to be appended to the end of the PHPUnit command. See the following examples for how you may use this option:

- `--testsuite MyCustomTestSuite`: only run tests in a specific Test suite as configured in your phpunit.xml.
- `--group MyGroupName`: runs tests with the "@group MyGroupName" added to their docblock headers.
- `--filter testMySpecificMethod`: runs the testMySpecificMethod method specifically. This option can also be used to more generally filter your tests using regular expressions.

For a full listing of options for the PHPUnit [see the docs](https://docs.phpunit.de/en/9.6/textui.html).

### `codeclimate-reporter-id`

Provides the codeclimate reporter ID to report any code coverage to. You can find this ID by registering your repo for code climate and then going to Repo Settings > Test Coverage and copying the "Test Reporter ID". This ID should then be saved as a secret in your repository on Github by going to Settings > Secrets and Variables > Actions on your repos github page and adding a repository secret (e.g. `CODECLIMATE_TEST_REPORTER_ID`) where the value is the CodeClimate "Test Reporter ID". See the Test coverage example for more details on how to use this in your workflow.

### `build-image`

Indicates whether you would like to build the docker based on your code (true) or pull an existing image (false).

**Default Value:** false

### `dockerfile`

The path and file name for the dockerfile (relative to the root of your checkedout module code) to use with the build-image. If build-image is false, then this option will simply be ignored.

Additionally, there is a backup clause for use with the Tripal core repository that will use the other options to choose a docker image at tripaldocker/ and provide the options needed for core. This will only be triggered if the value passed to this option does not exist and the composed tripaldocker dockerfile does.

**Default Value:** Dockerfile

## Outputs

*None yet implemented.*

## Future Development

We will add an additional parameter in the future that allows you to supply a bash script to download and prepare any pre-requisites for your module.

# Test Tripal GitHub Action

This repo provides a Github Action to make automated testing workflows for Tripal Extension modules easy! It will spin up a specialized docker container, install your module with it's dependencies.

## Features

- Runs phpunit in a docker of your choice (can either build or pull a version-specific image).
- Automatically detects which configuration file to use for phpunit making it easier to support multiple versions.
- Supports indicating drupal, php and postgreSQL versions which makes it great for use in a matrixed workflow!
- Integrates with QLTY Cloud so that you can simplify keeping track of code coverage.

## Steps / Functionality

The following describes the steps done by this GitHub action and how your supplied options are used.

1. Obtain the docker image to be used.
  a. If you indicated false for build-image then the action will pull `tripalproject/tripaldocker:drupal${{ inputs.drupal-version }}-php${{ inputs.php-version }}-pgsql${{ inputs.pgsql-version }}`;
  b. Otherwise it will build the image based on the dockerfile in the current module.
2. Create a new docker container using the image from the first step and mount the current directory to `/var/www/drupal/web/modules/contrib/${{ inputs.directory-name }}` in the container.
3. If you defined modules to install, this will be done now. If your docker image already installed the needed modules, then there is no need to indicate the modules.
4. The version of phpunit will be checked in the docker container and the action will try to detect the correct PHPUnit XML configuration file to use. The following naming formats are supported: `phpunit.MAJOR.MINOR.xml`, `phpunit.MAJOR.xml`, `phpunit.xml` where MAJOR = 10 and MINOR = 5 for PHPUnit 10.5. You can supply the file to use via the `phpunit-config` option to override this.
5. PHPUnit will be run inside the docker container in the `/var/www/drupal/web/modules/contrib/${{ inputs.directory-name }}` directory. The configuration file will be set via `--configuration`. If you provided `qltycloud-reporter-id` then the `--coverage-text --coverage-clover /var/www/drupal/web/modules/contrib/${{ inputs.directory-name }}/clover.xml` options will be added to the phpunit command. You can add any additional options using `phpunit-command-options`
6. If you provided `qltycloud-reporter-id` then the clover report will be submitted to QLTY Cloud on your behalf. See the "QLTY Cloud Test Coverage" section below for how to configure this.

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
          - "8.3"
        pgsql-version:
          - "16"
        drupal-version:
          - "11.0.x-dev"
          - "11.1.x-dev"
          - "11.2.x-dev"
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
      - name: Run Automated testing
        uses: tripal/test-tripal-action@v1.8
        with:
          directory-name: my_tripal_extension
          modules: my_tripal_extension
          php-version: ${{ matrix.php-version }}
          pgsql-version: ${{ matrix.pgsql-version }}
          drupal-version: ${{ matrix.drupal-version }}
```

### QLTY Cloud Test Coverage

The following example assumes you have setup PHPUnit to support test coverage reporting and registered your repo with QLTY Cloud.

Once that is complete, you can find the QLTY Cloud "Coverage Token" by going to Project Settings > Code Coverage and copying the "Coverage Token" on the QLTY Cloud page for your repo (i.e. https://qlty.sh/gh/[organization]/projects/[repo]).

This QLTY Cloud "Coverage Token" should then be saved as a secret in your repository on Github by going to Settings > Secrets and Variables > Actions on your repos github page (i.e. https://github.com/[organization]/[repo]/settings/secrets/actions) and adding a repository secret with a name of `QLTY_COVERAGE_TOKEN` and a value matching the QLTY Cloud "Coverage Token".

Once you've completed those steps you can now create a workflow like the following which runs this action on a specific Drupal-PHP-PostgreSQL version (this should be the best supported version). This workflow uses the github secret as an arguement to this Github Action so that the generated clover.xml can be pushed to QLTY Cloud.

You can confirm the workflow has worked by going to the QLTY Cloud page for your repo (i.e. https://qlty.sh/gh/[organization]/projects/[repo]). On the Project Settings > Code Coverage page near the bottom there is a section listing recent results and you should see a report appearing here when the workflow completes successfully on the main branch of your repo.

```yml
name: Test Code Coverage (QLTY Cloud)
on: [push]
jobs:
  run-tests:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
      - name: Run Automated testing + report coverage
        uses: tripal/test-tripal-action@v1.8
        with:
          directory-name: my_tripal_extension
          modules: my_tripal_extension
          php-version: 8.3
          pgsql-version: 16
          drupal-version: 11.2.x-dev
          qltycloud-reporter-id: ${{ secrets.QLTY_COVERAGE_TOKEN }}
```

## Inputs

### `directory-name`

**Required** The name of the directory your Tripal module or package was checked out into.

### `modules`

**Optional**  A space-separated list of module machine names indicating which modules to install before running tests.

### `php-version`

**Optional** The version of PHP you would like tested. This must match one of the current PHP versions TripalDocker is available in (e.g. 8.1, 8.2, 8.3).

**Default Value:** 8.3

### `pgsql-version`

**Optional**  The version of PostgreSQL you would like your tests run against. This must match one of the current versions TripalDocker is available in (e.g. 13, 16).

**Default Value:** 18

### `drupal-version`

**Optional** The version of Drupal you would like your tests run against. This must match one of the current versions TripalDocker is available in (e.g. 11.1.x-dev).

**Default Value:** 11.1.x-dev

### `phpunit-config`

**Optional** The phpunit.xml file to configure the tests. If left blank, we will try to locate it using the following patters: (1) phpunit.VER.xml (where VER is 9 for drupal 10.4/5; 10 for drupal 11.1; 11 for drupal 11.2+), (2) phpunit.xml.

**Default Value:** *determined based on phpunit version*

### `phpunit-command-options`

**Optional** A string to be appended to the end of the PHPUnit command. See the following examples for how you may use this option:

- `--testsuite MyCustomTestSuite`: only run tests in a specific Test suite as configured in your phpunit.xml.
- `--group MyGroupName`: runs tests with the "@group MyGroupName" added to their docblock headers.
- `--filter testMySpecificMethod`: runs the testMySpecificMethod method specifically. This option can also be used to more generally filter your tests using regular expressions.

For a full listing of options for the PHPUnit [see the docs](https://docs.phpunit.de/en/9.6/textui.html).

### `qltycloud-reporter-id`

**Optional** Provides the QLTY Cloud "Coverage Token" to report any code coverage to. You can find this token by registering your repo for QLTY Cloud and then going to Project Settings > Code Coverage and copying the "Coverage Token". This token should then be saved as a secret in your repository on Github by going to Settings > Secrets and Variables > Actions on your repos github page and adding a repository secret (e.g. `QLTY_COVERAGE_TOKEN`) where the value is the QLTY Cloud "Coverage Token". See the Test coverage example for more details on how to use this in your workflow.

### `build-image`

**Optional** Indicates whether you would like to build the docker based on your code (true) or pull an existing image (false).

**Default Value:** false

### `dockerfile`

**Optional** The path and file name for the dockerfile (relative to the root of your checkedout module code) to use with the build-image. If build-image is false, then this option will simply be ignored.

Additionally, there is a backup clause for use with the Tripal core repository that will use the other options to choose a docker image at tripaldocker/ and provide the options needed for core. This will only be triggered if the value passed to this option does not exist and the composed tripaldocker dockerfile does.

**Default Value:** Dockerfile

## Outputs

### `configfile`

The filename of the phpunit.xml configuration file we detected should be used when running the tests. This is detected in `Detect version of phpunit (detect-phpunit-config)` based on the version of PHPunit in the docker.

## Future Development

We do not currently have any development plans for this test action. If there is a feature you would like, feel free to suggest it in our issue queue.

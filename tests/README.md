# Testing

## Overview
More and more Terraform modules are written in a way to be able to handle multiple scenarios in a 
single deployment. This demand drives modules which require logic to be coded into the module and as
a result means that this logic will need to be tested. This is not testing of the internal code of
the Terraform application. Contributing to the Hashicorp codebase is already well documented. This
is your HCL module.

Arguably, simply running Terraform against some mock environment is already an 
integration/acceptance test which you can script to prove that the thing you expected to deploy
actually got deployed. However, there is little in the form of performing [unit tests](https://en.wikipedia.org/wiki/Unit_testing).

Below is the details of how to apply unit with a simple Python script as a test fixture and a 
symlink to a file containing any logic in need of testing.

## Test Fixtures
`tests/test_fixtures/python_validator/python_validator.py`

## The test module
Create a directory for the tests you want to run. In it create a `main.tf` and a symlink to the file
with logic in. For example, we put all logic separate `locals.tf` files, so it could be ` ln -s
../path/to/gcp_ae_locals.tf`. Lastly, we need to define what the expected results of the test would
be into a small python file.

Our python expected test results file, including a good description of the test would look like
```python
"""
Terraform external provider just handles strings in maps, so tests need to consider this
"""
from sys import path, stderr

try:
    path.insert(1, '/../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)


@python_validator
def test_src_files_manifest_format(query):
    """
    checks that the data given to the test function is as expected to be used in
    google_storage_object.

    Terraform taking a list of filenames with relative path from the project root, generating the
    sha1sum for the file and creating map of filename to sha. If any sha sums match, they will be
    overwritten because the upload will use the sha as the name

    the deployment definition however, will use the relative name (key from the map) and include the
    sha in the URL and in the sha1Sum attributes

    should be read from a manifest file where the path to the file is under `manifest_file`. It
    should consider:
    1. when manifest files don't exist
    2. when different AS definitions have a reference to a file of the same name but different
    content
    3. when different AS definitions have a reference to a file of the same name and the same
    content

    manifest files for this test should include
    {
        "artifactDir": "exploded-app1",
        "contents": [
            "WEB-INF/appengine-web.xml",
            "WEB-INF/classes/com/ch/sandbox/experiences/dao/DataServicesKt$mockProviders$1.class"
        ]
    }
    for both app1 and app2 (default) but with slightly different content in appengine-web.xml
    """
    expected_data = {
        "../app2/build/exploded-app2/WEB-INF/appengine-web.xml":
            "3c7a18e3d3b8be3afd75d7a4823d6aca43d65123",
        "../app2/build/exploded-app2/WEB-INF/classes/com/ch/sandbox/experiences/dao/DataServicesKt$mockProviders$1.class":
            "bf21a9e8fbc5a3846fb05b4fa0859e0917b2202f",
        "../app1/build/exploded-app1/WEB-INF/appengine-web.xml":
            "b3fc24644f48f686b0757a6b70973accbcbdee70",
        "../app1/build/exploded-app1/WEB-INF/classes/com/ch/sandbox/experiences/dao/DataServicesKt$mockProviders$1.class":
            "bf21a9e8fbc5a3846fb05b4fa0859e0917b2202f"
    }
    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result": "fail"}


if __name__ == '__main__':
    test_src_files_manifest_format()

```

in `main.tf` a test block would look like:

```hcl-terraform
data external test_upload_manifest_format {
  query = local.upload_manifest
  program = ["/usr/local/bin/python3", "${path.module}/test_data_upload.py"]
}
output test_upload_manifest_format {
  value = data.external.test_upload_manifest_format.result
}
```


## Running the tests from a command line
tests ran from the test directory. First initialise Terraform
```
cd tests/my_unittest_dir/
terraform init
```

running the tests
```
terraform apply -auto-approve -var-file resources/single_manifest.tfvars 
data.external.test_src_files_sha1sum_lookup: Refreshing state...
data.external.test_flex_std_default_separation: Refreshing state...
data.external.test_upload_manifest_format: Refreshing state...
data.external.test_flex_std_app1_separation: Refreshing state...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

test_flex_std_app1_separation = {
  "result" = "pass"
}
test_flex_std_default_separation = {
  "result" = "pass"
}
test_src_files_sha1sum_lookup = {
  "result" = "pass"
}
test_upload_manifest_format = {
  "result" = "pass"
}

```

To get output in a machine parsable JSON format (needs some JQ or some other JSON tool)
```
terraform plan -var-file resources/single_manifest.tfvars -out my.plan 2>&1 > /dev/null && terraform show -json my.plan | jq .planned_values.outputs && rm my.plan
{
  "test_src_files_sha1sum_lookup": {
    "sensitive": false,
    "value": {
      "result": "pass"
    }
  },
  "test_upload_manifest_format": {
    "sensitive": false,
    "value": {
      "result": "pass"
    }
  }
}
```

## Running the tests from an IDE


## Running the tests from a CI/CD pipeline
### Github Actions
Tests are automated in github actions using workflows. For each job in a workflow, 
there are different steps which validate unit tests for each module.
Unit tests are run by applying the main.tf files described [above](#the-test-module).

Example MCP unit tests
```yamlex
on:
  pull_request:
    branches:
      - master

jobs:
  unit-tests:
    name: 'Unit Tests'
    runs-on: ubuntu-latest
    env:
      working-directory: ./tests/mcp

    # Use the Bash shell regardless whether the GitHub Actions runner is ubuntu-latest, macos-latest, or windows-latest
    defaults:
      run:
        shell: bash
        working-directory: ${{env.working-directory}}

    steps:
    # Checkout the repository to the GitHub Actions runner
    - name: Checkout
      uses: actions/checkout@v2
      
    # Install Python
    - name: Install Python
      uses: actions/setup-python@v2
      with:
        python-version: '3.x' # Version range or exact version of a Python version to use, using SemVer's version range syntax
        architecture: 'x64' # optional x64 or x86. Defaults to x64 if not specified

    # Install the latest version of Terraform CLI
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_wrapper: false

    # Run unit tests in MCP module
    - name: Run MCP unit tests
      run: |
        MESSAGE="PASSED: All unit tests passed"
        for dir in $(find $(pwd) \( -not -path "$(pwd)/module_import/*" \) -and \( -type f -name 'main.tf' \) |  sed -r 's|/[^/]+$||'); do
          echo "Directory: ${dir}"
          cd $dir
          terraform init
          terraform apply -auto-approve
          for key in $(terraform output -json | jq -r 'keys[]'); do
            output=$(terraform output -json $key)
            result=$(echo $output | jq -r '.result')
            echo ${result^^}
            if [ "$result" != "pass" ]
            then
              MESSAGE="FAIL: There are failed unit tests"
              echo "    Expected data: $(echo $output | jq -r '.expected')"
              echo "    Received data: $(echo $output | jq -r '.received')"
              EXIT_CODE=3
            fi
          done
        done
        echo $MESSAGE
        exit $EXIT_CODE
```

Workflows are successful when all steps are completed without any exit code other than 0.
Non-zero exit codes indicate a fail, due to either an error in the workflow file or failed unit tests

| Exit code | Description |
|:----:|:----|
| `0` | Success |
| `1` | General Error | 
| `2` | Misuse of shell builtins (e.g. missing keyword, permission problem etc )|
| `3` | Unit test failed  (query and expected data don't match) |  

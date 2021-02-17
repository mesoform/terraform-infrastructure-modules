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
with logic in. For example, we put all logic separate locals files called `<adapter>_locals.tf`, so it could be ` ln -s
../path/to/gae_locals.tf`. Lastly, we need to define what the expected results of the test would
be into a small python file.

Our python expected test results file, including a good description of the test would look like
```python
"""
Terraform external provider just handles strings in maps, so tests need to consider this
"""
from sys import path, stderr

try:
    path.insert(1, '../../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

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


    for both app1 and app2 (default) but with slightly different content in appengine-web.xml
"""

expected_data = {
    "env": "flex",
    "name": "app1"
}


if __name__ == '__main__':
    python_validator(expected_data)


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
#### Unit Tests 
Tests are automated in github actions using workflows. For each job in a workflow, 
there are different steps which validate unit tests for each module.
Unit tests are run by applying the main.tf files described [above](#the-test-module).  
See the [workflow](../.github/workflows/unit_tests.yml) for unit tests. 

Workflows are successful when all steps are completed without any exit code other than 0.
Non-zero exit codes indicate a fail, due to either an error in the workflow file or failed unit tests

| Exit code | Description |
|:----:|:----|
| `0` | Success |
| `1` | General Error | 
| `2` | Misuse of shell builtins (e.g. missing keyword, permission problem etc )|
| `3` | Unit test failed  (query and expected data don't match) |  

#### Deployment Tests
A github workflow can be used to verify successful deployment of terraform modules. 
The steps included are:
1. Download terraform and any other services required (python, gcloud, aws, etc)
2. Configure cloud services for deployment. This will require a service account with permissions to create relevant resources
3. Plan and apply terraform infrastructure
4. Destroy infrastructure and delete cloud resources

The deployment workflow file can be found [here](../.github/workflows/deploy_mcp.yml).
Relevant yaml configuration files and resources are in the deployment directory, with subdirectories for relevant adaptors. 
E.g. for kubernetes mcp deployment tests`tests/mcp/deployment/k8s`.  
See the [workflow](../.github/workflows/deploy_mcp.yml) for mcp deployment tests

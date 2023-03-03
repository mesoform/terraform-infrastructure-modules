"""
Terraform external provider just handles strings in maps, so tests need to consider this
"""
from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)


"""
    Tests whether default audience from template are configured, and custom audiences set when specified.
"""

expected_data = {
    "bitbucket": "ari:cloud:bitbucket::workspace/{company-unique-id}",
    "circleci": "company",
    "github": "",
    "gitlab": "https://gitlab.com",
    "terraform-cloud": "",
    "unknown": "audience1, audience2"
}

if __name__ == '__main__':
    python_validator(expected_data)

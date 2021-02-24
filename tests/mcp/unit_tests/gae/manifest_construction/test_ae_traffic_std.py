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
    Tests the retrieval and formatting of traffic maps for app engine standard version.
    As no traffic is specified for this version in the configuration file, traffic should be allocated to 1 by default.
"""

expected_data = {
    "v2": '1'
}


if __name__ == '__main__':
    python_validator(expected_data)

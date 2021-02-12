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
    Tests the merging of environment variables from `common` and `specs`.
"""

expected_data = {
    "env": "dev",
    "IS_GAE": "true"
}


if __name__ == '__main__':
    python_validator(expected_data)

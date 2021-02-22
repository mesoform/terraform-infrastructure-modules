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
    Tests the retrieval and formatting of traffic maps for app engine.
    Should return the main
"""

expected_data = {
    "v1": '0.6',
    "v2": '0.4'
}


if __name__ == '__main__':
    python_validator(expected_data)

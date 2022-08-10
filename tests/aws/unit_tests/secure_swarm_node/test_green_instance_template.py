from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests the configuration of security level for green instance template.
"""

expected_data = {
    "security_level": "secure-1"
}


if __name__ == '__main__':
    python_validator(expected_data)
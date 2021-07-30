from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests whether setting the enum "ALL-SERVICES" will set enabled restrictions to false
"""

expected_data = {
    "enabled": "false"
}



if __name__ == '__main__':
    python_validator(expected_data)

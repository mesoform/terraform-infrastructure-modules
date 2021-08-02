from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests whether specifiying vpc_accessible_services will set enabled restrictions to true
"""

expected_data = {
    "enabled": "true"
}



if __name__ == '__main__':
    python_validator(expected_data)

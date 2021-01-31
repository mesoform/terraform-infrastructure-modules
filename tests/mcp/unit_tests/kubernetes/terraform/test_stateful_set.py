from sys import path, stderr

try:
    path.insert(1, '../../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Checks the data specified in the required metadata

"""

expected_data = {
    "name": "www-data"
}

if __name__ == '__main__':
    python_validator(expected_data)

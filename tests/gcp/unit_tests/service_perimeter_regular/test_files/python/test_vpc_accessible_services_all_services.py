from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests whether using the enum `ALL-SERVICES` will default allowed services to be null
"""

expected_data = {"service": "empty"}



if __name__ == '__main__':
    python_validator(expected_data)

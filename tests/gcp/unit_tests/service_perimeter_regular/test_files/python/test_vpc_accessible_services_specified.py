from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests whether using specifying allowed services will configure correctly
"""

expected_data = {
    "storage.googleapis.com": "storage.googleapis.com",
    "compute.googleapis.com": "compute.googleapis.com"
}



if __name__ == '__main__':
    python_validator(expected_data)

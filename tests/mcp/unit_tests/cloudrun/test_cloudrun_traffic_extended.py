from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests the retrieval and formatting of traffic maps for Cloud Run.
"""

expected_data = {
    "app1-service-v1": '70',
    "app1-service-v2": '30'
}


if __name__ == '__main__':
    python_validator(expected_data)

from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests whether not specifying valyues will default allowed services to being the enum "RESTRICTED-SERVICES"
"""


expected_data = {
        "RESTRICTED-SERVICES": "RESTRICTED-SERVICES"
}



if __name__ == '__main__':
    python_validator(expected_data)

from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests that members and their roles are accessible.
    The result shows the roles and how many members are assigned to that role.
    Roles and members are defined like:

    role:
      members:
        -{type}:{member}
        -{type}:{member}
    role2:
      members:
        -{type}

"""

expected_data = {
    'viewer': '2',
    'admin': '1'
}

if __name__ == '__main__':
    python_validator(expected_data)

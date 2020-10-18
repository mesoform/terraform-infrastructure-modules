from sys import path, stderr

try:
    path.insert(1, '../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)

@python_validator
def test_policy_members(query):
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
        'viewer' : '2',
        'admin' : '1'
    }



    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result" : "fail"}

if __name__ == '__main__':
    test_policy_members()
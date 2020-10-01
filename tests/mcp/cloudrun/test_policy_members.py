from sys import path, stderr

try:
    path.insert(1, '../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)

@python_validator
def test_policy_members(query):
    """
    Tests that members and their roles are accessible. the result shows the members
    and which role they are mapped to.
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
        'user:user@gmail.com' : 'viewer',
        'group:user@gmail.com' : 'viewer',
        'domain:domain.com' : 'admin'
    }



    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result" : "fail, expected data = {}, received data = {}".format(expected_data, query)}

if __name__ == '__main__':
    test_policy_members()
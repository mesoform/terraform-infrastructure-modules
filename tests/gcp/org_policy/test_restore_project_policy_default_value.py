from sys import path, stderr

try:
    path.insert(1, '../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)


@python_validator
def test_restore_project_policy_default_value(query):
    """
    tests that when given a list of organization policies in a format which is both simple for users
    and easily scalable, that an allow list policy has the correct value

    "gcp.resourceLocations-mcp-testing-23452432" = {
        "constraint" = "gcp.resourceLocations"
        "project_id" = "mcp-testing-23452432"
        "restore_policy" = {
          "default" = "true"
        }
    }

    """

    expected_data = {'default_value': 'true'}

    if query == expected_data:
        return {"result": "pass"}
    else:
        return {
            "result": "fail",
            "expected_data": "{}".format(expected_data),
            "received_data": "{}".format(query)
        }


if __name__ == '__main__':
    test_restore_project_policy_default_value()

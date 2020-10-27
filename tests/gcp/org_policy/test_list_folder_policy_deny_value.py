from sys import path, stderr

try:
    path.insert(1, '../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)


@python_validator
def test_list_folder_policy_deny_value(query):
    """
    tests that when given a list of organization policies in a format which is both simple for users
    and easily scalable, that an allow list policy has the correct value

    "serviceuser.services-323203379966" = {
        "constraint" = "serviceuser.services"
        "folder_number" = "323203379966"
        "list_policy" = {
            "allow" = []
            "deny" = [
                "resourceviews.googleapis.com",
            ]
          "inherit_from_parent" = "false"
        }
    }


    """

    expected_data = {'deny_value': 'resourceviews.googleapis.com'}

    if query == expected_data:
        return {"result": "pass"}
    else:
        return {
            "result": "fail",
            "expected_data": "{}".format(expected_data),
            "received_data": "{}".format(query)
        }


if __name__ == '__main__':
    test_list_folder_policy_deny_value()

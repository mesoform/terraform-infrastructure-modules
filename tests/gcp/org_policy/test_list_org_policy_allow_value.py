from sys import path, stderr

try:
    path.insert(1, '../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)


@python_validator
def test_list_org_policy_allow_value(query):
    """
    tests that when given a list of organization policies in a format which is both simple for users
    and easily scalable, that an allow list policy has the correct value

    "gcp.resourceLocations-98765432100" = {
    "constraint" = "gcp.resourceLocations"
    "list_policy" = {
      "allow" = [
        "in:europe-west2-locations",
      ]
      "deny" = []
    }
  }


    """

    expected_data = {'allow_value': 'in:europe-west2-locations'}

    if query == expected_data:
        return {"result": "pass"}
    else:
        return {
            "result": "fail",
            "expected_data": "{}".format(expected_data),
            "received_data": "{}".format(query)
        }


if __name__ == '__main__':
    test_list_org_policy_allow_value()

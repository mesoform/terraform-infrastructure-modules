from sys import path, stderr

try:
    path.insert(1, '../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)

@python_validator
def test_iam_members(query):
    """
    Checks that iam members are retrieved from the iam block in the config file.
    The iam members are used in data.google_iam_policy and google_cloudrun_service_iam_binding

    Members are defined in gcp_cloudrun.yml as a map of members to their type:
    member:
      <member> : <type of member>

    """

    expected_data = {
        'user@google.com': 'user',
        'user2@google.com': 'user',
        'group@google.com': 'group'
    }



    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result" : "fail, expected data = {}, received data = {}".format(expected_data, query)}

if __name__ == '__main__':
    test_iam_members()
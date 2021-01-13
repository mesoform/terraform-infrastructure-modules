from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)

@python_validator
def test_traffic_with_revision(query):
    """
    checks that the data given to the test function is in the correct format
    for the google_cloud_run_service.traffic setting.

    The configuration for traffic comes from the gcp_cloudrun.yml configuration file,
    and should be transformed into a list of maps, which should have the configuration
    for each traffic setting.

    E.g.
    traffic:
      -
        percent: 25
        revision_name: "old"

    needs to be configured in google_cloud_run_service to match:
    traffic{
      percent = 25
      latest_revision = false
      revision_name = "old"
    }
    """

    expected_data = {
        "latest_revision": "false",
        "percent": "25",
        "revision_name": "old"
    }

    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result" : "fail",
                "expected" : "{}".format(expected_data),
                "received" : "{}".format(query)}


if __name__ == '__main__':
    test_traffic_with_revision()
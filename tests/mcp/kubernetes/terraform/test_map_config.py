from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)

@python_validator
def test_map_config(query):
    """
    Checks that the map configuration for k8s resources are configured correctly.
    Given a k8s_*.yml file in a dir /{dirname}, a map should be produced that takes the dirname as
    the key with the value being a map with the name of the resource, to all of the configuration settings.
    e.g.
    file: test/k8s_service.yml
    local.k8s_service:
    test{
      service{
        ...
        metadata{...}
        specs {...}
        ...
      }
    }

    This tests whether the correct file name, and service key is given
    """

    expected_data = {
        "resources" : "service"
    }

    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result" : "fail, expected data = {}, received data = {}".format(expected_data, query)}



if __name__ == '__main__':
    test_map_config()
from sys import path, stderr

try:
    path.insert(1, '../../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

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
    "test_app_1": "service"
}

if __name__ == '__main__':
    python_validator(expected_data)

"""
Terraform external provider just handles strings in maps, so tests need to consider this
"""
from sys import path, stderr

try:
    path.insert(1, '../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)


@python_validator
def test_service(query):

    expected_data = {
        "app" : "mosquitto",
    }

    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result" : "fail, expected data = {}, received data = {}".format(expected_data, query)}


if __name__ == '__main__':
    test_service()

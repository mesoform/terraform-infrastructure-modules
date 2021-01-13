from sys import path, stderr

try:
    path.insert(1, '../../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)

@python_validator
def test_stateful_set(query):
    """
    Checks the data specified in the required metadata

    """

    expected_data = {
        "name" : "www-data"
    }

    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result" : "fail, expected data = {}, received data = {}".format(expected_data, query)}



if __name__ == '__main__':
    test_stateful_set()

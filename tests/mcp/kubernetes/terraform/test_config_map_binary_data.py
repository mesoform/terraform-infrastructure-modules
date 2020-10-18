from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)

@python_validator
def test_config_map_data(query):
    """
    Tests the configuration of `binary_data` mapping. `binary_data` contains binary encoded configuration
    data, mapped like the following:
    data = {
        bar: L3Jvb3QvMTAw
        my_payload.bin" = "${filebase64("${path.module}/my_payload.bin")}"
    }

    """

    expected_data = {
        "bar": "L3Jvb3QvMTAw",
        "binary.bin" : "SGVsbG8gV29ybGQ="
    }

    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result" : "fail"}



if __name__ == '__main__':
    test_config_map_data()
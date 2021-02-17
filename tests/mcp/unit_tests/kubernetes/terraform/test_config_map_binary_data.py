from sys import path, stderr

try:
    path.insert(1, '../../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

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
    "binary.bin": "SGVsbG8gV29ybGQ="
}


if __name__ == '__main__':
    python_validator(expected_data)

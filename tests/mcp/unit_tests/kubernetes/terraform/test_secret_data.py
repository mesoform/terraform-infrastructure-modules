from sys import path, stderr

try:
    path.insert(1, '../../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests the configuration of `data` mapping. `data ` contains configuration
    data, mapped like the following:
    data = {
        api_host             = "myhost:443"
        db_host              = "dbhost:5432"
        "my_config_file.yml" = "${file("${path.module}/my_config_file.yml")}"
    }

"""

expected_data = {
    "secret.file": "c29tZXN1cGVyc2VjcmV0IGZpbGUgY29udGVudHMgbm9ib2R5IHNob3VsZCBzZWU=",
    "login": "login",
    "password": "password"
}


if __name__ == '__main__':
    python_validator(expected_data)

from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)

@python_validator
def test_secret_data(query):
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
        "secret.file" : "c29tZXN1cGVyc2VjcmV0IGZpbGUgY29udGVudHMgbm9ib2R5IHNob3VsZCBzZWU=",
        "login" : "login",
        "password" : "password"
    }

    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result" : "fail",
                "expected" : "{}".format(expected_data),
                "received" : "{}".format(query)}



if __name__ == '__main__':
    test_secret_data()

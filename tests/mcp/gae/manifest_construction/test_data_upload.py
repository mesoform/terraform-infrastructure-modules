from sys import path, stderr
try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)


@python_validator
def test_upload_manifest_format(query):
    """
    checks that the data given to the test function is as expected to be used in
    google_storage_object
    """
    expected_data = {
        "./7946062fc18172c73015988114ed989670397f8b": "app2/WEB-INF/appengine-web.xml",
        "./bf21a9e8fbc5a3846fb05b4fa0859e0917b2202f": "app2/WEB-INF/classes/com/ch/sandbox/experiences/dao/DataServicesKt$mockProviders$1.class"
    }
    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result": "fail"}


if __name__ == '__main__':
    test_upload_manifest_format()

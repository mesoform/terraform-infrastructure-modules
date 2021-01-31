""""
Terraform external provider just handles strings in maps, so tests need to consider this
"""
from sys import path, stderr

try:
    path.insert(1, '../../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, file=stderr)


@python_validator
def test_src_files_manifest_format(query):
    """
    Checks that the correct addresses for the source files are made from the manifest.
    From the given manifest a google storage address should be given.
    manifest files for this test should include
    {
        "artifactDir": "exploded-app1",
        "contents": [
            "WEB-INF/appengine-web.xml",
            "WEB-INF/classes/com/ch/sandbox/experiences/dao/DataServicesKt$mockProviders$1.class"
        ]
    }
    for both app1 and app2 (default) but with slightly different content in appengine-web.xml
    """
    expected_data = {
        "appengine-web.xml":
            "https://storage.googleapis.com/protean-buffer-230514/app1/build/exploded-app1/WEB-INF/appengine-web.xml",
        "DataServicesKt$mockProviders$1.class":
            "https://storage.googleapis.com/protean-buffer-230514/app1/build/exploded-app1/WEB-INF/classes/com/ch/sandbox/experiences/dao/DataServicesKt$mockProviders$1.class"
    }
    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result": "fail",
                "expected": "{}".format(expected_data),
                "received": "{}".format(query)}


if __name__ == '__main__':
    test_src_files_manifest_format()

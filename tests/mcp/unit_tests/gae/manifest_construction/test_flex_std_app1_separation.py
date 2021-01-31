"""
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
    checks that the data given to the test function is as expected to be used in
    google_storage_object.

    Terraform taking a list of filenames with relative path from the project root, generating the
    sha1sum for the file and creating map of filename to sha. If any sha sums match, they will be
    overwritten because the upload will use the sha as the name

    the deployment definition however, will use the relative name (key from the map) and include the
    sha in the URL and in the sha1Sum attributes

    should be read from a manifest file where the path to the file is under `manifest_file`. It
    should consider:
    1. when manifest files don't exist
    2. when different AS definitions have a reference to a file of the same name but different
    content
    3. when different AS definitions have a reference to a file of the same name and the same
    content


    for both app1 and app2 (default) but with slightly different content in appengine-web.xml
    """
    expected_data = {
        "env": "flex",
        "name": "app1"
    }

    if query == expected_data:
        return {"result": "pass"}
    else:
        return {"result": "fail",
                "expected": "{}".format(expected_data),
                "received": "{}".format(query)}


if __name__ == '__main__':
    test_src_files_manifest_format()

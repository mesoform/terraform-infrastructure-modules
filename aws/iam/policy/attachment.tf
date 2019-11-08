resource "aws_iam_policy_attachment" "default_manage_keys" {
  name       = "default-manage-keys"
  users      = []
  roles      = "${var.default_manage_keys_roles}"
  groups     = "${var.default_manage_keys_groups}"
  policy_arn = "${aws_iam_policy.default_manage_keys.arn}"
}

resource "aws_iam_policy_attachment" "default_restrict_resource_location" {
  name       = "default-restrict-resource-location"
  users      = []
  roles      = "${var.default_manage_keys_roles}"
  groups     = "${var.default_manage_keys_groups}"
  policy_arn = "${aws_iam_policy.default_manage_keys.arn}"
}


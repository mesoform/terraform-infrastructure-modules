

resource "aws_iam_role_policy" "ec2_ebs_policy" {
  name   = "${var.common_tags["Project"]}_ec2_ebs_policy"
  role   = aws_iam_role.ec2_ebs_access.id
  policy = file(abspath("../compute_engine/iam/data/ebs_full_access_policy.json"))
}

resource "aws_iam_role" "ec2_ebs_access" {
  name               = "${var.common_tags["Project"]}_ec2_s3_access"
  assume_role_policy = file(abspath("../compute_engine/iam/data/ec2_ebs_role.json"))
  tags = merge(
    { Name = "${var.common_tags["Project"]}_ec2_s3_role" },
  var.common_tags)
}

#resource "aws_iam_instance_profile" "instance_profile" {
#  name = "${var.common_tags["Project"]}_nandos_profile"
#  role = aws_iam_role.ec2_s3_access.name
#}

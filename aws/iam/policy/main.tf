resource "aws_iam_policy" "default_manage_keys" {
  name        = "manage-own-access-keys"
  path        = "/"
  description = "Allows users to manage own keys"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:DeleteAccessKey",
                "iam:GetAccessKeyLastUsed",
                "iam:UpdateAccessKey",
                "iam:GetUser",
                "iam:CreateAccessKey",
                "iam:ListAccessKeys"
            ],
            "Resource": "arn:aws:iam::*:user/${aws:username}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "default_restrict_resource_location" {
  name        = "restrict-resource-location"
  path        = "/"
  description = "restricts geographical locations which resources can be deployed to"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:Region": "${var.default_geo_location}"
                }
            }
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*",
            "Condition": {
                "ForAnyValue:StringEquals": {
                    "s3:locationconstraint": "${var.default_geo_location}"
                }
            }
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "ec2:DescribeRegions",
            "Resource": "*"
        }
    ]
}
}


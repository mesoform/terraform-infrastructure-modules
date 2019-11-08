resource "aws_organizations_policy" "default_allowed_services" {
  name = "default-allowed-services"
  description = "Defines a list of approved services. All other services, not included in the list are blocked"
  content = <<EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1111111111111",
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "elasticloadbalancing:*",
                "codecommit:*",
                "cloudtrail:*",
                "codedeploy:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOL
}

resource "aws_organizations_policy" "default_restrict_clouldtrail" {
  name = "default-restrict-cloudtrail"
  description = "Blocks users' ability to modify cloud trail logs"
  content = <<EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1234567890123",
            "Effect": "Deny",
            "Action": [
                "cloudtrail:AddTags",
                "cloudtrail:CreateTrail",
                "cloudtrail:DeleteTrail",
                "cloudtrail:RemoveTags",
                "cloudtrail:StartLogging",
                "cloudtrail:StopLogging",
                "cloudtrail:UpdateTrail"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOL
}

resource "aws_organizations_policy" "danger_allow_all" {
  name = "danger-full-access"
  description = "Blocks users' ability to modify cloud trail logs"
  content = <<EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOL
}
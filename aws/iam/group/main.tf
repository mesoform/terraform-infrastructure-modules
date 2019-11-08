resource "aws_iam_group" "engineering" {
  name = "engineering"
  path = "/users/"
}

resource "aws_iam_group" "operations" {
  name = "operation"
  path = "/users/"
}

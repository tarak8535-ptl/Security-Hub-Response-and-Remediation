resource "aws_iam_role" "config_role" {
  name = "AWSRoleForConfig"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "a" {
    role = aws_iam_role.config_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
  
}

resource "aws_iam_role_policy" "config_rolepolicy" {
  name = "AWS_Config_RolePolicy"
  role = aws_iam_role.config_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.config_bucket.arn}",
        "${aws_s3_bucket.config_bucket.arn}/*"
      ]
    }
  ]
}
EOF  
}
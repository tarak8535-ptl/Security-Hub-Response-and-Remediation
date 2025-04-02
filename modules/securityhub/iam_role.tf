resource "aws_iam_role_policy" "CreateActionTargetLambdaRole_policy" {
  name = "CreateActionTargetLambdaRole_policy"
  role = aws_iam_role.CreateActionTargetLambdaRole.id

  
  policy = "${file("${path.module}/iam/CreateActionTargetLambdaRolePolicy.json")}"
}

resource "aws_iam_role" "CreateActionTargetLambdaRole" {
  name = "CreateActionTargetLambdaRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Sid"    : "",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy" "CIS13RRLambdaRole_policy" {
  name = "CIS13RRLambdaRole_policy"
  role = aws_iam_role.CIS13RRLambdaRole.id

  
  policy = "${file("${path.module}/iam/CIS13RRLambdaPolicy.json")}"
}

resource "aws_iam_role" "CIS13RRLambdaRole" {
  name = "CIS13RRLambdaRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Sid"    : "",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "CIS15to111RRLambdaRole_policy" {
  name = "CIS15to111RRLambdaRole_policy"
  role = aws_iam_role.CIS15to111RRLambdaRole.id

  
  policy = "${file("${path.module}/iam/CIS15to111RRLambdaPolicy.json")}"
}

resource "aws_iam_role" "CIS15to111RRLambdaRole" {
  name = "CIS15to111RRLambdaRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Sid"    : "",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "CIS22RRLambdaRole_policy" {
  name = "CIS22RRLambdaRole_policy"
  role = aws_iam_role.CIS22RRLambdaRole.id

  
  policy = "${file("${path.module}/iam/CIS22RRLambdaPolicy.json")}"
}

resource "aws_iam_role" "CIS22RRLambdaRole" {
  name = "CIS22RRLambdaRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Sid"    : "",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy" "CIS23RRLambdaRole_policy" {
  name = "CIS23RRLambdaRole_policy"
  role = aws_iam_role.CIS23RRLambdaRole.id

  
  policy = "${file("${path.module}/iam/CIS23RRLambdaPolicy.json")}"
}

resource "aws_iam_role" "CIS23RRLambdaRole" {
  name = "CIS23RRLambdaRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Sid"    : "",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "CIS24RRLambdaRole_policy" {
  name = "CIS24RRLambdaRole_policy"
  role = aws_iam_role.CIS24RRLambdaRole.id

  
  policy = "${file("${path.module}/iam/CIS24RRLambdaPolicy.json")}"
}

resource "aws_iam_role" "CIS24RRLambdaRole" {
  name = "CIS24RRLambdaRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Sid"    : "",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "CIS26RRLambdaRole_policy" {
  name = "CIS26RRLambdaRole_policy"
  role = aws_iam_role.CIS26RRLambdaRole.id

  
  policy = "${file("${path.module}/iam/CIS26RRLambdaPolicy.json")}"
}

resource "aws_iam_role" "CIS26RRLambdaRole" {
  name = "CIS26RRLambdaRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Sid"    : "",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "CIS28RRLambdaRole_policy" {
  name = "CIS28RRLambdaRole_policy"
  role = aws_iam_role.CIS28RRLambdaRole.id

  
  policy = "${file("${path.module}/iam/CIS28RRLambdaPolicy.json")}"
}

resource "aws_iam_role" "CIS28RRLambdaRole" {
  name = "CIS28RRLambdaRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Sid"    : "",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy" "CIS29RRLambdaRole_policy" {
  name = "CIS29RRLambdaRole_policy"
  role = aws_iam_role.CIS29RRLambdaRole.id

  
  policy = "${file("${path.module}/iam/CIS29RRLambdaPolicy.json")}"
}

resource "aws_iam_role" "CIS29RRLambdaRole" {
  name = "CIS29RRLambdaRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Sid"    : "",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}


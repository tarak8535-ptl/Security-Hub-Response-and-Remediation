data "archive_file" "CreateActionTarget"{
    type = "zip"
    source_file = "${path.module}/lambda/CreateActionTarget.py"
    output_path = "CreateActionTarget.zip"
}


resource "aws_lambda_function" "CreateActionTargetLambdaFunction" {
  filename      = "CreateActionTarget.zip"
  function_name = "CreateActionTarget"
  #role          = "arn:aws:iam::832437335724:role/CreateActionTargetLambdaRole"
  description = "Custom resource to create an action target in Security Hub"
  role = aws_iam_role.CreateActionTargetLambdaRole.arn
  handler       = "CreateActionTarget.lambda_handler"


  source_code_hash = filebase64sha256("CreateActionTarget.zip")

  runtime = "python3.7"
}


data "archive_file" "CIS26RRLambda"{
    type = "zip"
    source_file = "${path.module}/lambda/CIS26RRLambda.py"
    output_path = "CIS26RRLambda.zip"
}

resource "aws_lambda_function" "CIS26RRLambdaFunction" {
  filename      = "CIS26RRLambda.zip"
  function_name = "CIS_2-6_RR"
  description = "Remediates CIS 2.6 enabling Access Logging on CloudTrail logs bucket"
  role = aws_iam_role.CIS26RRLambdaRole.arn
  handler       = "CIS26RRLambda.lambda_handler"


  #source_code_hash = filebase64sha256("CIS13RRLambda.zip")

  runtime = "python3.7"
}

resource "aws_cloudwatch_event_rule" "CIS_2-6_RR_CWE" {
  name        = "CIS_2-6_RR_CWE"
  description = "Remediates CIS 2.6 enabling Access Logging on CloudTrail logs bucket"

  event_pattern = <<EOF
{
  "source" : ["aws.securityhub"],
  "detail-type": ["Security Hub Findings - Custom Action"],
  "resources": ["arn:aws:securityhub:us-east-1:832437335724:action/custom/cis26RR"]

}
EOF

}

resource "aws_cloudwatch_event_target" "CIS26RRActionTarget" {
    rule = aws_cloudwatch_event_rule.CIS_2-6_RR_CWE.name
    target_id = "CIS_2-6_RR_CWE"
    arn = aws_lambda_function.CIS26RRLambdaFunction.arn



  
}

resource "aws_lambda_permission" "CIS26RRCWEPermissions" {
  statement_id  = "CIS26RRCWEPermissions"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CIS26RRLambdaFunction.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.CIS_2-6_RR_CWE.arn
}
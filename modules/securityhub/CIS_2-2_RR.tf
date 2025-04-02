data "archive_file" "CIS22RRLambda"{
    type = "zip"
    source_file = "${path.module}/lambda/CIS22RRLambda.py"
    output_path = "CIS22RRLambda.zip"
}

resource "aws_lambda_function" "CIS22RRLambdaFunction" {
  filename      = "CIS22RRLambda.zip"
  function_name = "CIS_2-2_RR"
  description = "Remediates CIS 2.2 by enabling CloudTrail log file validation"
  role = aws_iam_role.CIS22RRLambdaRole.arn
  handler       = "CIS22RRLambda.lambda_handler"


  #source_code_hash = filebase64sha256("CIS13RRLambda.zip")

  runtime = "python3.7"
}

resource "aws_cloudwatch_event_rule" "CIS_2-2_RR_CWE" {
  name        = "CIS_2-2_RR_CWE"
  description = "Remediates CIS 2.2 by enabling CloudTrail log file validation"

  event_pattern = <<EOF
{
  "source" : ["aws.securityhub"],
  "detail-type": ["Security Hub Findings - Custom Action"],
  "resources": ["arn:aws:securityhub:us-east-1:832437335724:action/custom/cis22RR"]

}
EOF

}

resource "aws_cloudwatch_event_target" "CIS22RRActionTarget" {
    rule = aws_cloudwatch_event_rule.CIS_2-2_RR_CWE.name
    target_id = "CIS_2-2_RR_CWE"
    arn = aws_lambda_function.CIS22RRLambdaFunction.arn



  
}

resource "aws_lambda_permission" "CIS22RRCWEPermissions" {
  statement_id  = "CIS22RRCWEPermissions"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CIS22RRLambdaFunction.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.CIS_2-2_RR_CWE.arn
}
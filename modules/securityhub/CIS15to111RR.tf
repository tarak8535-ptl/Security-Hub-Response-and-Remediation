data "archive_file" "CIS15to111RRLambda"{
    type = "zip"
    source_file = "${path.module}/lambda/CIS15to111RRLambda.py"
    output_path = "CIS15to111RRLambda.zip"
}

resource "aws_lambda_function" "CIS15to111RRLambdaFunction" {
  filename      = "CIS15to111RRLambda.zip"
  function_name = "CIS_1-5_1-11_RR"
  description = "Remediates CIS Checks 1.5 through 1.11 by establishing a CIS Compliant Strong Password Policy"
  role = aws_iam_role.CIS15to111RRLambdaRole.arn
  handler       = "CIS15to111RRLambda.lambda_handler"


  #source_code_hash = filebase64sha256("CIS13RRLambda.zip")

  runtime = "python3.7"
}

resource "aws_cloudwatch_event_rule" "CIS_1-5_1-11_RR_CWE" {
  name        = "CIS_1-5_1-11_RR_CWE"
  description = "Remediates CIS Checks 1.5 through 1.11 by establishing a CIS Compliant Strong Password Policy"

  event_pattern = <<EOF
{
  "source" : ["aws.securityhub"],
  "detail-type": ["Security Hub Findings - Custom Action"],
  "resources": ["arn:aws:securityhub:us-east-1:832437335724:action/custom/cis1511RR"]

}
EOF

}

resource "aws_cloudwatch_event_target" "CIS15to111RRActionTarget" {
    rule = aws_cloudwatch_event_rule.CIS_1-5_1-11_RR_CWE.name
    target_id = "CIS_1-5-11_RR_CWE"
    arn = aws_lambda_function.CIS15to111RRLambdaFunction.arn



  
}

resource "aws_lambda_permission" "CIS15to111RRCWEPermissions" {
  statement_id  = "CIS15to111RRCWEPermissions"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CIS15to111RRLambdaFunction.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.CIS_1-5_1-11_RR_CWE.arn
}
data "archive_file" "CIS23RRLambda"{
    type = "zip"
    source_file = "${path.module}/lambda/CIS23RRLambda.py"
    output_path = "CIS23RRLambda.zip"
}

resource "aws_lambda_function" "CIS23RRLambdaFunction" {
  filename      = "CIS23RRLambda.zip"
  function_name = "CIS_2-3_RR"
  description = "Remediates CIS 2.3 by making CloudTrail log bucket private"
  role = aws_iam_role.CIS23RRLambdaRole.arn
  handler       = "CIS23RRLambda.lambda_handler"


  #source_code_hash = filebase64sha256("CIS13RRLambda.zip")

  runtime = "python3.7"
}

resource "aws_cloudwatch_event_rule" "CIS_2-3_RR_CWE" {
  name        = "CIS_2-3_RR_CWE"
  description = "Remediates CIS 2.3 by making CloudTrail log bucket private"

  event_pattern = <<EOF
{
  "source" : ["aws.securityhub"],
  "detail-type": ["Security Hub Findings - Custom Action"],
  "resources": ["arn:aws:securityhub:us-east-1:832437335724:action/custom/cis23RR"]

}
EOF

}

resource "aws_cloudwatch_event_target" "CIS23RRActionTarget" {
    rule = aws_cloudwatch_event_rule.CIS_2-3_RR_CWE.name
    target_id = "CIS_2-3_RR_CWE"
    arn = aws_lambda_function.CIS23RRLambdaFunction.arn



  
}

resource "aws_lambda_permission" "CIS23RRCWEPermissions" {
  statement_id  = "CIS23RRCWEPermissions"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CIS23RRLambdaFunction.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.CIS_2-3_RR_CWE.arn
}
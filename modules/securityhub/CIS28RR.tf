data "archive_file" "CIS28RRLambda"{
    type = "zip"
    source_file = "${path.module}/lambda/CIS28RRLambda.py"
    output_path = "CIS28RRLambda.zip"
}

resource "aws_lambda_function" "CIS28RRLambdaFunction" {
  filename      = "CIS28RRLambda.zip"
  function_name = "CIS_2-8_RR"
  description = "Remediates CIS 2.8 by enabling key rotation for KMS CMKs"
  role = aws_iam_role.CIS28RRLambdaRole.arn
  handler       = "CIS28RRLambda.lambda_handler"


  #source_code_hash = filebase64sha256("CIS13RRLambda.zip")

  runtime = "python3.7"
}

resource "aws_cloudwatch_event_rule" "CIS_2-8_RR_CWE" {
  name        = "CIS_2-8_RR_CWE"
  description = "Remediates CIS 2.8 by enabling key rotation for KMS CMKs"

  event_pattern = <<EOF
{
  "source" : ["aws.securityhub"],
  "detail-type": ["Security Hub Findings - Custom Action"],
  "resources": ["arn:aws:securityhub:us-east-1:832437335724:action/custom/cis28RR"]

}
EOF

}

resource "aws_cloudwatch_event_target" "CIS28RRActionTarget" {
    rule = aws_cloudwatch_event_rule.CIS_2-8_RR_CWE.name
    target_id = "CIS_2-8_RR_CWE"
    arn = aws_lambda_function.CIS28RRLambdaFunction.arn



  
}

resource "aws_lambda_permission" "CIS28RRCWEPermissions" {
  statement_id  = "CIS28RRCWEPermissions"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CIS28RRLambdaFunction.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.CIS_2-8_RR_CWE.arn
}
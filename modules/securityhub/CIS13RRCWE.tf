data "archive_file" "CIS13RRLambda"{
    type = "zip"
    source_file = "${path.module}/lambda/CIS13RRLambda.py"
    output_path = "CIS13RRLambda.zip"
}

resource "aws_lambda_function" "CIS13RRLambdaFunction" {
  filename      = "CIS13RRLambda.zip"
  function_name = "CIS13RRLambda"
  description = "Remediates CIS 1.3 and CIS 1.4 by Deleting IAM Keys over 90 Days Old"
  role = aws_iam_role.CIS13RRLambdaRole.arn
  handler       = "CIS13RRLambda.lambda_handler"


  #source_code_hash = filebase64sha256("CIS13RRLambda.zip")

  runtime = "python3.7"
}


resource "aws_cloudwatch_event_rule" "cis_1_3_1_4_rr_cwe" {
  name        = "CIS_1-3_1-4_RR_CWE"
  description = "Remediates CIS 1.3 and CIS 1.4 by Deleting IAM Keys over 90 Days Old"

  event_pattern = <<EOF
{
  "source" : ["aws.securityhub"],
  "detail-type": ["Security Hub Findings - Custom Action"],
  "resources": ["arn:aws:securityhub:us-east-1:832437335724:action/custom/cis134RR"]

}
EOF

}

resource "aws_cloudwatch_event_target" "CIS13RRActionTarget" {
    rule = aws_cloudwatch_event_rule.cis_1_3_1_4_rr_cwe.name
    target_id = "CIS_1-3-4_RR_CWE"
    arn = aws_lambda_function.CIS13RRLambdaFunction.arn



  
}

resource "aws_lambda_permission" "CIS13RRCWEPermissions" {
  statement_id  = "CIS13RRCWEPermissions"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CIS13RRLambdaFunction.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cis_1_3_1_4_rr_cwe.arn
}
data "archive_file" "CIS29RRLambda"{
    type = "zip"
    source_file = "${path.module}/lambda/CIS29RRLambda.py"
    output_path = "CIS29RRLambda.zip"
}

resource "aws_lambda_function" "CIS29RRLambdaFunction" {
  filename      = "CIS29RRLambda.zip"
  function_name = "CIS_2-9_RR"
  description = "Remediates CIS 2.9 by enabling reject filtered VPC flow logging for VPCs without it"
  role = aws_iam_role.CIS29RRLambdaRole.arn
  handler       = "CIS29RRLambda.lambda_handler"


  #source_code_hash = filebase64sha256("CIS13RRLambda.zip")

  runtime = "python3.7"
}

resource "aws_cloudwatch_event_rule" "CIS_2-9_RR_CWE" {
  name        = "CIS_2-9_RR_CWE"
  description = "Remediates CIS 2.9 by enabling reject filtered VPC flow logging for VPCs without it"

  event_pattern = <<EOF
{
  "source" : ["aws.securityhub"],
  "detail-type": ["Security Hub Findings - Custom Action"],
  "resources": ["arn:aws:securityhub:us-east-1:${var.account_id}:action/custom/cis29RR"]

}
EOF

}

resource "aws_cloudwatch_event_target" "CIS29RRActionTarget" {
    rule = aws_cloudwatch_event_rule.CIS_2-9_RR_CWE.name
    target_id = "CIS_2-9_RR_CWE"
    arn = aws_lambda_function.CIS29RRLambdaFunction.arn



  
}

resource "aws_lambda_permission" "CIS29RRCWEPermissions" {
  statement_id  = "CIS29RRCWEPermissions"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CIS29RRLambdaFunction.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.CIS_2-9_RR_CWE.arn
}
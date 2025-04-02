resource "aws_securityhub_action_target" "slack" {
  
  name        = "send to slack"
  identifier  = "SecurityHubFindingsToSlack"
  description = "Send Messages to slack Application"
  
  depends_on  = [aws_securityhub_account.securityhub]
}
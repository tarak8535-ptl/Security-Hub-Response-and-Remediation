module "securityhub_to_slack" {
  source             = "../modules/securityhub_to_slack"
  IncomingWebHookURL = "https://hooks.slack.com/services/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"
  SlackChannel       = "shf"

}
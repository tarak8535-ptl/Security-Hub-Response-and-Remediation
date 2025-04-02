resource "aws_securityhub_finding_aggregator" "Finding_aggregator" {
    depends_on = [
      aws_securityhub_account.securityhub
    ]
    linking_mode = "ALL_REGIONS"
  
}
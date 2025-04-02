resource "aws_securityhub_standards_subscription" "Security_Best_Practices" {
  depends_on = [
    aws_securityhub_account.securityhub
  ]
  standards_arn = "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0"
}

resource "aws_securityhub_standards_subscription" "CIS" {
  depends_on = [
    aws_securityhub_account.securityhub
  ]
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

resource "aws_securityhub_standards_subscription" "PCI-321" {
  depends_on = [
    aws_securityhub_account.securityhub
  ]
  standards_arn = "arn:aws:securityhub:us-east-1::standards/pci-dss/v/3.2.1"
}
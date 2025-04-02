resource "aws_securityhub_insight" "account_id" {
  filters {
    aws_account_id {
        comparison = "EQUALS"
        value = var.account_id
    }
  }
  group_by_attribute = "AwsAccountId"
  name = "Insight by Account Id"
  depends_on = [
    aws_securityhub_account.securityhub
  ]
}

#  resource "aws_securityhub_insight" "Date_Range" {
#    filters {
#      created_at{
#        date_range{
#          unit = "DAYS"
#          value = 2
#        }
#      }
#    }

#    group_by_attribute = "CreatedAt"
#    name = "By Date Range"
#    depends_on = [
#      aws_securityhub_account.Rp
#    ]
#  }

# resource "aws_securityhub_insight" "Insight_by_Confidence" {
#   filters {
#     confidence{
#       gte = "80"
#     }
#   }

#   group_by_attribute = "Confidence"
#   name = "Insight by Insight"
#   depends_on = [
#     aws_securityhub_account.Rp
#   ]
# }

resource "aws_securityhub_insight" "severity" {
  filters {
    finding_provider_fields_severity_label{
      comparison = "EQUALS"
      value = "CRITICAL"
    }

    finding_provider_fields_severity_label{
      comparison = "EQUALS"
      value = "INFORMATIONAL"
    }

    finding_provider_fields_severity_label{
      comparison = "EQUALS"
      value = "HIGH"
    }

    finding_provider_fields_severity_label{
      comparison = "EQUALS"
      value = "MEDIUM"
    }

    finding_provider_fields_severity_label{
      comparison = "EQUALS"
      value = "LOW"
    }
  }
  group_by_attribute = "FindingProviderFieldsSeverityLabel"
  name = "Insight by Severity Label"
  depends_on = [
    aws_securityhub_account.securityhub
  ]
}

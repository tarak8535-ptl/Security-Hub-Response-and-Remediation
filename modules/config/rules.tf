resource "aws_config_config_rule" "securityhub_enabled" {
  name = "Securityhub_Enabled"

  source {
    owner = "AWS"
    source_identifier = "SECURITYHUB_ENABLED"
  }

  depends_on = [
    aws_config_configuration_recorder.config_rec
  ]
  
}

# resource "aws_config_config_rule" "access_keys_rotated" {
#   name = "Access_Keys_Rotated"

#   source {
#     owner = "AWS"
#     source_identifier = "ACCESS_KEYS_ROTATED"
#   }

#   depends_on = [
#     aws_config_configuration_recorder.config_rec
#   ]
  
# }
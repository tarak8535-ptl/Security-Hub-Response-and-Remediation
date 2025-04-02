provider "aws" {
  region = "us-east-1"
}


resource "aws_config_configuration_recorder" "config_rec" {
  name = "AWS_Config_Recorder_1"
  role_arn = aws_iam_role.config_role.arn
  recording_group {
      #all_supported = true
      #include_global_resource_types = true
      resource_types = [
          "dynamodb:GetItem"
      ]
  }
}

resource "aws_config_delivery_channel" "delivery_channel" {
    name = "Delivery-Channel"
    s3_bucket_name = aws_s3_bucket.config_bucket.bucket
    depends_on = [
      aws_config_configuration_recorder.config_rec
    ]
  
}

resource "aws_config_configuration_recorder_status" "config_rec_status" {
    name = aws_config_configuration_recorder.config_rec.name
    is_enabled = true
    depends_on = [
        aws_config_delivery_channel.delivery_channel
    ]
  
}



require 'aws-sdk'
Aws.config[:credentials] = Aws::Credentials.new(Rails.application.secrets.aws_key_id, Rails.application.secrets.aws_secret_key)
Aws.config[:region] = 'us-east-1'
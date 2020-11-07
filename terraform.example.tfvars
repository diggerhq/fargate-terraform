iam_user = "your_user" 
aws_key = "aws_key"
aws_secret = "aws_secret"

app = "digger"
environment = "dev"

aws_profile = "default"
container_port = "8001"
replicas = "1"
health_check = "/health"
tags = {
  application   = "my-app"
  environment   = "dev"
  team          = "digger"
  customer      = "EF"
  contact-email = "me@domain.com"
}

internal = false

launch_type = "FARGATE"

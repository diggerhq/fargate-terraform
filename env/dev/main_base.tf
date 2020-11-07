
variable "aws_key" {
}

variable "aws_secret" {
}

terraform {
  required_version = ">= 0.12"

  backend "s3" {}
}

/**
 * main.tf
 * The main entry point for Terraform run
 * See variables.tf for common variables
 * See ecr.tf for creation of Elastic Container Registry for all environments
 * See state.tf for creation of S3 bucket for remote state
 */

# Using the AWS Provider
# https://www.terraform.io/docs/providers/
provider "aws" {
  version = ">= 2.23.0"
  region  = var.region
  # profile = var.aws_profile
  access_key = var.aws_key
  secret_key = var.aws_secret
}

resource "aws_iam_user" "project_user" {
  name = var.iam_user
}

resource "aws_iam_access_key" "project_user_key" {
  user    = aws_iam_user.project_user.name
}

/*
 * Outputs
 * Results from a successful Terraform run (terraform apply)
 * To see results after a successful run, use `terraform output [name]`
 */

# Returns the name of the ECR registry, this will be used later in various scripts
output "docker_registry" {
  value = aws_ecr_repository.app.repository_url
}

output "project_user_access_key" {
  value = aws_iam_access_key.project_user_key.id
}

output "project_user_secret" {
  value = aws_iam_access_key.project_user_key.secret
}

# Returns the name of the S3 bucket that will be used in later Terraform files
# output "bucket" {
#   value = module.tf_remote_state.bucket
# }

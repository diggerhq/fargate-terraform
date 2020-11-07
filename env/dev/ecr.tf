/*
 * ecr.tf
 * Creates a Amazon Elastic Container Registry (ECR) for the application
 * https://aws.amazon.com/ecr/
 */

variable "iam_user" {
  type = string
}

# The tag mutability setting for the repository (defaults to IMMUTABLE)
variable "image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "The tag mutability setting for the repository (defaults to IMMUTABLE)"
}

# create an ECR repo at the app/image level
resource "aws_ecr_repository" "app" {
  name                 = var.app
  image_tag_mutability = var.image_tag_mutability
}

data "aws_caller_identity" "current" {
}

# grant access to saml users
resource "aws_ecr_repository_policy" "app" {
  repository = aws_ecr_repository.app.name
  # policy     = data.aws_iam_policy_document.ecr.json
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "ECR Policy ${aws_iam_user.project_user.name}",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::739940681129:user/${aws_iam_user.project_user.name}",
              "Service": "sts.amazonaws.com"
            },
            "Action": [
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "ecr:BatchCheckLayerAvailability",
              "ecr:PutImage",
              "ecr:InitiateLayerUpload",
              "ecr:UploadLayerPart",
              "ecr:CompleteLayerUpload",
              "ecr:DescribeRepositories",
              "ecr:GetRepositoryPolicy",
              "ecr:ListImages",
              "ecr:DescribeImages",
              "ecr:DeleteRepository",
              "ecr:BatchDeleteImage",
              "ecr:SetRepositoryPolicy",
              "ecr:DeleteRepositoryPolicy",
              "ecr:GetLifecyclePolicy",
              "ecr:PutLifecyclePolicy",
              "ecr:DeleteLifecyclePolicy",
              "ecr:GetLifecyclePolicyPreview",
              "ecr:StartLifecyclePolicyPreview"
            ]
        }
    ]
}
EOF

}

# data "aws_iam_policy_document" "ecr" {
#   statement {
#     actions = [
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatchGetImage",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:PutImage",
#       "ecr:InitiateLayerUpload",
#       "ecr:UploadLayerPart",
#       "ecr:CompleteLayerUpload",
#       "ecr:DescribeRepositories",
#       "ecr:GetRepositoryPolicy",
#       "ecr:ListImages",
#       "ecr:DescribeImages",
#       "ecr:DeleteRepository",
#       "ecr:BatchDeleteImage",
#       "ecr:SetRepositoryPolicy",
#       "ecr:DeleteRepositoryPolicy",
#       "ecr:GetLifecyclePolicy",
#       "ecr:PutLifecyclePolicy",
#       "ecr:DeleteLifecyclePolicy",
#       "ecr:GetLifecyclePolicyPreview",
#       "ecr:StartLifecyclePolicyPreview",
#     ]

#     principals {
#       type = "Service"

#       # Add the saml roles for every member on the "team"
#       identifiers = [
#         # todo change this to be more granular
#         "sts.amazonaws.com"
#         # "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/${aws_iam_role.app.name}/me@example.com",
#       ]
#     }

#     principals {
#       type = "AWS"

#       identifiers = [
#         "arn:aws:iam::739940681129:user/motatoes"
#       ]
#     }
#   }

#   statement {

#   }
# }

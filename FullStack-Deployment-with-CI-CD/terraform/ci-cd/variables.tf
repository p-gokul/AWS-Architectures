variable "aws_region" {
  default = "ap-northeast-1"
}

variable "github_secret_arn" {
  default = "your_github_secret_arn"
}
variable "github_repo" {
  default = "https://github.com/p-gokul/full-stack-ci-cd"
}

# FrontEnd #
variable "iam_policy_name" {
  default = "codebuild-frontend-s3-cloudfront-access"
}

variable "iam_role_name" {
  default = "codebuild-frontend-role"
}

variable "codebuild_frontend_project_name" {
  default = "TestFrontend"
}

# Backend #

variable "iam_backend_role_name" {
  default = "codebuild-backend-role"
}

variable "iam_backend_policy_name" {
  default = "codebuild-backend-ecr-ecs-access"
}

variable "codebuild_backend_project_name" {
  default = "TestBackend"
}


###############################
# CodeBuild Project: Frontend #
###############################

resource "aws_codebuild_project" "frontend" {
  name          = var.codebuild_frontend_project_name
  description   = "Build frontend React app and deploy to S3/CloudFront"
  service_role  = aws_iam_role.codebuild_service_role.arn
  build_timeout = 5

  source {
    type            = "GITHUB"
    location        = var.github_repo
    git_clone_depth = 1
    buildspec       = "ci-cd/frontend-buildspec.yaml"

    git_submodules_config {
      fetch_submodules = false
    }
  }

  environment {
    compute_type                = "BUILD_LAMBDA_2GB"
    image                       = "aws/codebuild/amazonlinux-aarch64-lambda-standard:nodejs22"
    type                        = "ARM_LAMBDA_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/TestFrontend"
      stream_name = "build-log"
      status      = "ENABLED"
    }
  }

  source_version = "main"
}

##########################
# GitHub Webhooks Setup  #
##########################

resource "aws_codebuild_webhook" "frontend_webhook" {
  project_name = aws_codebuild_project.frontend.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "FILE_PATH"
      pattern = "client/*"
    }
  }



  filter_group {

    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "FILE_PATH"
      pattern = "frontend/*"
    }
  }

  filter_group {

    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "FILE_PATH"
      pattern = "ci-cd/frontend-buildspec.yaml"
    }
  }

}
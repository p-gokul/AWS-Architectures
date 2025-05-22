
###############################
# CodeBuild Project: Backend #
###############################

resource "aws_codebuild_project" "backend" {
  name          = var.codebuild_backend_project_name
  description   = "Build backend express app, build image, push to ECR and deploy to ECS"
  service_role  = aws_iam_role.codebuild_service_role.arn
  build_timeout = 5

  source {
    type            = "GITHUB"
    location        = var.github_repo
    git_clone_depth = 1
    buildspec       = "ci-cd/backend-buildspec.yaml"

    git_submodules_config {
      fetch_submodules = false
    }
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/TestBackend"
      stream_name = "build-log"
      status      = "ENABLED"
    }
  }

  source_version = "main"
}

##########################
# GitHub Webhooks Setup  #
##########################

resource "aws_codebuild_webhook" "backend_webhook" {
  project_name = aws_codebuild_project.backend.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "FILE_PATH"
      pattern = "server/*"
    }
  }

  filter_group {

    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "FILE_PATH"
      pattern = "backend/*"
    }
  }

  filter_group {

    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "FILE_PATH"
      pattern = "ci-cd/backend-buildspec.yaml"
    }
  }

}
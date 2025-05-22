resource "aws_ecr_repository" "ecr-1" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"
}


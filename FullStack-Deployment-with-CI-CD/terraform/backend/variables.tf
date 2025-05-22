variable "aws_region" {
  default = "ap-northeast-1"
}

variable "ecr_repo_name" {
  default = "new-test-repo"
}

variable "ecs_cluster_name" {
  default = "TestCluster2"
}

variable "app_port" {
  description = "Port the application listens on"
  type        = string
  default     = 5000
}

variable "db_url" {
  description = "Database connection URL"
  type        = string
  default     = "your_db_url"
}

terraform {
  backend "s3" {
    bucket  = "progineer-devops-task-backend-bucket"
    key     = "devops-task-state"
    region  = "eu-west-1"
  }
}
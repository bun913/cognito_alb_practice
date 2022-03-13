variable "tags" {
  type = map(string)
  default = {
    "Project"   = "cognito-alb"
    "Terraform" = "true"
  }
}

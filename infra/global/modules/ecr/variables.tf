variable "prefix" {
  type        = string
  description = "Default Prefix of Resource Name"
}
variable "tags" {
  type = map(string)
  default = {
    "Project"   = "cognito-alb"
    "Terraform" = "true"
  }
}

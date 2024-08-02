variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "Expense"
    Environment = "Dev"
    Terraform = "true"
    Component = "backend"
  }
}

variable "zone_name" {
  default = "puneeth.cloud"
}

variable "zone_id" {
  default = "Z0556624WQKDAH73JX3X"
}
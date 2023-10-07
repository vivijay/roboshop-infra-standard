variable "project_name" {
    default = "roboshop"
  
}
variable "env" {
  default = "dev"
}

# variable "cidr_block" {
#   default = "10.0.0.0/16"
# }

variable "common_tags" {
  default = {
    Project = "roboshop"
    Component = "Mysql"
    Environment = "DEV"
    Terraform = "true"
  }
}

variable "zone_name" {
  default = "learndevcloud.online"
}
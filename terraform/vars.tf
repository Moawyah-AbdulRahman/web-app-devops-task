variable "db_instance_type" {
    type        = string
    default     = "t2.micro"
    description = "Type for the instance hosting the database"
}

variable "frontend_instance_type" {
    type        = string
    default     = "t2.micro"
    description = "Type for the instance hosting the flask web app"
}

variable "allow_ssh_access_from" {
    default     = ["0.0.0.0/0"]
    description = "CIDR blocks specifying from where you can access the instances"
}
variable "my_ip" {
  default = "xxx.xxx.xxx/32"
  type    = string
}

variable "ec2_config" {
  type = object({
    ami           = string
    instance_type = string
    storage_size  = number
    storage_type  = string
    ssh_key_name  = string
  })

  default = {
    ami           = "ami-0360c520857e3138f"
    instance_type = "t2.micro"
    storage_size  = 8 // GB
    storage_type  = "gp3"
    ssh_key_name  = "cloud-computing-kp"
  }
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR block."
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Default region."
}

variable "vpc_name" {
  type        = string
  default     = "server-vpc"
  description = "VPC name."
}

variable "aws_azs" {
  description = "List of az in the specified region"
  type        = list(string)
  default     = ["us-east-1a"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "Public subnet CIDR blocks."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.101.0/24"]
  description = "Private subnet CIDR blocks."
}

variable "hosted_zone_id" {
  type        = string
  description = "Hosted zone id."
}

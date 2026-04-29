variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the EC2 instance"
}

variable "sg_id" {
  type        = string
  description = "Security Group ID"
}

variable "key_name" {
  type        = string
  description = "Key pair name for SSH access"
}

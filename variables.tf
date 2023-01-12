variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc1_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "subnet_01_cidr" {
  type    = string
  default = "10.1.1.0/24"
}

variable "asn" {
  type    = string
  default = "64512"
}

variable "vpc2_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

variable "subnet_02_cidr" {
  type    = string
  default = "10.2.1.0/24"
}

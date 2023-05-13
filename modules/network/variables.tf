data "aws_region" "current" {}

variable "name" { type = string }
variable "vpc_id" { type = string }

variable "subnet" {
  type = object({
      a = string
      c = string
      d = string
  })
}

variable "internet_gateway_id" {
  type = string
  default = null
}
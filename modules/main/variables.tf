data "aws_region" "current" {}

variable "project" { type = string }
variable "vpc_name" { type = string }
variable "vpc_id" { type = string }

variable "subnet" {
  type = object({
    public = object({
      a = string
      c = string
      d = string
    })
    private = object({
      a = string
      c = string
      d = string
    })
  })
}
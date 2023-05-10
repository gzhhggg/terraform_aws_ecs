variable "access_key" { type = string }
variable "secret_key" { type = string }
variable "domain" { type = string }
variable "username" { type = string }
variable "password" { type = string }
variable "baketname" { type = string }
variable "adoress" { type = string }

data "aws_region" "current" {}

locals {
  vpc_name = "aws_test"
  vpc_id   = "10.0.0.0/16"

  subnet = {
    public = {
      a = "10.0.10.0/25"
    }
  }

  ami           = "ami-052c9af0c988f8bbd"
  instance_type = "t2.micro"

  repository = "hello-world-ecs-test"
}
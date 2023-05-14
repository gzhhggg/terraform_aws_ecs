locals {
  project  = "test-service"
  vpc_name = "aws_test"
  vpc_cidr   = "10.0.0.0/16"

  subnet = {
    public = {
      a = "10.0.0.0/24"
      c = "10.0.1.0/24"
      d = "10.0.2.0/24"
    }
    private = {
      a = "10.0.3.0/24"
      c = "10.0.4.0/24"
      d = "10.0.5.0/24"
    }
    availability_zone = {
      a = "ap-northeast-1a"
      c = "ap-northeast-1c"
      d = "ap-northeast-1d"
    }
  }
}
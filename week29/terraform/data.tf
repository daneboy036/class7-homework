data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["bmc-class7-vpc"]
  }
}

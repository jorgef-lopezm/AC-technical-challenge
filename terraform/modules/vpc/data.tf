# Query the availability zone within the region set
# for creating the subnets
data "aws_availability_zones" "available" {
  state = "available"
}
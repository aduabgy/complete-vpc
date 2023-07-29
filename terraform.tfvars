region = "eu-west-2" # Replace with your desired AWS region
vpc-cidr = "10.0.0.0/16" # Replace with your desired VPC CIDR block
tenancy = "default"
env_prefix = "Dev"
pub-sub-cidr = ["10.0.1.0/24", "10.0.2.0/24"]
private-sub-cidr = ["10.0.3.0/24", "10.0.4.0/24"]
avail-zone = ["eu-west-2a", "eu-west-2b"]
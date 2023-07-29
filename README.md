# complete-vpc

AWS VPC Terraform Configuration
This Terraform configuration creates an AWS VPC (Virtual Private Cloud) with public and private subnets, internet gateway, NAT gateway, and a security group. The VPC setup is designed to provide a secure environment for hosting web applications.

Usage
Install Terraform and configure your AWS credentials.

Create a file with the .tf extension (e.g., main.tf) and paste the provided Terraform code.

Customize the variables in the code to match your requirements (e.g., VPC CIDR block, subnet CIDR blocks, availability zones).

Initialize the Terraform configuration:


Copy code
terraform init
Preview the changes that will be applied:

Copy code
terraform plan
Apply the configuration to create the VPC and associated resources:

Copy code
terraform apply
When you're done, you can remove the resources to avoid ongoing charges:

Copy code
terraform destroy
Key Resources Created
VPC: A custom AWS VPC is created with the specified CIDR block and tenancy.

Internet Gateway: An internet gateway is created and attached to the VPC to enable outbound internet access.

Subnets: Two public and two private subnets are created in different availability zones to distribute resources across AWS infrastructure.

Route Tables: Two route tables are created, one for public subnets with an internet gateway route, and one for private subnets with a NAT gateway route.

NAT Gateway: A NAT gateway is created in the first public subnet to allow private instances to access the internet.

Security Group: A security group is created to allow inbound traffic for SSH (port 22) and HTTP (port 8080) from any source and unrestricted outbound traffic.

Note
Please review the code and customize the variables according to your specific use case. Ensure that you understand the implications of creating and managing AWS resources before executing Terraform commands. For more information, refer to the AWS Terraform documentation and best practices.

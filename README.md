# tf-aws-infra
Terraform project to setup infra for CSYE-6225

Creates the following infra on AWS-
- VPC
- 3 public subnets
- 3 private subnets
- Internet gateway
- public routing table
- private routing table

Setup 
```
terraform init
terraform validate
terraform fmt -recursive
terraform apply
```

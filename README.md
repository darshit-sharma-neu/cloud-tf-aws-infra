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

## Importing SSL Certificate into AWS Certificate Manager

To import an SSL certificate into AWS Certificate Manager (ACM), use the following command:

```bash
aws acm import-certificate \
  --certificate fileb://path/to/certificate.crt \
  --private-key fileb://path/to/private.key \
  --certificate-chain fileb://path/to/certificate_chain.crt \
  --region your-region

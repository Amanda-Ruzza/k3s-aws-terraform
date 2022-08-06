# k3s-aws-terraform
Full AWS infrastructure using Rancher K3S and Terraform

----------
AWS Simple Kubernetes Deployment Based on Derek Morgan’s ‘More than Certified Course’

Used the following:

- 
- Terraform Cloud for a remote backend, 
- Modules, variables and different functions,
- The cidrsubnet function to calculate a subnet address within given IP network address prefix,
- The  random_shuffle resource to generate a random permutation of a list of the amount of AZ’s needed for the deployment,
- The Lifecycle Policy that tells TF to create a new VPC before it destroys the current VPC. This will avoid TF crashing issues with the Internet Gateway,
- Dynamic Blocks and For_Each loops for the security groups in the networking module
- Specific Subnet Group for RDS
- Count function to determine if the RDS Subnet Group would be deployed
- Created a specific Database Module
- Created an RDS instance, as K3s allows a standard SQL database to store data, instead of the ‘etcd’ data store for Kubernetes
- Created and ALB Module that deployed an Application Load Balancer in the Public Security Group that will forward traffic from port 80 into the EC2 [K3s] instances
- Combined the substring (substr) + UUID functions to generate a Unique ID for the ALB Target Group [For example: > substr(uuid(), 0, 4) results in: “c4f5” which are 4 items on the large main uuid unique id generator]
- —————
    - [August 5: was able to deploy all the way into the ALB, but still trying to debug issues after attempting to add the ALB listener]
    - 

——
Future goals:
Create a Bastion Host + NAT Gateway
Move the EC2 instances into a new public subnet
Install a Cloudwatch agent in them, and send the logs to an S3 Bucket 

--------
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_loadbalancing"></a> [loadbalancing](#module\_loadbalancing) | ./loadbalancing | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ./networking | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_ip"></a> [access\_ip](#input\_access\_ip) | n/a | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_dbname"></a> [dbname](#input\_dbname) | ---- database-variables ----- | `string` | n/a | yes |
| <a name="input_dbpassword"></a> [dbpassword](#input\_dbpassword) | n/a | `string` | n/a | yes |
| <a name="input_dbuser"></a> [dbuser](#input\_dbuser) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
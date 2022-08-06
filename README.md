# k3s-aws-terraform
Full AWS infrastructure using Rancher K3S and Terraform

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
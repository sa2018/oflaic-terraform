## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_availability\_zones | List of availability zones | `list(string)` | n/a | yes |
| name | Name of the VPC | `string` | n/a | yes |
| private\_subnets | Private subnets | `list(string)` | n/a | yes |
| public\_subnets | Public subnets | `list(string)` | n/a | yes |
| tags | Tags to add to created resources. | `map(string)` | n/a | yes |
| vpc\_cidr | VPC CIDR block address | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| azs | n/a |
| private\_subnets | n/a |
| public\_subnets | n/a |
| vpc\_id | n/a |


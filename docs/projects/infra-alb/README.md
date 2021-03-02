## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backend\_container\_port | Backend container port | `number` | n/a | yes |
| name | Name of the Load Balancer | `string` | n/a | yes |
| subnets | Subnets | `list(string)` | n/a | yes |
| tags | Tags to add to created resources. | `map(string)` | n/a | yes |
| vpc\_id | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| alb\_arn | n/a |
| alb\_sg | n/a |
| api\_resource | n/a |
| api\_target\_group\_arn | n/a |


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_alb\_sg | Load balancer SG for ingress | `string` | n/a | yes |
| api\_target\_group\_arn | Load balancer API target group arn | `string` | n/a | yes |
| backend\_container\_image | Backend container image | `string` | n/a | yes |
| backend\_container\_port | Backend container port | `number` | n/a | yes |
| cluster\_id | ID of the ECS cluster | `string` | n/a | yes |
| name | Name of the Service | `string` | n/a | yes |
| size | Service size | `number` | n/a | yes |
| subnets | Subnets | `list(string)` | n/a | yes |
| tags | Tags to add to created resources. | `map(string)` | n/a | yes |
| vpc\_id | VPC ID | `string` | n/a | yes |

## Outputs

No output.


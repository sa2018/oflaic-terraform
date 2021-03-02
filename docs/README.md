## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | ~> 3.10.0 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_availability\_zones | List of availability zones | `list(string)` | <pre>[<br>  "ap-southeast-1a",<br>  "ap-southeast-1b"<br>]</pre> | no |
| aws\_region | n/a | `string` | `"ap-southeast-1"` | no |
| backend\_container\_image | Backend container image | `string` | `"seartun/dummy-api"` | no |
| backend\_container\_port | Backend container port | `number` | `3030` | no |
| environment | Environment | `string` | `"stg"` | no |
| private\_subnets | Private subnets | `list(string)` | <pre>[<br>  "10.0.10.0/24",<br>  "10.0.11.0/24"<br>]</pre> | no |
| project | Project name | `string` | `"app"` | no |
| public\_subnets | Public subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24"<br>]</pre> | no |
| vpc\_cidr | VPC CIDR block address | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| api\_resource\_url | n/a |


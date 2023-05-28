<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 4.0 |
| <a name="requirement_aws"></a> [template](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="text"></a> text | The dynamic string that is rendered to the index.html | `string` | awesome | yes |
| <a name="domain_name"></a> domain_name| The name of the S3 bucket that hosts the index.html | `string` | jasdeep | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="endpoint"></a> endpoint | Endpoint of website |

<!-- END_TF_DOCS -->
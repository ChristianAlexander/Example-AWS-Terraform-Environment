# Example AWS Terraform Environment

Creates an AWS environment with a public-facing instance, a private instance, and all of the requisite networking infrastructure.

## Running

1. `terraform init`
2. Set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.
3. `terraform plan` - Notice what the plan will do.
4. `terraform apply`

## Connecting

This will SSH you into the private instance via the public instance.

1. Run the plan.
2. Append the contents of the output `ssh_config_addition` to your ssh config (typically `~/.ssh/config`).
3. Run the contents of the output `ssh_command`.

## Cleaning

To clean up, run `terraform destroy`.

Luckily, Terraform keeps track of everything it created, so there shouldn't be any mysterious line items in the AWS bill a few months from now :)

module "efs" {
  source = "github.com/cloudposse/terraform-aws-efs.git?ref=0.11.0"

  name               = var.name
  region             = var.vpc_state_region
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets            = data.terraform_remote_state.vpc.outputs.private_subnets
  security_groups    = list(data.terraform_remote_state.eks.outputs.worker_security_group_id)
  performance_mode   = var.performance_mode
  encrypted          = var.encrypted

  tags = var.tags
}
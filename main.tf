module "efs" {
  source = "github.com/cloudposse/terraform-aws-efs.git?ref=0.14.0"

  name             = var.name
  region           = var.vpc_state_region
  vpc_id           = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets          = data.terraform_remote_state.vpc.outputs.private_subnets
  security_groups  = list(data.terraform_remote_state.eks.outputs.worker_security_group_id)
  performance_mode = var.performance_mode
  encrypted        = var.encrypted

  tags = var.tags
}

# Backup plan for EFS
locals {
  backup_count = var.backup_enabled ? 1 : 0
}

resource "aws_iam_role" "efs" {
  count              = local.backup_count
  name               = "efs"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "efs" {
  count      = local.backup_count
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.efs[local.backup_count - 1].name
}

resource "aws_backup_vault" "efs" {
  count = local.backup_count
  name  = "efs_backup_vault"
}

resource "aws_backup_plan" "efs" {
  count = local.backup_count
  name  = "efs_backup_plan"

  rule {
    rule_name         = "efs_backup_rule"
    target_vault_name = aws_backup_vault.efs[local.backup_count - 1].name
    schedule          = var.backup_plan_schedule

    lifecycle {
      delete_after = var.backup_plan_delete_after
    }
  }
}

resource "aws_backup_selection" "efs" {
  count        = local.backup_count
  iam_role_arn = aws_iam_role.efs[local.backup_count - 1].arn
  name         = "efs_backup_selection"
  plan_id      = aws_backup_plan.efs[local.backup_count - 1].id

  resources = [
    module.efs.arn
  ]
}

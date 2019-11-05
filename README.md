# Terraform AWS EFS
Terraform module which creates an EFS in an existing VPC.
At the moment, this module is linked to EKS since it only will allowed worker nodes to connect to it.

## Backups
This module creates a backup plan for EFS conditioned by `backup_enabled`.
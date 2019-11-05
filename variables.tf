####################
# VPC remote state #
####################
variable "vpc_bucket" {
  description = "Name of the bucket where vpc state is stored"
}

variable "vpc_state_key" {
  description = "Key where the state file of the VPC is stored"
}

variable "vpc_state_region" {
  description = "Region where the state file of the VPC is stored"
}

####################
# EKS remote state #
####################
variable "eks_bucket" {
  description = "Name of the bucket where EKS state is stored"
}

variable "eks_state_key" {
  description = "Key where the state file of the EKS is stored"
}

variable "eks_state_region" {
  description = "Region where the state file of the EKS is stored"
}

#######
# EFS #
#######
variable "name" {
  type        = string
  description = "Name (_e.g._ `app`)"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. `{ BusinessUnit = \"XYZ\" }`"
  default     = {}
}

variable "encrypted" {
  type        = bool
  description = "If true, the file system will be encrypted"
  default     = false
}

variable "performance_mode" {
  type        = string
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"
  default     = "generalPurpose"
}

variable "security_group_name" {
  description = "Name of security group associated to the RDS instance"
  type        = string
  default     = "efs_sg"
}

###########
# Backups #
###########
variable "backup_plan_delete_after" {
  description = "Specifies the number of days after creation that a recovery point is deleted"
  type        = string
  default     = "15"
}

variable "backup_plan_schedule" {
  description = "A CRON expression specifying when AWS Backup initiates a backup job."
  type        = string
  default     = "cron(0 4 * * ?)"
}

variable "backup_enabled" {
  description = "Control the creation of backup plan"
  type        = bool
  default     = true
}
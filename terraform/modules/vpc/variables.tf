variable "AWS_REGION" {
  type        = string
  default     = "ap-northeast-2"
  description = "The region in which AWS resources will be created"
}

variable "ENVIRONMENT" {
  type    = string
  default = ""
}

variable "MASTER_INGRESS_RULES" {
  description = "List of ingress rules of master"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    security_groups = list(string)
  }))
  default = []
}

variable "WORKER_INGRESS_RULES" {
  description = "List of ingress rules of worker"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    security_groups = list(string)
  }))
  default = []
}
variable "AWS_REGION" {
  type        = string
  default     = "ap-northeast-2"
  description = "The region in which AWS resources will be created"
}

variable "ENVIRONMENT" {
  type    = string
  default = "DEV"
}

variable "MASTER_INGRESS_RULES" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    security_groups = list(string)
  }))
  default = [
    {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        # it can be ansible control node's ip
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = []
    },
  ]
}

variable "WORKER_INGRESS_RULES" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    security_groups = list(string)
  }))
  default = [
    {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        # it can be ansible control node's ip
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = []
    },
  ]
}

variable "INSTANCE_MASTER_COUNT" {
  type        = number
  default     = 1
  description = "The number of master instances"
}

variable "INSTANCE_WORKER_COUNT" {
  type        = number
  default     = 2
  description = "The number of worker instances"
}
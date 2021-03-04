variable "ecs_cluster_id" {
  type = string
}

variable "ecs_task_definition_family" {
  type    = string
  default = "ecs_task_definition"
}

variable "container_cpu" {
  type    = number
  default = 256
}

variable "container_memory" {
  type    = number
  default = 512
}

variable "container_name" {
  type = string
}

variable "docker_image" {
  type = string
}

variable "container_definition_template" {
  type    = string
  default = "task-definitions/service.json"
}

variable "ecs_service_name" {
  type    = string
  default = "service"
}

variable "application_port" {
  type    = number
  default = 8000
}

variable "requires_compatibilities" {
  type    = list(string)
  default = ["FARGATE"]
}

variable "network_mode" {
  type    = string
  default = "awsvpc"
}

variable "network_configuration_needed" {
  type    = bool
  default = false
}

variable "subnets" {
  type    = list(string)
  default = []
}

variable "assign_public_ip" {
  type    = bool
  default = false
}

variable "service_launch_type" {
  type    = string
  default = "FARGATE"
}

variable "service_scheduling_strategy" {
  type    = string
  default = "REPLICA"
}

variable "load_balancer_needed" {
  type    = bool
  default = false
}

variable "alb_target_group_arn" {
  type    = string
  default = null
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "vpc_id" {
  type = string
}

variable "ingress_rules" {
  type = list(
    object({
      from_port       = number
      to_port         = number
      security_groups = list(string)
      cidr_blocks     = list(string)
      protocol        = string
      description     = string
    })
  )
  default = []
}

variable "egress_rules" {
  type = list(
    object({
      from_port       = number
      to_port         = number
      security_groups = list(string)
      cidr_blocks     = list(string)
      protocol        = string
      description     = string
    })
  )
  default = []
}
data "template_file" "container_definition" {
  template = file("${path.module}/${var.container_definition_template}")

  vars = {
    container_name   = var.container_name
    docker_image     = var.docker_image
    application_port = var.application_port
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = var.ecs_task_definition_family
  container_definitions = data.template_file.container_definition.rendered

  cpu    = var.container_cpu
  memory = var.container_memory

  requires_compatibilities = var.requires_compatibilities

  network_mode = var.network_mode
}

resource "aws_ecs_service" "service" {
  name                = var.ecs_service_name
  cluster             = var.ecs_cluster_id
  task_definition     = aws_ecs_task_definition.ecs_task_definition.arn
  launch_type         = var.service_launch_type
  scheduling_strategy = var.service_scheduling_strategy

  desired_count = var.desired_count

  dynamic "network_configuration" {
    for_each = var.network_configuration_needed ? [1] : []
    content {
      subnets          = var.subnets
      security_groups  = [aws_security_group.ecs_sg.id]
      assign_public_ip = var.assign_public_ip
    }
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer_needed ? [1] : []
    content {
      target_group_arn = var.alb_target_group_arn
      container_name   = var.container_name
      container_port   = var.application_port
    }
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
      description     = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks
      security_groups = egress.value.security_groups
      description     = egress.value.description
    }
  }
}
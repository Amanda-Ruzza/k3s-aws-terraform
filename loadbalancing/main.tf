# ----- loadbalancing/main.tf ----
# variable "vpc_id" {
#   description = "VPC ID."
#   type        = string
# } #trying this to see if I can make the ALB listener work


resource "aws_lb" "k3s_lb" {
  name            = "k3s-lb"
  subnets         = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout    = 400
}

resource "aws_lb_target_group" "k3s_tg" {
  name     = "k3s-lb-tg-${substr(uuid(), 0, 3)}" # This is an alternative method to generate a unique identifier instead of using the 'random' function
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    ignore_changes = [name] #This 'Lifecycle Ignore Changes Policy' will make TF keep redeploying a new LB everytime I redeploy the code because of the 'substring uuid' name function
    create_before_destroy = true #This is to ensure that a new TG is created before the current one is destroyed
  }
  health_check {
    healthy_threshold   = var.lb_healthy_threshold
    unhealthy_threshold = var.lb_unhealthy_threshold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }
}

resource "aws_lb_listener" "k3s_lb_listener" {
  load_balancer_arn = aws_lb.k3s_lb.arn
  port              = var.listener_port     #80
  protocol          = var.listener_protocol #"HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k3s_tg.arn
  }
}
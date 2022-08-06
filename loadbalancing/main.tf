# ----- loadbalancing/main.tf ----

resource "aws_lb" "k3s_lb" {
  name            = "k3s-lb"
  subnets         = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout    = 400
}

# resource "aws_lb_target_group" "k3s_tg" {
#   name     = "k3s-lb-tg-${substr(uuid(), 0, 3)}" # This is an alternative method to generate a unique identifier instead of using the 'random' function
#   port     = var.tg_port
#   protocol = var.tg_protocol
#   vpc_id   = var.vpc_id
#   health_check {
#     healthy_threshold   = var.lb_healthy_threshold
#     unhealthy_threshold = var.lb_unhealthy_threshold
#     timeout             = var.lb_timeout
#     interval            = var.lb_interval
#   }
# } 
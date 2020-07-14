resource "aws_lb" "collarks_alb" {
  name                       = "collarks-alb"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false

  security_groups = [
    aws_security_group.collarks_lb.id
  ]
  subnets = [
    aws_subnet.collarks_public["ap-northeast-1a"].id,
    aws_subnet.collarks_public["ap-northeast-1c"].id
  ]
}

resource "aws_lb_target_group" "collarks_blue" {
  name        = "collarks-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.collarks.id
  target_type = "ip"
  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_lb_target_group" "collarks_green" {
  name        = "collarks-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.collarks.id
  target_type = "ip"
  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_lb_listener" "collarks_alb_lsnr" {
  load_balancer_arn = aws_lb.collarks_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.collarks_green.arn
  }
}


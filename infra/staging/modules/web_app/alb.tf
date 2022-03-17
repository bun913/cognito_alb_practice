resource "aws_lb" "app" {
  name               = "${var.prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ingress_all.id]
  subnets            = var.public_subnets

  # NOTE: デモ用なので一時的に削除保護を無効にしている
  enable_deletion_protection = false

  # NOTE: デモ用なのでアクセスログは吐き出さない
  /* access_logs { */
  /*   bucket  = aws_s3_bucket.lb_logs.bucket */
  /*   prefix  = "test-lb" */
  /*   enabled = true */
  /* } */
  tags = var.tags
}

resource "aws_lb_listener" "http_blue" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags = merge({ "Name" : "${var.prefix}-blue" }, var.tags)
  # BGデプロイで動的にtgを入れ替えるため変更を無視
  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}

resource "aws_lb_listener" "https_blue" {
  load_balancer_arn = aws_lb.app.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_blue.arn
    authenticate_cognito {
      user_pool_arn       = var.user_pool_arn
      user_pool_client_id = var.cognito_client_id
      user_pool_domain    = var.cognito_domain
    }
  }
}

resource "aws_lb_listener_rule" "auth" {
  listener_arn = aws_lb_listener.https_blue.arn
  priority     = 100
  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = var.user_pool_arn
      user_pool_client_id = var.cognito_client_id
      user_pool_domain    = var.cognito_domain
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_blue.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_target_group" "app_blue" {
  name                 = "${var.prefix}-tg-blue"
  deregistration_delay = 60
  port                 = 8080
  protocol             = "HTTPS"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  health_check {
    healthy_threshold   = 2
    interval            = 30
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  tags = var.tags
}

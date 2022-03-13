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
# NOTE: HTTPSは時間が余ったらする
resource "aws_lb_listener" "http_blue" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_blue.arn
  }
  tags = merge({ "Name" : "${var.prefix}-blue" }, var.tags)
  # BGデプロイで動的にtgを入れ替えるため変更を無視
  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}
resource "aws_lb_listener" "http_green" {
  load_balancer_arn = aws_lb.app.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_green.arn
  }
  tags = merge({ "Name" : "${var.prefix}-blue" }, var.tags)
  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}

resource "aws_lb_target_group" "app_blue" {
  name                 = "${var.prefix}-tg-blue"
  deregistration_delay = 60
  port                 = 8080
  protocol             = "HTTP"
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

resource "aws_lb_target_group" "app_green" {
  name                 = "${var.prefix}-tg-green"
  deregistration_delay = 60
  port                 = 8080
  protocol             = "HTTP"
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

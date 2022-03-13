# ECSタスク実行ロール
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.prefix}-ecs-task-execution"
  assume_role_policy = file("${path.module}/ecs_assume_policy.json")
  tags               = var.tags
}

# TODO: タスク実行ロールの権限を最小にする
data "aws_iam_policy" "ecs_task" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# CloudWatchLogの権限もタスク実行ロールに与える
data "aws_iam_policy" "cloudwatch" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# パラメーターストアのアクセス権限をタスク実行ロールに付与
resource "aws_iam_policy" "ssm" {
  name   = "${var.prefix}-ssm-getparameters"
  policy = file("${path.module}/ecs_ssm_get_parameters_policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = data.aws_iam_policy.ecs_task.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_ssm" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ssm.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_logs" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = data.aws_iam_policy.cloudwatch.arn
}
# タスクロールを作成する(ECS Exec実行等)
resource "aws_iam_role" "ecs_task" {
  name               = "${var.prefix}-ecs-task"
  assume_role_policy = file("${path.module}/ecs_assume_policy.json")
  tags               = var.tags
}

resource "aws_iam_role_policy" "ecs_exec" {
  name = "${var.prefix}-ecs-task"
  role = aws_iam_role.ecs_task.id

  policy = file("${path.module}/ecs_task_role_policy.json")
}

vpc_cidr = "10.10.0.0/16"
public_subnets = [
  {
    "name" : "cognito-alb-public-a",
    "az" : "ap-northeast-1a",
    "cidr" : "10.10.0.0/24"
  },
  {
    "name" : "cognito-alb-public-c",
    "az" : "ap-northeast-1c",
    "cidr" : "10.10.1.0/24"
  },
]

private_subnets = [
  {
    "name" : "cognito-alb-private-a",
    "az" : "ap-northeast-1a",
    "cidr" : "10.10.10.0/24"
  },
  {
    "name" : "cognito-alb-private-c",
    "az" : "ap-northeast-1c",
    "cidr" : "10.10.11.0/24"
  },
]

vpc_endpoint = {
  "interface" : [
    # ECSからECRにイメージをpullするため
    "com.amazonaws.ap-northeast-1.ecr.dkr",
    "com.amazonaws.ap-northeast-1.ecr.api",
    "com.amazonaws.ap-northeast-1.logs",
    # ECS Exec用のVPCエンドポイント
    "com.amazonaws.ap-northeast-1.ssmmessages",
    "com.amazonaws.ap-northeast-1.ecs-agent",
    "com.amazonaws.ap-northeast-1.ecs-telemetry",
    "com.amazonaws.ap-northeast-1.ecs",
    # ECSからパラメーターストアを見るため
    "com.amazonaws.ap-northeast-1.ssm",
    "com.amazonaws.ap-northeast-1.ec2messages",
    "com.amazonaws.ap-northeast-1.ec2"
  ],
  "gateway" : [
    "com.amazonaws.ap-northeast-1.s3"
  ]
}
root_domain = "pr-bun.com"
# TODO: hosto_zone_id = "hoge" が必要(globalでroute53のホストゾーンを作成してここにidを用意しておく)

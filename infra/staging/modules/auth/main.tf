resource "aws_cognito_user_pool" "main" {
  name = "${var.prefix}-auth"

  mfa_configuration = "ON"
  software_token_mfa_configuration {
    enabled = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
    invite_message_template {
      email_message = "{username}さん、あなたの初期パスワードは {####} です。初回ログインの後パスワード変更が必要です。"
      email_subject = "${var.tags.Project}(ステージング環境)への招待"
      sms_message   = "{username}さん、あなたの初期パスワードは {####} です。初回ログインの後パスワード変更が必要です。"
    }
  }

  # ユーザー名の他にemailでの認証を許可
  alias_attributes = ["email"]

  tags = var.tags
}

# TODO: NSレコードの移管が終了してから再度試す
resource "aws_cognito_user_pool_domain" "main" {
  domain          = "auth.${var.root_domain}"
  certificate_arn = var.acm_sub_arn
  user_pool_id    = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_pool_client" "main" {
  name            = "${var.prefix}-client"
  user_pool_id    = aws_cognito_user_pool.main.id
  generate_secret = true
  # CallBackUrlにALBのドメイン + oauth2/idpresponseの付与が必要
  callback_urls = [
    "https://${var.root_domain}/oauth2/idpresponse"
  ]
  allowed_oauth_flows = ["code"]
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
  ]
  supported_identity_providers = [
    "COGNITO"
  ]
  allowed_oauth_scopes                 = ["openid"]
  allowed_oauth_flows_user_pool_client = true
}

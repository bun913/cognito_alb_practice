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
    }
  }

  # ユーザー名の他にemailでの認証を許可
  alias_attributes = ["email"]

  tags = var.tags
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.prefix
  user_pool_id = aws_cognito_user_pool.main.id
}

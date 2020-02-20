###################
#                 #
#   dev secrets   #
#                 #
###################
resource "aws_kms_key" "voice-dev" {
  description = "KMS key used for encrypting secrets in dev environment"
  tags        = var.common-tags
}

resource "aws_ssm_parameter" "db-root-pw-dev" {
  name        = "/voice/dev/mysql-root-pw"
  description = "Password for the root user in dev environment"
  type        = "SecureString"
  value       = "this-is-not-the-current-pw"
  key_id      = aws_kms_key.voice-dev.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "db-user-pw-dev" {
  name        = "/voice/dev/mysql-user-pw"
  description = "Password for the user in dev environment"
  type        = "SecureString"
  value       = "this-is-not-the-current-pw"
  key_id      = aws_kms_key.voice-dev.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "app-secret-dev" {
  name        = "/voice/dev/app-secret"
  description = "Voice application secret"
  type        = "SecureString"
  value       = "this-is-not-the-secret"
  key_id      = aws_kms_key.voice-dev.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "basket-api-key-dev" {
  name        = "/voice/dev/basket-api-key"
  description = "API key for the Basket service"
  type        = "SecureString"
  value       = "this-is-not-the-current-basket-api-key"
  key_id      = aws_kms_key.voice-dev.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-domain-dev" {
  name        = "/voice/dev/auth0-domain"
  description = "Auth0 hostname"
  type        = "SecureString"
  value       = "auth.mozilla.auth0.com"
  key_id      = aws_kms_key.voice-dev.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-client-id-dev" {
  name        = "/voice/dev/auth0-client-id"
  description = "Auth0 client ID"
  type        = "SecureString"
  value       = "12345"
  key_id      = aws_kms_key.voice-dev.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-client-secret-dev" {
  name        = "/voice/dev/auth0-client-secret"
  description = "Auth0 client secret"
  type        = "SecureString"
  value       = "1234567890"
  key_id      = aws_kms_key.voice-dev.id

  tags = var.common-tags
}

###################
#                 #
# sandbox secrets #
#                 #
###################
resource "aws_kms_key" "voice-sandbox" {
  description = "KMS key used for encrypting secrets in sandbox environment"
  tags        = var.common-tags
}

resource "aws_ssm_parameter" "db-root-pw-sandbox" {
  name        = "/voice/sandbox/mysql-root-pw"
  description = "Password for the root user in sandbox environment"
  type        = "SecureString"
  value       = "this-is-not-the-current-pw"
  key_id      = aws_kms_key.voice-sandbox.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "db-user-pw-sandbox" {
  name        = "/voice/sandbox/mysql-user-pw"
  description = "Password for the user in sandbox environment"
  type        = "SecureString"
  value       = "this-is-not-the-current-pw"
  key_id      = aws_kms_key.voice-sandbox.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "app-secret-sandbox" {
  name        = "/voice/sandbox/app-secret"
  description = "Voice application secret"
  type        = "SecureString"
  value       = "this-is-not-the-secret"
  key_id      = aws_kms_key.voice-sandbox.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "basket-api-key-sandbox" {
  name        = "/voice/sandbox/basket-api-key"
  description = "API key for the Basket service"
  type        = "SecureString"
  value       = "this-is-not-the-current-basket-api-key"
  key_id      = aws_kms_key.voice-sandbox.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-domain-sandbox" {
  name        = "/voice/sandbox/auth0-domain"
  description = "Auth0 hostname"
  type        = "SecureString"
  value       = "auth.mozilla.auth0.com"
  key_id      = aws_kms_key.voice-sandbox.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-client-id-sandbox" {
  name        = "/voice/sandbox/auth0-client-id"
  description = "Auth0 client ID"
  type        = "SecureString"
  value       = "12345"
  key_id      = aws_kms_key.voice-sandbox.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-client-secret-sandbox" {
  name        = "/voice/sandbox/auth0-client-secret"
  description = "Auth0 client secret"
  type        = "SecureString"
  value       = "1234567890"
  key_id      = aws_kms_key.voice-sandbox.id

  tags = var.common-tags
}

###################
#                 #
#  stage secrets  #
#                 #
###################
resource "aws_kms_key" "voice-stage" {
  description = "KMS key used for encrypting secrets in stage environment"
  tags        = var.common-tags
}

resource "aws_ssm_parameter" "db-root-pw-stage" {
  name        = "/voice/stage/mysql-root-pw"
  description = "Password for the root user in stage environment"
  type        = "SecureString"
  value       = "this-is-not-the-current-pw"
  key_id      = aws_kms_key.voice-stage.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "db-user-pw-stage" {
  name        = "/voice/stage/mysql-user-pw"
  description = "Password for the user in stage environment"
  type        = "SecureString"
  value       = "this-is-not-the-current-pw"
  key_id      = aws_kms_key.voice-stage.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "app-secret-stage" {
  name        = "/voice/stage/app-secret"
  description = "Voice application secret"
  type        = "SecureString"
  value       = "this-is-not-the-secret"
  key_id      = aws_kms_key.voice-stage.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "basket-api-key-stage" {
  name        = "/voice/stage/basket-api-key"
  description = "API key for the Basket service"
  type        = "SecureString"
  value       = "this-is-not-the-current-basket-api-key"
  key_id      = aws_kms_key.voice-stage.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-domain-stage" {
  name        = "/voice/stage/auth0-domain"
  description = "Auth0 hostname"
  type        = "SecureString"
  value       = "auth.mozilla.auth0.com"
  key_id      = aws_kms_key.voice-stage.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-client-id-stage" {
  name        = "/voice/stage/auth0-client-id"
  description = "Auth0 client ID"
  type        = "SecureString"
  value       = "12345"
  key_id      = aws_kms_key.voice-stage.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-client-secret-stage" {
  name        = "/voice/stage/auth0-client-secret"
  description = "Auth0 client secret"
  type        = "SecureString"
  value       = "1234567890"
  key_id      = aws_kms_key.voice-stage.id

  tags = var.common-tags
}

###################
#                 #
#   prod secrets  #
#                 #
###################
resource "aws_kms_key" "voice-prod" {
  description = "KMS key used for encrypting secrets in prod environment"
  tags        = var.common-tags
}

resource "aws_ssm_parameter" "db-root-pw-prod" {
  name        = "/voice/prod/mysql-root-pw"
  description = "Password for the root user in prod environment"
  type        = "SecureString"
  value       = "this-is-not-the-current-pw"
  key_id      = aws_kms_key.voice-prod.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "db-user-pw-prod" {
  name        = "/voice/prod/mysql-user-pw"
  description = "Password for the user in prod environment"
  type        = "SecureString"
  value       = "this-is-not-the-current-pw"
  key_id      = aws_kms_key.voice-prod.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "app-secret-prod" {
  name        = "/voice/prod/app-secret"
  description = "Voice application secret"
  type        = "SecureString"
  value       = "this-is-not-the-secret"
  key_id      = aws_kms_key.voice-prod.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "basket-api-key-prod" {
  name        = "/voice/prod/basket-api-key"
  description = "API key for the Basket service"
  type        = "SecureString"
  value       = "this-is-not-the-current-basket-api-key"
  key_id      = aws_kms_key.voice-prod.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-domain-prod" {
  name        = "/voice/prod/auth0-domain"
  description = "Auth0 hostname"
  type        = "SecureString"
  value       = "auth.mozilla.auth0.com"
  key_id      = aws_kms_key.voice-prod.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-client-id-prod" {
  name        = "/voice/prod/auth0-client-id"
  description = "Auth0 client ID"
  type        = "SecureString"
  value       = "12345"
  key_id      = aws_kms_key.voice-prod.id

  tags = var.common-tags
}

resource "aws_ssm_parameter" "auth0-client-secret-prod" {
  name        = "/voice/prod/auth0-client-secret"
  description = "Auth0 client secret"
  type        = "SecureString"
  value       = "1234567890"
  key_id      = aws_kms_key.voice-prod.id

  tags = var.common-tags
}


resource "aws_cognito_user_pool" "user_pool" {
  name = "user-pool"
  username_attributes = [
    "email"
  ]
  auto_verified_attributes = [
    "email"
  ]
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name = "user-pool-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false
  supported_identity_providers = [
    "COGNITO"
  ]
  prevent_user_existence_errors = "ENABLED"
}

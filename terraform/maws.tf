module "devs_role" {
  source       = "github.com/mozilla-it/terraform-modules//aws/maws-roles?ref=master"
  role_name    = "maws-developers"
  role_mapping = [ "voice-dev" ]
  policy_arn   = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

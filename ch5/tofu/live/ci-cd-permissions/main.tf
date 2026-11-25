provider "aws" {
  region = "ap-southeast-2"
  profile = "dat-405398623290"
}

module "oidc_provider" {
  source  = "brikis98/devops/book//modules/github-aws-oidc"
  version = "1.0.0"

  provider_url = "https://token.actions.githubusercontent.com" 

}

module "iam_roles" {
  source  = "brikis98/devops/book//modules/gh-actions-iam-roles"
  version = "1.0.0"

  name              = "lambda-sample"                           
  oidc_provider_arn = module.oidc_provider.oidc_provider_arn    

  enable_iam_role_for_testing = true                            

  # TODO: fill in your own repo name here!
  github_repo      = "6151020049-cpu@283092221/fundamentals-of-devops@1431913289" 
  lambda_base_name = "lambda-sample"                            

  enable_iam_role_for_plan  = true                                
  enable_iam_role_for_apply = true                                

  # TODO: fill in your own bucket and table name here!
  tofu_state_bucket         = "bucket1-405398623290-ap-southeast-2-an" 
  tofu_state_dynamodb_table = "fundamentals-of-devops-tofu-state" 
}

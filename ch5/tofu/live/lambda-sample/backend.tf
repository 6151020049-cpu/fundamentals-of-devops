terraform {
  backend "s3" {
    # TODO: fill in your own bucket name here!
    bucket         = "bucket1-405398623290-ap-southeast-2-an"             
    key            = "ch5/tofu/live/lambda-sample/terraform.tfstate" 
    region         = "ap-southeast-2"                                     
    encrypt        = true                                            
    # TODO: fill in your own DynamoDB table name here!
    dynamodb_table = "fundamentals-of-devops-tofu-state"             
  }
}

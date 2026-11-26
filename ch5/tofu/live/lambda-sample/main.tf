provider "aws" {
  region = "ap-southeast-2"
}

module "function" {
  source  = "git::https://github.com/6151020049-cpu/devops-book.git//ch3/tofu/modules/lambda?ref=main"


  name = var.name

  src_dir = "${path.module}/src"
  runtime = "nodejs20.x"
  handler = "index.handler"

  memory_size = 128
  timeout     = 5

  environment_variables = {
    NODE_ENV = "production"
  }

  create_url = true
}

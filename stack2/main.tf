provider "aws" {
  region = var.region
}

module "bedrock_kb" {
  source = "../modules/bedrock_kb" 

  knowledge_base_name        = "my-bedrock-kb"
  knowledge_base_description = "Knowledge base connected to Aurora Serverless database"

  aurora_arn        = var.aurora_arn
  aurora_db_name    = var.aurora_db_name
  aurora_endpoint   = var.aurora_endpoint
  aurora_table_name = var.aurora_table_name
  aurora_primary_key_field = var.aurora_primary_key_field
  aurora_metadata_field = var.aurora_metadata_field
  aurora_text_field = var.aurora_text_field
  aurora_verctor_field = var.aurora_vector_field
  aurora_username   = var.aurora_username
  aurora_secret_arn = var.aurora_secret_arn
  s3_bucket_arn = var.s3_bucket_arn
}
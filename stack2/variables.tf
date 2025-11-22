variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aurora_arn" {
  description = "ARN of the Aurora Serverless cluster"
  type        = string
}

variable "aurora_db_name" {
  description = "Name of the Aurora database"
  type        = string
  default     = "myapp"
}

variable "aurora_endpoint" {
  description = "Endpoint of the Aurora Serverless cluster"
  type        = string
}

variable "aurora_table_name" {
  description = "Name of the table for vector storage"
  type        = string
  default     = "bedrock_integration.bedrock_kb"
}

variable "aurora_primary_key_field" {
  description = "Primary key field name"
  type        = string
  default     = "id"
}

variable "aurora_metadata_field" {
  description = "Metadata field name"
  type        = string
  default     = "metadata"
}

variable "aurora_text_field" {
  description = "Text field name"
  type        = string
  default     = "chunks"
}

variable "aurora_vector_field" {
  description = "Vector field name"
  type        = string
  default     = "embedding"
}

variable "aurora_username" {
  description = "Username for the Aurora database"
  type        = string
  default     = "dbadmin"
}

variable "aurora_secret_arn" {
  description = "ARN of the secret containing Aurora credentials"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket for documents"
  type        = string
}

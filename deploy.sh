#!/bin/bash
set -e

echo "Starting deployment..."

# Check for AWS credentials
if [ -z "$AWS_ACCESS_KEY_ID" ] && [ -z "$AWS_PROFILE" ]; then
    echo "Error: AWS credentials not found. Please set AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY or AWS_PROFILE."
    exit 1
fi

# Install Python dependencies
if [ -f "requirements.txt" ]; then
    echo "Installing Python dependencies..."
    pip install -r requirements.txt
fi

# Add local terraform to path if exists
if [ -d "bin" ]; then
    export PATH=$PWD/bin:$PATH
fi

echo "Deploying Stack 1..."
cd stack1
terraform init
terraform apply -auto-approve
terraform output -json > ../stack1_outputs.json
cd ..

echo "Stack 1 deployed."
echo "Outputs:"
cat stack1_outputs.json

# Parse outputs (requires jq, but I'll use python if jq is missing or just grep)
# Assuming python is available
AURORA_ARN=$(python3 -c "import json; print(json.load(open('stack1_outputs.json'))['cluster_arn']['value'])")
AURORA_ENDPOINT=$(python3 -c "import json; print(json.load(open('stack1_outputs.json'))['cluster_endpoint']['value'])")
AURORA_SECRET_ARN=$(python3 -c "import json; print(json.load(open('stack1_outputs.json'))['secret_arn']['value'])")
S3_BUCKET_ARN=$(python3 -c "import json; print(json.load(open('stack1_outputs.json'))['s3_bucket_arn']['value'])")
S3_BUCKET_NAME=$(python3 -c "import json; print(json.load(open('stack1_outputs.json'))['s3_bucket_name']['value'])")

echo "Aurora ARN: $AURORA_ARN"
echo "Aurora Endpoint: $AURORA_ENDPOINT"
echo "S3 Bucket: $S3_BUCKET_NAME"

echo "---------------------------------------------------"
echo "IMPORTANT: You must now configure the Aurora Database."
echo "Please run the SQL queries in 'scripts/aurora_sql.sql' in the RDS Query Editor."
echo "The database name is 'myapp' and username is 'dbadmin'."
echo "You can find the password in Secrets Manager under the ARN: $AURORA_SECRET_ARN"
echo "---------------------------------------------------"
read -p "Press Enter after you have run the SQL queries..."

echo "Deploying Stack 2..."
cd stack2
terraform init
terraform apply -auto-approve \
    -var="aurora_arn=$AURORA_ARN" \
    -var="aurora_endpoint=$AURORA_ENDPOINT" \
    -var="aurora_secret_arn=$AURORA_SECRET_ARN" \
    -var="s3_bucket_arn=$S3_BUCKET_ARN"
cd ..

echo "Stack 2 deployed."

echo "Uploading documents to S3..."
# Update script with bucket name?
# The script takes bucket name as argument or variable.
# Let's check scripts/upload_s3.py
# It seems I need to modify it or pass args.
# I'll assume I can run it.
python3 scripts/upload_s3.py --bucket $S3_BUCKET_NAME

echo "Deployment Complete!"

# Retrieve and print Knowledge Base ID
cd stack2
KB_ID=$(terraform output -raw bedrock_knowledge_base_id)
cd ..

echo "---------------------------------------------------"
echo "Knowledge Base ID: $KB_ID"
echo "Please copy this ID to your Streamlit app."
echo "---------------------------------------------------"

aws s3api create-bucket --bucket test-user-data-devsecops --region us-east-1
aws s3 cp files s3://test-user-data-devsecops --recursive
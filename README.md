<h1 align="left">
  📦 Documentation
  <p>Action Network Developer Operations and Security Engineer Take Home Assignment</p>
</h1>

### 🔽 Requirements (quick steps to prepare for launching)

1. **Launch script to upload 3 files into s3**
cd s3-files  
chmod +x create-s3-bucket.sh  
./create-s3-bucket.sh  

2. **Create S3-Read-Only IAM role with this name: S3ReadOnlyAcessTestDevops** (MANUAL STEP INSIDE AWS CONSOLE)
- Choose IAM service inside AWS CONSOLE  
- Then, choose Roles (right side)  
- Create Function  
- Choose AWS Service > EC2 > Click Next: Permissions   
- Search for S3ReadOnlyAccess and select AmazonS3ReadOnlyAccess  
- Click Next: Tags, then click Next: Review   
- Insert this name for the role: S3ReadOnlyAcessTestDevops  
- Click Create Role  
- Done.  

3. **Launch script that generates self-signing certificate and uploads to AWS IAM**

./security/user-data-generate-certificate.sh

Obs.: Insert the certificate infos, and in Common Name, just insert a dot (.).  
Wait the script end to copy the Arn parameter below.  
  Example: "Arn": "arn:aws:iam::009009745233:server-certificate/CSC"  
Copy just the value: arn:aws:iam::009009745233:server-certificate/CSC  

4. **CertificateArn parameter**
- Paste this Arn value from step 3 into CertificateArn parameter in the project/web-servers-stack.yml file.  

5. **IAMInstanceProfile**
- Copy the Account ID from your AWS account to IAMInstanceProfile in the project/web-servers-stack.yml file.  

6. Ok, ready to launch.

## Launching the VPC-STACK

1. ``cd project``
2. ``./launch-vpc-stack.sh``
3. ``wait for it to end``

### Launching the WEB-SERVERS-STACK

1. ``./launch-web-servers.sh``
2. ``wait for it to end``
3. ``test by accessing the LoadBalancer on EC2 service. There will be a DNS address``
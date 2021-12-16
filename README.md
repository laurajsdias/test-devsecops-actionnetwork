<h1 align="left">
  📦 Documentation
  <p>Action Network Developer Operations and Security Engineer Take Home Assignment</p>
</h1>

### 🔽 Requirements (quick steps to prepare for launching)

1. **AWS CLI**

2. **Launch script to upload 3 files into s3**  
- cd s3-files    
- chmod +x create-s3-bucket.sh      
- ./create-s3-bucket.sh    

3. **Create S3-Read-Only IAM role with this name: S3ReadOnlyAcessTestDevops (MANUAL STEP INSIDE AWS CONSOLE)**  
- Choose IAM service inside AWS CONSOLE  
- Then, choose Roles (right side)  
- Create Function  
- Choose AWS Service > EC2 > Click Next: Permissions   
- Search for S3ReadOnlyAccess and select AmazonS3ReadOnlyAccess  
- Click Next: Tags, then click Next: Review   
- Insert this name for the role: S3ReadOnlyAcessTestDevops  
- Click Create Role  
- Done.  

4. **Launch script that generates self-signing certificate and uploads to AWS IAM**

- ./security/user-data-generate-certificate.sh  

- Obs.: Insert the certificate infos, and in Common Name, just insert a dot (.).  
Wait the script end to copy the Arn parameter below.  
  Example: "Arn": "arn:aws:iam::009009745233:server-certificate/CSC"  
*Copy just the value: arn:aws:iam::009009745233:server-certificate/CSC*

5. **CertificateArn parameter**
- Paste this Arn value from step 3 into CertificateArn parameter in the project/web-servers-stack.yml file.  

6. **IAMInstanceProfile**
- Copy the Account ID from your AWS account to IAMInstanceProfile in the project/web-servers-stack.yml file.  

7. **Ok, ready to launch!**

## Launching the VPC-STACK

1. ``cd project``
2. ``./launch-vpc-stack.sh``
3. ``wait for it to end``

## Launching the WEB-SERVERS-STACK

1. ``./launch-web-servers.sh``
2. ``wait for it to end``
3. ``test by accessing the LoadBalancer on EC2 service. There will be a DNS address``

### 🔽 Explanations   

Technologies used: Linux, Cloudformation, S3, some shell script, and a basic IAM setup on AWS.
Motive: to try to use most of your main stack.   

The first thing I noticed is that I would have to automate the creation of VPC and subnets. There are templates that AWS itself provides to launch the type of infra the assignment was asking, but it would result on some manual configuration (like choosing default VPC, subnets, etc on console) and I've tried the most to avoid that.   

In order to create the VPC, I went for a pretty straightforward approach. It is basically one main VPC, 4 subnets and all the resources needed in order for it to work (like internet gateway, routing tables, choosing of availability zones). This VPC is created in the 10.0.0.0/16 network range and it is by default created on us-east-1 region (N. Virginia).    

Cloudformation was the main tool in this project. So I've created a yaml file (vpc-stack.yml) with all the parameter needed to launch this background infrastructure. And, to launch this stack without using the AWS console, all you have to do is to launch a simple script.   

Using Cloudformation as well, I've created the yaml (web-server-stack.yml) for provisioning the web servers asked on the assignment.

The first thing was to assign the VPC created before for this infra based on the parameter **InfrastructureStack**.

Then, it was defined a **LaunchTemplate** so all EC2 instances created were provisioned the same way. 
This was an important step, because of the UserData script going on. This userdata script had two main goals: 
- to install yum-cron in all instances. Goal: schedule daily security and packages updates in all servers. 
- enable a web server (apache) and place the necessary website files inside /var/www/html directory.  

Next steps was to define an **AutoScalingGroup** and a **SecurityGroup**. The AutoScalingGroup defines that this infra will have 3 servers by default, 2 servers at minimum and 5 total and that the subnets created on the vpc-stack will be assigned to this group of instances. The SecurityGroup basically is defining that this infra will accept inbound connections from everyone on ports 22(ssh), 80(http) e 443(https).    

The final part is all the resources needed for a load balancing to happen inside AWS. So it was created the **LoadBalancer** itself associated with our SecurityGroup and the created subnets. Then we enable a **TargetGroup** to listen for connections on port 80 and make healthy checks.  

Furthermore, there are the **Listeners** configuration. There are two: one for HTTP, other for HTTPS. Basically the HTTPListener forward all requests to port 443, and then the HTTPSListener does its job using a self signed certificate that is generated on step 4 of the Requirements step above.

DELIVERED:
- Code to provision almost automatically 3 web servers on AWS, and auto scaling group working behind a load balancer.  
- A basic HTML page file uploaded to S3 that also gives names to the instances to test the load balancer working.  
- Encrypted access to the website via the load balancer (using self-signed certificate)  
- A UserData script encoded on the LaunchTemplate that installs yum-cron and uses a customized yum-cron.conf file (uploaded to S3) that schedules security and package updates every 24h.  
- Scripts to create bucket, upload necessary files to S3, generate certificate and do the lauching of the Cloudformation stacks.  

NOT DELIVERED:  
- Automatic scale and descale based on simulated load. But I've tested it manually installing the stress package (install-stress-util-ec2.sh) in all servers and putting manually a threshold for CPU usage and it worked.  
- Method to automatically update or replace servers upon updates and test them to check if everything is ok before going in 'production'.   



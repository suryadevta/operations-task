# Xeneta Operations Task

## Firts case developing a deployable development environment based on a simple application.
1) The solution is deployed using the CI/CD pipeline in Guthub using terraform as IaaC.

2) The AWS infrastructure has been set up by using Elastic Container Service Fargate, RDS
(postgres) and application load balancer services. This architecture utilizes  the high availability and scalability of the application when it is ready for production deployment.


3) Terrafrom  modules and workspaces are ued to make the code reusabiluty .S3 backend is used to store the sate files.It help to work on terraform as a team.

4) AWS SSM parameter store has been used to store the database credentials. Terraform generates a random password for the RDS admin user and stores it as an SSM paramater. Fargate uses this parameter and sets it as an environment variable for the container run time environment.

5) The SQL dump file is imported to the DB just before starting the app via entrypoint.sh script. This is used only for AWS ECS environment.

6) The CI/CD pipeline is built using GitHub Actions.The pipeline configuration files are placed under the .github directory.

##  TO Replicate the solution

create the s3 bucket to store the backend and give it the name .

Put the name of the S3 bucket in backend section of main.tf file

The perform the below steps to apply the terraform workflow

cd terraform
terraform init
terraform workspace new dev
terraform workspace select dev
terraform apply

### following GitHub Actions repository secrets under repository settings is needed to be  setted

| Name of the secret | Description |
| ------------- | ------------- |
| `AWS_ACCOUNT_ID`  | The AWS Account ID where the infrastructure is deployed |
| `AWS_ACCESS_KEY_ID` | AWS Access Key ID of an IAM user with ECR push permissions  |
| `AWS_SECRET_ACCESS_KEY` | Secret access key of the IAM user |

Once a commit is pushed to the master branch, it will trigger the GitHub Actions CICD pipeline automatically. This will build the docker image, push to the AWS ECR and deploy the new image version to the AWS ECS.

###  Case: Data ingestion pipeline

![Pipeline Architecture](https://github.com/suryadevta/operations-task/blob/master/DataIngestionPipeline.png?raw=true)

* How would you design the system?

  First, we need to identify whether the data comes as a stream, batch or event-driven. In this scenario there is no scheduled frequency for the incoming data. Whenever data comes into the data source the synchronization process should be triggered. So we can decide to use an event driven approach.

We can assume AWS s3 as the data source. Once the data batch is uploaded to S3, an event will be triggered and a message will be pushed to the AWS SQS. The SQS queue is integrated with a lambda function which contains the code to trigger the AWS data pipeline activation. Once the pipeline is activated it will create the EMR cluster and load the S3 files to the AWS RDS database.

* How would you set up monitoring to identify bottlenecks as the load grows?

AWS cloudwatch service can be used to set up monitoring of the data pipeline. Mainly we should monitor the RDS database resource usage using Cloudwatch graphs and we can store the AWS data pipeline logs in Cloudwatch logs. AWS Cloudwatch alarms can be set up to identify the incidents and minimize the downtimes.

* How can those bottlenecks be addressed in the future?

AWS RDS throughput limit can be a bottleneck when the load grows. AWS DynamoDB can be used as a solution for this in the future.

### Additional questions

1. The batch updates have started to become very large, but the requirements for their processing time are strict.

* S3 upload speed limit can be a bottleneck for the user. S3 multipart file upload can be used as a solution for this limitation.

* AWS data pipeline EMR instances can take time to autoscale and it can be a bottleneck. EMR Serverless automatically provisions and scales the compute and memory resources required by the applications

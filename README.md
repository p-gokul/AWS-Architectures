# 📊 AWS Architectures Overview

This project includes three major components deployed on AWS with CI/CD automation and serverless cron job scheduling:

- Frontend Application
- Backend Service
- Scheduled Cron Job System

---

## 🖼️ Architecture Diagrams

### Frontend Architecture

![Frontend Architecture](/diagrams/aws_frontend.png)

### Backend Architecture

![Backend Architecture](/diagrams/aws_backend.png)

### Cron Job Architecture

![Cron Job Architecture](/diagrams/cron_job.png)

---

# 🌐 Frontend

This frontend application is deployed on AWS and follows a CI/CD pipeline using GitHub and AWS services.

## 🔧 Components

- **User**: Accesses the frontend via a browser.
- **AWS WAF**: Protects CloudFront from malicious traffic.
- **CloudFront**: Serves static assets with low latency.
- **S3**: Stores frontend assets (HTML, CSS, JS).
- **Certificate Manager**: Manages SSL certificates for HTTPS.
- **CodeBuild**: Builds and deploys the frontend via GitHub webhooks.
- **Systems Manager**: Manages environment variables securely.
- **GitHub**: Triggers builds via webhooks on push events.

## 🌐 Domain

- Uses a custom domain linked via AWS Certificate Manager.

## 🔄 CI/CD Flow

1. Developer pushes code to GitHub.
2. Webhook triggers AWS CodeBuild.
3. CodeBuild pulls secrets from Systems Manager.
4. CodeBuild deploys built assets to S3.
5. CloudFront serves updated content with caching.

---

# ⚙️ Backend

This backend service is deployed using AWS ECS Fargate and utilizes a CI/CD pipeline integrated with GitHub.

## 🔧 Components

- **Developer**: Pushes code to GitHub.
- **GitHub**: Triggers build via webhook.
- **CodeBuild**: Builds Docker image and pushes to ECR.
- **ECR**: Stores container images.
- **ECS + Fargate**: Runs backend containers serverlessly.
- **ALB (Application Load Balancer)**: Routes traffic to ECS services.
- **Certificate Manager**: Provides HTTPS support.
- **Systems Manager**: Stores environment variables securely.

## 🌐 Domain

- Custom domain integrated through Certificate Manager and ALB.

## 🔄 CI/CD Flow

1. Developer commits code to GitHub.
2. Webhook triggers AWS CodeBuild.
3. CodeBuild builds Docker image and pushes to ECR.
4. ECS (via Fargate) pulls latest image from ECR.
5. ALB routes incoming HTTPS requests to ECS service.

---

# ⏰ Cron Job - AWS Scheduled Email Notification System

This project implements a serverless cron job architecture using **AWS EventBridge**, **Lambda**, **DynamoDB**, and **SES**. The system periodically pulls data from DynamoDB and sends automated emails through AWS SES.

## 🔧 Components

- **EventBridge**  
  Triggers the cron job at scheduled intervals (e.g., every day at 9 AM UTC).

- **AWS Lambda**  
  Executes the business logic:

  - Fetches data from DynamoDB.
  - Formats email content.
  - Sends emails using SES.

- **DynamoDB**  
  Stores structured data used in the Lambda function (e.g., recipient list, email content).

- **SES (Simple Email Service)**  
  Sends out transactional or notification emails.

- **IAM**  
  Provides the Lambda function with permissions to access DynamoDB and SES via IAM Roles.

## 🔁 Flow Overview

1. **EventBridge** triggers the **Lambda function** based on the scheduled cron expression.
2. **Lambda** assumes a role defined in **IAM** with permissions for DynamoDB and SES.
3. **Lambda** reads required data from **DynamoDB**.
4. **Lambda** invokes **SES** to send the email(s).
5. **SES** sends the email(s) to the intended recipients.

## 🛠️ Setup Notes

- **EventBridge Rule**:  
  Set up a cron schedule using the AWS Console or CloudFormation like:
  ```cron
  cron(0 9 * * ? *)  # Every day at 9 AM UTC
  ```

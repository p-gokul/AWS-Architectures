# ⏰ Cron Job - AWS Scheduled Email Notification System

This project implements a serverless cron job architecture using **AWS EventBridge**, **Lambda**, **DynamoDB**, and **SES**. The system periodically pulls data from DynamoDB and sends automated emails through AWS SES.

---

## 📊 Architecture Diagram

![Cron Job Architecture](/diagrams/cron_job.png)

---

## 🧩 Components

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

---

## 🔁 Flow Overview

1. **EventBridge** triggers the **Lambda function** based on the scheduled cron expression.
2. **Lambda** assumes a role defined in **IAM** with permissions for DynamoDB and SES.
3. **Lambda** reads required data from **DynamoDB**.
4. **Lambda** invokes **SES** to send the email(s).
5. **SES** sends the email(s) to the intended recipients.

---

## 🛠️ Setup Notes

- **EventBridge Rule**:  
  Set up a cron schedule using the AWS Console or CloudFormation like:
  ```cron
  cron(0 9 * * ? *)  # Every day at 9 AM UTC
  ```

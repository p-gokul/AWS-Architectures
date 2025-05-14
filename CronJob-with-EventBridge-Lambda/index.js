import { SNSClient, PublishCommand } from "@aws-sdk/client-sns";
import { DynamoDBClient, GetItemCommand } from "@aws-sdk/client-dynamodb";
import { unmarshall } from "@aws-sdk/util-dynamodb";

// AWS region
const region = "your_region"; // eg: ap-northeast-1

const DDB_TABLE = "CronJob"; // DynamoDB Table Name
const MESSAGE_KEY = "cron-message"; // ID in above table - primary key
const TOPIC_ARN = "sns_topic_arn"; // ARN of SNS Topic

// Clients
const snsClient = new SNSClient({ region });
const dbClient = new DynamoDBClient({ region });

export const handler = async () => {
  try {
    // 1. Get message from DynamoDB
    const result = await dbClient.send(
      new GetItemCommand({
        TableName: DDB_TABLE,
        Key: {
          id: { S: MESSAGE_KEY },
        },
      })
    );

    if (!result.Item) throw new Error("No message found in DB");

    const item = unmarshall(result.Item);
    let message = item.message || "Default message";

    // 2. Make message dynamic (insert current time)
    const now = new Date().toLocaleString("en-JP", { timeZone: "Asia/Tokyo" });
    message = message.replace("{time}", now);

    // 3. Send via SNS
    const data = await snsClient.send(
      new PublishCommand({
        Message: message,
        TopicArn: TOPIC_ARN,
      })
    );

    console.log("✅ Message sent:", data.MessageId);
    return { statusCode: 200, body: "Success" };
  } catch (err) {
    console.error("❌ Error:", err);
    return { statusCode: 500, body: err.message };
  }
};

handler();

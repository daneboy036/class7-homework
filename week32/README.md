---
tags:
  - BMC
  - AWS
  - homework
name: Homework Week 32
---

# Maarek Section Proof

## Section 17 Quiz

![Section 17 Quiz](./Section%2017%20Quiz.png)

## Section 18 Quiz

![Section 18 Quiz](./Section%2018%20Quiz.png)

## Section 19 Quiz

![Section 19 Quiz](./Section%2019%20Quiz.png)

## Section 20 Quiz

![Section 20 Quiz](./Section%2020%20Quiz.png)

# Lambda Practice

## Lambda Function

```python
import json
import boto3
import os

sns = boto3.client('sns')

topic_arn = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
	try:
		response = sns.publish(TopicArn=topic_arn, Message='(Change 3) Week 32 Homework Class Lambda Message', Subject='(Change 3) BMC Class 7: Week 32 Lambda')
		return {
		'statusCode': 200,
		'body': json.dumps('Check your email (Change 3)!')
		}
	except Exception as e:
		print(e)
		return {
		'statusCode': 500,
		'body': json.dumps('Could not publish to topic')
		}
```

## Lambda Permissions

Allow Lambda to do `sns:` on your topic

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": "sns:*",
      "Resource": "<topic arn>"
    }
  ]
}
```

**_Role Permissions_**
![Role Permissions](./Lambda%20Permissions.png)

## Verifications

**_Invocations_**
![Invocations](./Invocations.png)
![Original](./Original%20Execution.png)
![Change 1](./Change%201%20Execution.png)
![Change 2](./Change%202%20Execution.png)
![Change 3](./Change%203%20Execution.png)

**_Email Verification_**
![Emails](./Email%20Receipt%20Verification.png)

**_SNS Topic_**
![SNS Topic](./SNS%20Topic.png)

**_Function URL_**
![Function URL](./Function%20Url.png)

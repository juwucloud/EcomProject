import json
import boto3
import os
from datetime import datetime
from decimal import Decimal
import uuid

dynamodb = boto3.resource('dynamodb')
sqs = boto3.client('sqs')

table = dynamodb.Table(os.environ['ORDERS_TABLE'])
queue_url = os.environ['ORDER_QUEUE_URL']

def lambda_handler(event, context):
    body = json.loads(event['body'], parse_float=Decimal)

    order_id = str(uuid.uuid4())
    timestamp = datetime.utcnow().isoformat()

    order = {
        'orderId': order_id,
        'customerId': body['customerId'],
        'items': body['items'],
        'totalAmount': body['totalAmount'],
        'status': 'PENDING',
        'createdAt': timestamp
    }

    table.put_item(Item=order)

    sqs.send_message(
        QueueUrl=queue_url,
        MessageBody=json.dumps(order, default=str)
    )

    return {
        'statusCode': 200,
        'body': json.dumps({'orderId': order_id, 'status': 'PENDING'})
    }
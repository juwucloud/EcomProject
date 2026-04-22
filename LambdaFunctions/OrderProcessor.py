import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
sqs = boto3.client('sqs')

table = dynamodb.Table(os.environ['ORDERS_TABLE'])
payment_queue_url = os.environ['PAYMENT_QUEUE_URL']
inventory_queue_url = os.environ['INVENTORY_QUEUE_URL']

def lambda_handler(event, context):
    for record in event['Records']:
        order = json.loads(record['body'])
        order_id = order['orderId']

        table.update_item(
            Key={'order_Id': order_id},
            UpdateExpression='SET #status = :status',
            ExpressionAttributeNames={'#status': 'status'},
            ExpressionAttributeValues={':status': 'PROCESSING'}
        )

        sqs.send_message(
            QueueUrl=payment_queue_url,
            MessageBody=json.dumps(order)
        )

        sqs.send_message(
            QueueUrl=inventory_queue_url,
            MessageBody=json.dumps(order)
        )

    return {'statusCode': 200}
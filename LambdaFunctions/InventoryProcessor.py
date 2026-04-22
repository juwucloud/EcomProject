import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
sqs = boto3.client('sqs')

table = dynamodb.Table(os.environ['ORDERS_TABLE'])
notification_queue_url = os.environ['NOTIFICATION_QUEUE_URL']

def lambda_handler(event, context):
    for record in event['Records']:
        order = json.loads(record['body'])
        order_id = order['order_Id']

        # Simuliere Inventory-Check
        inventory_available = True  # In Realität: Inventory-DB-Check

        table.update_item(
            Key={'order_Id': order_id},
            UpdateExpression='SET inventoryStatus = :status',
            ExpressionAttributeValues={':status': 'RESERVED' if inventory_available else 'OUT_OF_STOCK'}
        )

        if inventory_available:
            sqs.send_message(
                QueueUrl=notification_queue_url,
                MessageBody=json.dumps({
                    'order_Id': order_id,
                    'type': 'INVENTORY_RESERVED',
                    'customerId': order['customerId']
                })
            )

    return {'statusCode': 200}
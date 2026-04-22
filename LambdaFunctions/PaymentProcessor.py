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
        order_id = order['order_id']

        # Simuliere Payment-Verarbeitung
        payment_success = True  # In Realität: Payment-Gateway-Call

        table.update_item(
            Key={'order_id': order_id},
            UpdateExpression='SET paymentStatus = :status',
            ExpressionAttributeValues={':status': 'PAID' if payment_success else 'FAILED'}
        )

        if payment_success:
            sqs.send_message(
                QueueUrl=notification_queue_url,
                MessageBody=json.dumps({
                    'order_Id': order_id,
                    'type': 'PAYMENT_SUCCESS',
                    'customerId': order['customerId']
                })
            )

    return {'statusCode': 200}
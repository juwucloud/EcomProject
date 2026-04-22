import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

table = dynamodb.Table(os.environ['ORDERS_TABLE'])
topic_arn = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    for record in event['Records']:
        notification = json.loads(record['body'])
        order_id = notification['orderId']

        response = table.get_item(Key={'order_Id': order_id})
        order = response.get('Item', {})

        if order.get('paymentStatus') == 'PAID' and order.get('inventoryStatus') == 'RESERVED':
            table.update_item(
                Key={'order_Id': order_id},
                UpdateExpression='SET #status = :status',
                ExpressionAttributeNames={'#status': 'status'},
                ExpressionAttributeValues={':status': 'CONFIRMED'}
            )

            # Formatiere Items
            items_text = '\n'.join([
                f"  - {item.get('productId', 'N/A')} x{item.get('quantity', 0)} @ ${item.get('price', 0)}"
                for item in order.get('items', [])
            ])

            message = f"""
Order Confirmed!

Order ID: {order_id}
Customer: {order.get('customerId', 'N/A')}

Items:
{items_text}

Total: ${order.get('totalAmount', 0)}

Thank you for your order!
            """

            sns.publish(
                TopicArn=topic_arn,
                Subject=f'Order {order_id[:8]} Confirmed',
                Message=message.strip()
            )

    return {'statusCode': 200}
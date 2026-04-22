curl -X POST ###putinvokeurlhere \
  -H "Content-Type: application/json" \
  -d '{
    "customerId": "customer-123",
    "items": [
      {"productId": "prod-1", "quantity": 2, "price": 29.99}
    ],
    "totalAmount": 59.98
  }'
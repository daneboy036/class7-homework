# Notes

- lambda test payload:

```json
{
  "queryStringParameters": {
    "name": "The Duke of Earl"
  }
}
```

- WAF isn't suported for `aws_apigatewayv2_api` unless you put CloudFront in front of the api

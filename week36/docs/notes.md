# General Notes

- You need to have api gateway and lambda configured for this to work
- You also need a cognito user pool and app client

# Troubleshooting

- I still get a 401 with an access token but not with an id token
  - when you configure your include the scope `aws.cognito.signin.user.admin` (without this the identity token will be expected) -- this was the only scope in the token
- My endpoint works without a token
  - wait a few minutes after deployment for the changes to take effect

# Resources

[Theo's Scripts for getting token](https://github.com/BalericaAI/lambda/tree/main/lessond_cognito/python)
https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-enable-cognito-user-pool.html
https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-using-the-access-token.html

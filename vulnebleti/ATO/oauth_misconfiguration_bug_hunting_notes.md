
# Bug Hunting Notes: OAuth Misconfiguration

## 1. Signup with Disabled Email Address
- Check if it's possible to sign up without an email address.
- Often works with Facebook OAuth.
- May lead to Account Takeover (ATO) due to missing verification.

## 2. Signup with Other App's ID Token
- Attempt to reuse an ID token issued for another app.
- Validate whether the server verifies the `aud` (audience) claim.

## 3. Check for Token Leak via Referral
- Inspect referer headers to see if tokens are exposed.
- Example: Tokens leaking in URLs shared across platforms.

## 4. Find HTML Page and Exploit ATO via Referral Header (Latest Chrome CVE)
- Look for public HTML pages in the app.
- Test for vulnerabilities via manipulation of the `Referer` header (e.g., Chrome-specific exploits).

## 5. Check API Endpoint for Victim Email Signup
- Attempt to sign up or authenticate using a victim's email.
- Observe if the endpoint allows unauthorized creation or linking.

## 6. Chain Open Redirect to Token Theft
- Identify open redirect vulnerabilities.
- Chain them with OAuth flow to capture tokens.

## 7. Token Theft via Referral
- Manipulate `Referer` headers to steal tokens sent to third-party sites.
- Especially potent if access tokens are sent in query strings.

## 8. ATO via Punycode Domains
- Use visually similar Punycode domains to trick users into OAuth login.
- Example:
  ```
  https://xn--pple-43d.com
  ```

### References
- [ATO via Punycode Domains](https://x.com/AmirMSafari/status/1929281667899785630)
- [Dirty Dancing in OAuth Flows](https://labs.detectify.com/writeups/account-hijacking-using-dirty-dancing-in-sign-in-oauth-flows/)

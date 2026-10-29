
# Bug Hunting Notes: Account Takeover (ATO) Tips

## 1. ATO via Unverified Email and Password Reset Flow

### Steps:
1. **Sign up** with an attacker-controlled email (do not verify it).
2. Skip verification and proceed to change the email to a new attacker-controlled one.
3. Use the "Forgot Password" function on the new email to reset the password.
4. Change the email again — this time enter the **victim's email address**.
5. Trigger the "Forgot Password" flow on the victim's email.
6. Reset the password using the link — now you control the victim's account.

### Key Insight:
- Lack of verification and proper email ownership checks can lead to full account hijacking.

---

## 2. ATO via Management Dashboard with Role-Based Access

### Scenario:
If the application has a **management portal** or dashboard with multiple user roles (e.g., Admin, Member, Viewer).

### Exploit Flow:
1. As the attacker, send an **invite link** from your organization to an email you control.
2. Instead of opening the invite yourself, **paste the link into the victim's browser**.
3. If the victim accepts the invitation (and the app does not validate the actual ownership of the invited email), the attacker email gets added to the victim’s session/org context.
4. This results in a one-click ATO, where attacker gains access to the victim’s org or permissions.

### Key Insight:
- Weakness in invitation verification and email ownership validation enables privilege escalation and lateral movement.

---

## Notes
- Always test password reset flows, email change functions, and invitation flows for weak verification mechanisms.
- Look for missing checks in session handling, email binding, and token issuance.


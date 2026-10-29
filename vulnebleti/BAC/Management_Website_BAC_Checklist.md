
# 🛡️ Management Website - BAC Testing Checklist

## ✅ 1. Role Escalation via Invitations
- [ ] Can a **Viewer** or **Developer** invite users with **Admin** role?
- [ ] Are **role assignment permissions** being enforced on the frontend and backend?

## ✅ 2. Race Condition in Invite Endpoint
- [ ] Test race condition on **admin role edit** functionality.
- [ ] Try updating email parameter when editing invite — if attacker can add their own email and it updates without verification → **Account Takeover**.

## ✅ 3. UID Token Exposure in Invitations
- [ ] Check if **invitation links (UID tokens)** are visible to low-privilege users via API.
- [ ] If yes, try accepting high-privilege invites from a low-privilege account.

## ✅ 4. Email Swap in Group-Based Invite Flow
- [ ] Create a group with permission to **send password reset** and **edit email**.
- [ ] Flow:
  - Send password reset to attacker-controlled email.
  - Edit email address to victim’s.
  - Use reset link (sent to attacker email) to set a new password.
  - If successful → **One-click ATO**.

  🔥 **Title:** Without Interaction, I can takeover anyone's account Just by knowing their Email ID.

## ✅ 5. Invite Functionality Issues
- [ ] Invite same email to **multiple organizations** with different names/roles.
- [ ] Check if **name or role updates** sync across orgs.
- [ ] Try inviting a **Super Admin** as a **User** → see if role is downgraded.

### Email Lockout Bug
- [ ] Flow:
  - Invite a user, then delete them before they accept.
  - They receive an invite and click it.
  - Try to set password → Error: “non-existent user”.
  - Result: email is now locked out of registration.

## ✅ 6. Group Ownership Exploit
- [ ] If attacker is **not part of a group**, try adding the group to a **workspace as Owner**.
- [ ] If it works → All group members gain Owner access.

## ✅ 7. Guest Login → Token Leak
- [ ] Try booking a ticket or accessing feature with **Guest Login**.
- [ ] Use victim email → intercept request.
- [ ] If **access token leaks**, attacker can log in as victim.

## ✅ 8. Disabled Invite Bypass via API
- [ ] Invite attacker account as Admin.
- [ ] Disable the invite before it’s accepted.
- [ ] Use Burp to intercept and replay auth token from invite.
- [ ] If attacker can still access → bypass works.

## ✅ 9. Race Condition in Email-Sending Functions
- [ ] Identify any functionality that sends an email (e.g., **Forget Password**, **Invite**).
- [ ] Add attacker + victim email simultaneously via race condition.
- [ ] If both get the reset link or attacker can act on behalf of victim → **ATO possible**.

---

📌 **Note:** Test all these scenarios both via UI and direct API manipulation (Burp Suite/Postman). Document any unintended behaviors and check privilege boundaries at every step.

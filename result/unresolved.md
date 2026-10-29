# Unresolved Items

1. **Authorization object IDOR/BAC** — accounts A and B both have empty
   `ListAuthorization` results; testing cross-tenant authorization IDs would
   require real IDs and is out of scope. Status: unresolved until a test object
   is available.
2. **Support-agent rendering** — the internal support console is not reachable
   with the disposable customer accounts. Customer-side sanitization was verified;
   agent-side rendering could not be observed.
3. **SSRF via SourceURL / CustomerReferURL** — the values are origin-prefixed and
   internal callback targets were not authorized. Status: not testable safely.
4. **Full upload allow-list** — observed HTML/SVG/PDF rejection and text/plain
   acceptance; the complete MIME/extension policy was not extracted because a
   grep over the minified bundle exceeded the command timeout.
5. **`HandleTicket` action allow-list** — the server accepted `confirm` on a
   `handling` ticket even though `ListTicketExecutableAction` advertised only
   `close`/`urge`. Only the caller's own ticket was affected; impact is limited
   to workflow/state semantics and is not notification-worthy. Full action
   matrix not enumerated to avoid support-facing side effects.

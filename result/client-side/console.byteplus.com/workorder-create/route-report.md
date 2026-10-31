# Route Report — /workorder/create

- Route: https://console.byteplus.com/workorder/create
- Status: completed
- Tested by: account A (`3000823185`)
- Route JS: `https://res.gcloudcache.com/bp-fe/workorder-web/static/js/TicketCreate.22cfeac3.js`, `main.7d5d0431.js`

## Regex match counts (exact client-side-skill regexes)

| Regex | Count |
|---|---:|
| source1 | 13 |
| source2 | 1 |
| sink: location.assign/replace | 1 |
| sink: location = | 0 |
| sink: createElement(iframe/object/embed/script) | 0 |
| sink: eval/Function/document.write/insertAdjacentHTML/innerHTML/srcdoc | 1 |
| sink: dangerouslySetInnerHTML | 0 |

## Sources and sinks

- `.get(...)` matches are form-translation, flow/code list, and product/tag lookups. No form field or URL parameter was traced to a DOM/HTML sink.
- `source2` and the `location.replace` match are the shared navbar mobile-sync logic in `main.js` (`hiddenNavbar` query parameter); the target is reconstructed from `window.location.href`, not attacker-supplied.
- The sole `innerHTML` match is the shared linkify helper in `main.js`, not used by the create form.

## API coverage

Loaded/used by the route: `ListAllFlow`, `Tcc`, `getWorkorderConsoleConfig`, `getFormTokenAndCodeList`, `GetAccountMaskedSecurityContact`, `GetTicketCountForUser`.

`CreateTicket` was tested with user-controlled `AccountID`, `SubmitterID`, `SubmitterEmail`, `TicketState`, `HandleStatus`, `Status`, `NeedReview`, `ReviewStatus`, `ConfirmedTime`, `FinishedTime`, and hidden flow/product fields. Protected ownership/state fields were ignored; the ticket was created under the caller account with normal state. `AttachmentStr` was normalized/rejected and did not grant access to another account's file.

## Result

No client-side vulnerability on the create route. No mass-assignment or cross-account ownership bypass was confirmed.

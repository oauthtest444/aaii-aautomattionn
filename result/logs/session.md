START=2026-10-30T03:58:41Z
start_utc: 2026-10-30T03:58:41Z
target: account.ui.com
agent_model: opencode/deepseek-v4.1-flash-free
env: Linux runnervmnwato 7.0.0-1017-azure #17-Ubuntu SMP PREEMPT Thu Sep 24 15:54:51 UTC 2026 x86_64 GNU/Linux
chrome: Google Chrome 156.0.8078.73 
node: v22.23.4
python: Python 3.14.4
curl: curl 8.18.0 (x86_64-pc-linux-gnu) libcurl/8.18.0 OpenSSL/3.5.5 zlib/1.3.1 brotli/1.2.0 zstd/1.5.7 libidn2/2.3.8 libpsl/0.21.2 libssh2/1.11.1 nghttp2/1.68.0 librtmp/2.3 mit-krb5/1.22.1 OpenLDAP/2.6.10

UPDATED=2026-10-30T04:25Z
progress_file: result/route-progress.md
route_reports: result/route-reports.md
api_inventory: result/server-side/account.ui.com/api-inventory.md
observations: result/findings/observations.md
routes_discovered: 39 (+ wildcard *)
routes_fully_tested_unauth: 13
routes_blocked_auth: 18
accounts_created: 0 (reCAPTCHA challenge; POST /api/sso/v2/users -> 403 CHALLENGE_RECAPTCHA_TOKEN_REQUIRED)
confirmed_vulns: 0
discord_notified: no
notes: unauthenticated testing only; no captcha bypass; open-redirect allowlist verified; no XSS; CORS restricted to https://account.ui.com
extra_probes: login/email type-confusion (400, no injection); legacy email send (403); login/2fa (401); suspicious/confirm validation (400); verify resend (captcha+devicecheck required); roles/beta (401); ecomm /graphql __typename only (field selection 500); billing v2 (401); fabric msp (401)
conclusion: no unauthenticated endpoint tested yielded a reportable vuln; authenticated routes remain blocked by reCAPTCHA

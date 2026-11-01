# creds/

This public repository intentionally contains disposable test credentials.

- `test-account.txt` — public test login for authorized targets.
- `auth-headers.txt` — local, gitignored authentication cache containing the
  required headers and cookies for both disposable test accounts. The workflow
  restores and caches it between runs.

Do not commit `auth-headers.txt`. Do not copy authentication headers, cookies,
or tokens into `result/`, compaction files, logs, reports, or chat output; keep
them only in this local file. The test accounts are disposable, but their
sessions should still be treated as sensitive.

Never add real, valuable, or third-party credentials to this directory. If real
credentials are ever needed, use GitHub Actions secrets and do not commit them.

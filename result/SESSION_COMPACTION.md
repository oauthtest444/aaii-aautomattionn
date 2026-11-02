# Session Compaction

Last updated: 2026-11-01T05:25:00Z
Target: `https://console.byteplus.com` (authorized routes: `/datarangers`, `/datatester`, `/ark`, `/ai`, `/alb`)
Target hash: `03aef71f1ba65c11c7ba408a0ebd646abc6e8850fd4cf34ff397d9096f808f27`
Status: completed (`result/SCAN_COMPLETE` exists; no pending required work)

## Session summary

This maintenance session added continuity/auth/scope rules and recorded the
completed scan. No new target testing was performed.

## Discovered surface

- Five top-level routes: `/datarangers`, `/datatester`, `/ark`, `/ai`, `/alb`.
- All discovered sub-routes and 48 inventoried APIs.
- Subdomain inventory: `console.byteplus.com` completed.
- Client-side reports under `result/client-side/console.byteplus.com/`;
  server-side report under `result/server-side/console.byteplus.com/`.

## Tested

- Same-origin routes, sub-routes, APIs, and loaded JavaScript for all five
  top-level routes, including cross-tenant checks with two test accounts.
- Confirmed low-impact read-only cross-project IDOR (`VULN-20261031-001`) in
  DataFinder `common_settings`; benign presentation settings only, below the
  notification bar.
- No high-impact IDOR/BAC, XSS execution, or sensitive postMessage impact
  confirmed.
- Unresolved: Ark managed-agent sub-routes were not activated for the test
  accounts; client-side missing-origin listeners and config-driven redirect
  candidates showed no demonstrable impact.

## Pending / next

- No required work remains for the current completed scan.
- If new subdomains, endpoints, or scope are supplied, verify authorization
  before testing and record new discoveries here immediately.
- Do not repeat prior exclusions automatically; verify against `data/` and the
  program scope, or mark `Scope Unverified`.

## Authentication

- Test account A: AccountID `3000823185` (`test-user-123`).
- Test account B: AccountID `3001021825` (`testt456`).
- Cached auth headers belong only in `creds/auth-headers.txt`; never copy
  cookies, tokens, or secrets into this file, reports, or logs.

## Scope decisions

- `console.byteplus.com` is the authorized host for this completed run; only
  its five listed top-level routes were exercised.
- Other `byteplus.com` subdomains are **scope-unverified**, not automatically
  out of scope. Verify program/data authorization before testing and record
  `Scope Unverified` when ambiguous.
- The related-subdomains note is scope input, not blanket authorization for
  every `byteplus.com` subdomain.

## Workflow closeout

- timestamp: 2026-11-01T06:04:54Z
- run_id: 41279118674
- event: workflow_dispatch
- agent_outcome: failure
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-01T06:24:09Z
- run_id: 41280304453
- event: workflow_dispatch
- agent_outcome: failure
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-01T06:35:13Z
- run_id: 41280842601
- event: workflow_dispatch
- agent_outcome: failure
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-01T06:42:17Z
- run_id: 41281582964
- event: workflow_dispatch
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-01T12:56:45Z
- run_id: 41308755977
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-01T21:53:14Z
- run_id: 41354170357
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-02T03:47:09Z
- run_id: 41384816143
- event: workflow_dispatch
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-02T05:15:51Z
- run_id: 41392843883
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

## Workflow closeout

- timestamp: 2026-11-02T15:13:44Z
- run_id: 41469255736
- event: schedule
- agent_outcome: skipped
- workflow_status: failure
- note: Agent-created compaction is authoritative; this closeout records how the run ended.

# Client-Side Route Report — /ark/region:ap-southeast-1/tts/podcast?

Status: completed
Result: Not Vulnerable (parent shell); embedded app Out of Scope

## Parent shell (console.byteplus.com)

- Same SPA bundle set as `/ark/region:ap-southeast-1/overview` (identical
  SHA-256 hashes), so the deduplicated regex/trace results apply unchanged.
- `podcast?` query handling reads params for UI state only; no param reaches a
  navigation or HTML/script sink.
- No client-side vulnerability confirmed on the authorized origin.

## Embedded application

The page mounts `https://console-embedded.byteplus.com/voice/new/*`. That is a
different subdomain not explicitly authorized by `data/targets.txt`, so it was
recorded as Out of Scope per AGENT.md §4.3 and not actively tested.

Sub-routes recorded (Out of Scope): `/voice/new/overview`, `library`,
`playground`, `audio-generation`, `tts`, `voice-replication`, `stt`,
`live-interpretation`.

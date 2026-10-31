# Top-Level Route Inventory

Target: https://console.byteplus.com/ark/region:ap-southeast-1/tts/podcast?

Scope: console.byteplus.com only. Related first-party hosts on other subdomains
(console-embedded.byteplus.com, modelark-api.console.byteplus.com,
arkbff-ap-southeast1.console.byteplus.com) are recorded in
`result/inventory/subdomains.md` and were not tested (AGENT.md §4.3).

| Top-Level Route | Status | Sub-Routes | Summary |
|---|---|---|---|
| https://console.byteplus.com/ark/ | completed | 12 | ModelArk SPA shell; server-side console APIs and shared SPA bundle tested. |
| https://console.byteplus.com/ark/region:ap-southeast-1/tts/podcast? | completed | 8 | Parent page tested; embedded voice app is on another subdomain (Out of Scope). |

## https://console.byteplus.com/ark/

Status: completed

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /ark/region:ap-southeast-1/overview | completed | Served by shared SPA bundle; console.byteplus.com `/api/top/ark/*` APIs tested. |
| /ark/region:ap-southeast-1/model | completed | Shared SPA bundle (identical JS hash); no new in-scope API calls. |
| /ark/region:ap-southeast-1/endpoint | completed | Shared SPA bundle; no new in-scope API calls. |
| /ark/region:ap-southeast-1/customModel | completed | Shared SPA bundle; no new in-scope API calls. |
| /ark/region:ap-southeast-1/tts/podcast | completed | Parent shell tested; see podcast section below. |
| /ark/region:ap-southeast-1/tts/speechSynthesis | completed | Shared SPA bundle; embedded voice content Out of Scope. |
| /ark/region:ap-southeast-1/tts/speechRecognition | completed | Shared SPA bundle; embedded voice content Out of Scope. |
| /ark/region:ap-southeast-1/tts/timbreDesign | completed | Shared SPA bundle; embedded voice content Out of Scope. |
| /ark/region:ap-southeast-1/tts/tts2 | completed | Shared SPA bundle; embedded voice content Out of Scope. |
| /ark/region:ap-southeast-1/experience/voice | completed | Shared SPA bundle; embedded voice content Out of Scope. |
| /ark/region:ap-southeast-1/docs | completed | Shared SPA bundle; static documentation surface. |
| /ark/region:ap-southeast-1/gallery | completed | Shared SPA bundle; static gallery surface. |

## https://console.byteplus.com/ark/region:ap-southeast-1/tts/podcast?

Status: completed

The podcast page is a console.byteplus.com shell that mounts an iframe on
`console-embedded.byteplus.com`. That host is not explicitly covered by
`data/targets.txt`, so its routes were recorded as Out of Scope per AGENT.md §4.3
and were not actively tested.

### Sub-Routes

| Sub-Route | Status | Summary |
|---|---|---|
| /voice/new/overview | completed | Out of Scope: console-embedded.byteplus.com (not explicitly authorized). |
| /voice/new/library | completed | Out of Scope: console-embedded.byteplus.com. |
| /voice/new/playground | completed | Out of Scope: console-embedded.byteplus.com. |
| /voice/new/audio-generation | completed | Out of Scope: console-embedded.byteplus.com. |
| /voice/new/tts | completed | Out of Scope: console-embedded.byteplus.com. |
| /voice/new/voice-replication | completed | Out of Scope: console-embedded.byteplus.com. |
| /voice/new/stt | completed | Out of Scope: console-embedded.byteplus.com. |
| /voice/new/live-interpretation | completed | Out of Scope: console-embedded.byteplus.com. |

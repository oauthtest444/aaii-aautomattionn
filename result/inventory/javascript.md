# JavaScript Inventory

| URL | SHA-256 | Loaded by | Tested | Notes |
|-----|---------|-----------|--------|-------|
| `https://res.gcloudcache.com/bp-fe/console-ark/ark-new-main/static/js/main.f3396fb22b.js` | `b343767e91c8fbeb89140450f82972f944b84bbebee51f13c6c432ca5343e38c` | console shell | yes | webpack runtime |
| `.../static/js/async-main.d0a27388a1.js` | `0ab8514ddf0df66f3fc7af0faf929fb04c169d593fc467189d81bb912b65e0b6` | console shell | yes | route table incl. `/managed-agents/credentials-vault-oauth/callback` (guestMode, fullBleed, hideVCopilot) |
| `.../static/js/async/1540.1dae60cb77.js` | `2832638ee9f46b71ea7021b2c2a6f0ee6591013a7c5d2dd868d48d4c8c76c406` | console shell | yes | `/open/*` SDK action definitions |
| `.../static/js/async/7006.3374811d72.js` | `da2f322ff805d03b8453242170f2e89b0ac99fbb58486db262f64964b3ff2845` | console shell | yes | iframe postMessage bridge (origin+source validated) |
| `.../static/js/async/(region)/docs/(slug)/page.3124942250.js` | not stored | docs route | yes | 180-byte re-export of module 87093 |
| `.../static/js/async/6390.72c02fadf9.js` | `76a1a35783b3eb103a948e8b0f0f21cec5a875414aaaf1e58b47a5360c0171e7` | docs route | yes | module 87093 docs renderer; only safe HTML sinks; link validator |
| `.../static/js/async/8627.091a1c4f24.js` | not stored | OAuth callback route | yes | reads `vaultId`/`credential_id`/`source`, writes localStorage, `window.close()` |
| `https://res.gcloudcache.com/bp-fe/console-ark/managed-agents/vmok-remote-entry.bf8ce106.js` | `ef4544c0b15a0ca2a1bc521c1fd49fe07b6c5b639ebb956f80033483658e2765` | credentials vault | yes | vault action names + credential auth types |
| `.../managed-agents/vault.js` | `8731cb8fa1cc71816c4f0e4b46cd0ddcb8b2902b45929d4d380153b6bf0bad98` | credentials vault | yes | message/storage listeners, OAuth-complete handling |
| `.../managed-agents/38767.69bfc8048a.js` | `9a48c8a16408baa2a46acbc23dbc77c692abe4c7691b822a1719fad1071ec819` | managed agents | yes | bundled Tea/visual-editor SDK; message listeners |
| `https://res.gcloudcache.com/bp-fe/console-ark/model-customization/vmok-remote-entry.ee1621d1.js` | `15397cce2f309cecce925b9023854c18fc121140d275406f00a9a582356d9e78` | model customization | yes | federation exposes; no URL-bearing methods except `CreateInferenceService` |

# Unresolved / Blocked Items

- **Model-detail HTML content:** `GetClientModelDetailPage` returns server-authored `introductionMarkdown` HTML that the model page renders. No sink abuse is reachable today (public catalog is BytePlus-authored; custom-model creation/publication is activation-gated). Re-test if tenant-published model descriptions become reachable.
- **Managed-agent MCP providers:** `CreateVaultOAuthFlow` accepts only built-in MCP providers (Linear/Notion/GitHub/etc.); arbitrary `McpServerUrl` values fail before a successful fetch. No SSRF conclusion for an allowlisted-provider-only path.
- **Whitelist / usage enums:** `GetWhiteListAccountConfig` (`EntityType` enum) and `GetUsage` (`QueryInterval`/`StartTime` formats) accept values not present in the client bundle; valid values were not recovered.


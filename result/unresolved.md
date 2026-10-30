# Unresolved items

- **Task-detail IDOR/BOLA**: `CreateTransmissionTask`/`CreateValidationTask`
  require a nested `SrcConfig`/`DestConfig`/`SolutionSettings` schema that could
  not be reconstructed from public docs (SPA-rendered) or opaque `InternalError`
  responses. No TaskId was created, so `DescribeTransmissionTaskInfo` /
  `DescribeValidationTaskInfo` cross-account tests could not be run.
- **`GetSecurityToken`** (`SecurityTokenOfBinlogInTOS`): request hangs >18s for
  both test accounts; could not evaluate STS credential scope.
- **`ListAccount` / `DescribeAllClusters`**: registered at 2018-01-01 but return
  opaque `InternalError` for paging/account parameter guesses; internal-only or
  broken, not usable.
- **Hidden routes `/dts/params`, `/dts/dflow`**: console-level 404 for the test
  account (micro-app does not mount them).
- **Stored XSS in data-source/task names**: not tested in the UI; React escaping
  is expected, and no delivery to a privileged viewer was identified.
- **`/dts/modifyOrder`**: order/billing action intentionally not tested
  (payment/business-logic side effects).

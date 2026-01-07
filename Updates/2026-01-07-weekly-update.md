# Weekly Update - January 7, 2026

## Team Borg:
- **Dashboarding**
  - Drag on timeseries/bar chart to select time range in progress
  - Done: Monaco editor CDN dependency fix (air-gap support)
  - Done: UI automation tests complete
  - Done: Dashboard tests added to automation framework
- **Developer Experience**
  - Biome migration (replacing Prettier+ESLint) in progress
  - Done: Tabs formatting, organizeImports, useSortedAttributes enabled
- **Infrastructure**
  - Handle parallel restore operations in progress
  - Done: Kops clusters upgraded to 1.32 and 1.33
  - Done: Backup CLI configMap/Secret naming fix
  - Done: Backup list jobs resource creation fix

## Team Marvin:
- **StackGraph Data Corruption**
  - Done: Tephra state mismatch fix (WAL/snapshot consistency)
  - Done: HBase OOM fix on chaos-1 after K8s upgrade
  - Done: Workload observer crashloop fix
- **Agent**
  - Splunk disabled saved searches support in review (Rabobank)
  - Done: OpenAPI generation fix for stackstate-cli
- **QA**
  - Playwright scenarios for Metric Inspector in progress
  - CLI tests framework exploration in progress
  - Done: Playwright scenarios for Monitors

## Stackpacks 2.0 (Cross-Team Sprint)
- **OTel Mapping API** (Lukasz)
  - API handlers implementation in progress
  - Permissions implementation in progress
  - OpenAPI spec merging
  - OpenAPI code generation merging
  - DTO model reuse merging
- **Documentation** (Alejandro, Akash)
  - Preview docs feature flag in review
  - Stackpacks2 docs deployment from trunk in progress
- **Done:**
  - Feature flag renamed to `experimentalStackpacks` for clarity

---

**Main themes:** Dashboarding wrapping up for release, StackGraph stability fixes shipped, Stackpacks 2.0 cross-team sprint progressing with API and docs work, infrastructure upgrades complete.

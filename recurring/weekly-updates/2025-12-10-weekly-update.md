# Weekly Update - December 10, 2025

## Team Borg:
- **Dashboarding**
  - UI automation tests being added
  - Variable handling improvements in review
  - Documentation in review
  - Approaching release readiness
- **Stackpacks 2.0 (OTEL Topology)**
  - OTel Mapping API in progress
  - Span-to-topology deduplication in progress
  - Done: Support for additional otel fields (span.name, metric.name)
- **Developer Experience**
  - Done: TypeScript 5.x upgrade
  - Biome migration (replacing Prettier+ESLint) in review
- **Infrastructure**
  - Helm chart value generation replacement in progress
  - Done: Clickhouse backup restore CLI command

## Team Marvin:
- **StackGraph Data Corruption** - Primary focus
  - Multiple fixes in progress/review for nightly champagne corruption
  - Extended integrity checker, WAL improvements, increased flush frequency
- **Stackpacks 2.0**
  - Converting light stackpacks to full ones - merging
  - Done: Stackpacks2 branch deploy and helm chart auto-flags
- **Agent**
  - Datadog upstream merge [7.71.2] continues
  - Done: Multiple CVE fixes, K8s RBAC agent resources fix, Splunk credential logging fix
- **QA**
  - Done: QASE integration with Go tests, K8s 1.30/1.31/1.32 compatibility testing
  - Python QASE integration in progress
- **Release**
  - v2.6.3 released (Nov 24)

---

**Main themes:** Dashboards nearing release, StackGraph data corruption is top priority for stability, Stackpacks 2.0 progressing.

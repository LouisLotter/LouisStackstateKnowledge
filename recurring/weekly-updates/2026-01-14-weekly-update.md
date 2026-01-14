# Weekly Update - January 14, 2026

## Team Borg:
- **Dashboarding / v2.7.0 Release**
  - Release in progress - SaaS rollout done, helm chart version determined, nightly testing done
  - Docs MR and public release pending
  - Done: Drag on timeseries/bar chart to select time range
  - Done: Stat widget text size alignment
  - Done: Gauge widget text size fix
  - Done: Dashboard overview quick filters (My/Shared/Starred)
  - Done: Traces scrollbar fix
- **Developer Experience**
  - Biome migration continues - ESLint replacement in progress
  - Done: biome.jsonc generation from biome.mjs
  - Done: twin.macro !important modifier migration
  - Done: twin.macro groups migration (no instances found)
  - twin.macro css/tw prop migration in progress
- **Infrastructure**
  - Handle parallel restore operations in review
  - Done: DKIM verification fix for observability.suse.com

## Team Marvin:
- **StackGraph Stability**
  - WAL mismatch on chaos champagne in progress
  - Bosch sync memory pressure work in progress
- **Agent**
  - Cluster agent container build/test in progress
  - Done: Pipeline merged result fix
  - Done: Splunk disabled saved searches support
- **QA**
  - Playwright scenarios for UI validation in progress
  - Done: Metric Inspector scenarios added
  - Done: CLI tests framework exploration

## Stackpacks 2.0 (Cross-Team Sprint)
- **OTel Mapping API** (Lukasz)
  - Done: API handlers implementation
  - Done: Permissions implementation
  - Done: OpenAPI spec, code generation, DTO model reuse
- **ComponentPresentation** (Alejandro)
  - Example stackpack with OtelComponentMapping in progress
  - Done: Empty component presentation StackGraph/DTO object
- **Documentation**
  - Monitors and metrics binding docs in progress
  - Done: Preview docs feature flag
  - Done: Stackpack CLI documentation
  - Done: ComponentPresentation first version docs
  - Done: Stackpacks2 docs deployment from trunk
- **Infrastructure**
  - Done: OTel collector init container for Kafka wait

---

**Main themes:** v2.7.0 release wrapping up (dashboarding flagship feature), Stackpacks 2.0 OTel Mapping API complete, DX improvements with Biome migration continuing, StackGraph stability work ongoing.

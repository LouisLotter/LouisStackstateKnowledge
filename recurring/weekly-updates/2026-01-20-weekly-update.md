# Weekly Update - January 20, 2026

## Team Borg:
- **v2.7.0 Release**
  - Done: Release complete - public release published, docs merged, tenants updated
  - Done: Fix version applied to all released tickets
- **Dashboarding Polish**
  - Done: Gauge widget text size fix at different zoom levels
  - Done: Sorting/widget state persistence when scrolling (virtualization fix)
- **Developer Experience (Biome Migration)**
  - Done: ESLint replaced by Biome linter
  - Done: Migrate from Prettier+ESLint to Biome (parent epic complete)
  - Done: twin.macro pattern #3 (css/tw prop → className)
  - Done: twin.macro pattern #7 (Theme Access)
  - Merging: twin.macro pattern #4 (Conditional Styles)
  - In Progress: twin.macro pattern #5 (Styled Components → Regular Components)
  - In Progress: twin.macro pattern #6 (Complex Styled Components with Props)
- **Infrastructure**
  - Done: Zookeeper jute.maxbuffer fix for ClickHouse HA mode
  - Done: Parallel restore operations handling
  - In Review: Replace values generation helm chart with global values
  - In Review: Do not generate API key by default

## Team Marvin:
- **StackGraph Stability**
  - Done: WAL mismatch on chaos champagne fixed
  - In Progress: Bosch sync memory pressure - readcache removal investigation
  - In Review: Free memory after initial load from akka stream lifecycle manager
- **DevOps**
  - Merging: Decommission old 5.1 and 6.x tenants
  - Merging: Deploy stackpacks2 documentation from trunk
- **QA**
  - Done: Update snapshots after release
  - In Progress: Adding scenarios for Metric Query
  - In Review: Update documentation with compatibility matrix

## Stackpacks 2.0 (Cross-Team)
- **OTel Mapping API** (Lukasz)
  - Done: Create OTel Mapping API (parent epic complete)
  - All sub-tasks merged and closed
- **ComponentPresentation** (Frank, Deon, Alejandro)
  - In Progress: Design component presentation API(s)
  - In Progress: Design binding and rank fields
  - In Progress: Create example stackpack 2.0 with OtelComponentMapping
- **Documentation**
  - Done: Document monitors and metrics binding DTOs
  - Done: Package and validate stackpack 2.0 through CLI commands
- **Infrastructure**
  - In Progress: Scaling the OTel collector for Topology mapping (load testing)

---

**Main themes:** v2.7.0 released with Dashboarding flagship feature, Biome migration nearing completion (ESLint fully replaced), OTel Mapping API epic complete, StackGraph WAL mismatch fixed, ComponentPresentation design work progressing.

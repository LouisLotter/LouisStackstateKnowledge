# StackGraph Migration Overview: From HBase/Tephra to ClickHouse

## Background

The Suse Observability platform relies on StackGraph—a proprietary graph database built on Apache HBase and Apache Tephra—to power its "4T Data Model" (Topology, Telemetry, Tracing, Time). The time-travel capability allows operators to rewind infrastructure state to precise moments for root cause analysis.

However, the HBase/Tephra stack has become an unsustainable operational burden. The engineering team is evaluating a migration to ClickHouse to reduce maintenance overhead while preserving core functionality.

---

## Key Discussion Points (Dec 8, 2025)

### What StackGraph Currently Stores

1. **Topology** — The graph of infrastructure components and their relationships (high write volume, frequent corruption issues)
2. **Settings** — Configuration items like layers, domains, metric bindings (low write volume, heavily relies on transactionality and referential integrity)

### The Decoupling Strategy

The team agreed to **prioritize topology migration first** because:
- Topology is the primary source of corruption and operational pain
- Settings are written infrequently and can remain in a simplified StackGraph instance (single-node, non-HA)
- Moving settings first but leaving topology broken would be counterproductive

For settings, PostgreSQL with Hibernate is the likely future path since it provides the CRUD, transactionality, and referential integrity that ClickHouse cannot natively support.

### Components Affected by Migration

| Component | Migration Complexity |
|-----------|---------------------|
| Health States | Straightforward if topology migration succeeds |
| Topology Changed Events | Complex — current event semantics tied to StackGraph's transactional model |
| Indirect Relations | Needs implementation (breadth-first search approach) |
| With Neighbors | Not yet implemented in prototype |

---

## Why ClickHouse?

### Benefits Identified

- **Already in the stack** — We're already running, backing up, and operating ClickHouse for traces/logs
- **Insert data for any timestamp** — Unlike StackGraph's strictly monotonically increasing time, ClickHouse allows late-arriving data
- **Observed time vs ingestion time** — Can capture when the collector observed data, not when StackState backend wrote it
- **SQL query language** — Fuzzy search, pagination, easier experimentation and troubleshooting
- **Better developer experience** — Higher-level APIs, transferable skills, well-documented
- **Compression** — Factor of ~20x compression on component tables
- **Operational simplicity** — Single binary, no HDFS/ZooKeeper/Tephra stack, no Java GC pauses

### Risks and Trade-offs

| Risk | Description |
|------|-------------|
| **Point lookup performance** | ClickHouse uses sparse indexes; single-row lookups are slower than HBase |
| **Eventual consistency** | No multi-row ACID transactions; UI may show stale data during writes |
| **Data model fit** | If queries are too random, ClickHouse optimizations may not apply |
| **Caching complexity** | StackGraph's transactional caching doesn't translate; time-based caching trades latency for cacheability |
| **Event semantics change** | Topology changed events would become "optimistic hints" requiring database verification |

---

## Alternative Approaches Discussed

### 1. Kafka Streams + RocksDB (Bram's Proposal)

- Event-sourced architecture with Kafka handling sharding
- Each shard materializes into RocksDB
- No consensus needed (Kafka manages it)
- Pros: No transactions = better corruption resilience
- Cons: Must implement query APIs from scratch; RocksDB is just key-value

### 2. Frank's RocksDB Approach

- Re-implement StackGraph's storage layer on top of RocksDB
- Still building a database from building blocks
- Need to review Frank's presentation to understand fully

### 3. FoundationDB

- Provides HA out of the box
- But: It's a "foundation for a database" — requires significant custom development
- Co-processor model never materialized

### Why Not PostgreSQL for Topology?

- Cannot handle the high-volume ingestion rate that topology requires
- ClickHouse is optimized for OLAP workloads and absorbs data "at an insane rate"

---

## Technical Deep Dive: Time-Travel in ClickHouse

Based on the Gemini Deep Research analysis, the key mechanism for time-travel is the **ASOF JOIN**:

```sql
SELECT
    edges.source_id,
    edges.target_id,
    nodes.properties
FROM edges
ASOF JOIN nodes ON (edges.source_id = nodes.id AND edges.valid_from <= nodes.valid_from)
WHERE edges.valid_from <= '2023-10-27 14:00:00'
  AND (edges.valid_to > '2023-10-27 14:00:00' OR edges.valid_to IS NULL)
```

This requires a **validity interval schema**:

| Field | Type | Description |
|-------|------|-------------|
| `source_id` | String/UUID | Origin component |
| `target_id` | String/UUID | Destination component |
| `relation_type` | LowCardinality(String) | e.g., "calls", "hosted_on" |
| `valid_from` | DateTime64(3) | When relationship appeared |
| `valid_to` | DateTime64(3) | When it disappeared (NULL if active) |

**Critical Risk:** ASOF JOINs are memory-intensive. With tens of millions of nodes, OOM errors are possible.

---

## Current Prototype Status (Remco's Work)

### What's Working
- Replaced Kafka exporter after auto-mapper with ClickHouse exporter
- Hacked Xtoposync task to write Kubernetes and agent data to ClickHouse
- Topology query service reimplemented using Claude AI assistance
- Pull-based approach (every 15 seconds) instead of event-driven
- Live topology queries are fast after initial cache warm-up

### What's Not Implemented Yet
- Health states (always show "unavailable")
- Component type icons (layer/domain resolution)
- Indirect relations
- With neighbors traversal
- Component merging
- Interpolations

### Observations
- Compression is excellent (~20x on component tables)
- Query performance varies (200ms to 1.5s for same query — possibly due to concurrent writes)
- Schema design matters: including type name in key helps prune data

---

## Success Criteria for Proof of Concept

The PoC must de-risk the migration by proving:

1. **Query Performance** — Time-travel queries complete within acceptable latency (UI timeout ~2s)
2. **Point Lookup Latency** — Sparse index performance is acceptable or mitigatable via caching
3. **Storage Usage** — Not more than 2-3x current StackGraph storage
4. **Feature Coverage** — Demonstrate indirect relations, component merging work
5. **Data Model Fit** — Confirm ClickHouse optimizations apply to our query patterns

### What "Failure" Looks Like
- Queries are too random for ClickHouse to optimize (50%+ of cases unusable)
- ASOF JOINs cause OOM or exceed timeout limits
- Component merging becomes prohibitively expensive

---

## Agreed Next Steps

| Action | Owner | Timeline |
|--------|-------|----------|
| Leave ClickHouse prototype running for ~1 week to observe query performance over accumulated data | Remco | This week |
| Watch Frank's RocksDB presentation | Louis, Remco, Bram | This week |
| Chat with Frank about his RocksDB approach | Team | This week |
| Discuss Kafka Streams event-sourcing idea in more detail | Bram | This week |
| Create overview document (this document) | Louis | Done |
| Reconvene to review options before committing to PoC | Team | Later this week |

---

## Key Decisions Made

1. **Topology first, settings later** — Focus on the pain point
2. **PoC code is disposable** — Don't try to make it production-ready
3. **Single PoC only** — Can't afford multiple parallel experiments; stay in analysis mode until confident
4. **AI assistance is viable** — Claude helped significantly with Scala refactoring (topology query service reimplementation)

---

## Questions to Answer Before Proceeding

### Performance & Data Modeling
1. Have we benchmarked tuple reconstruction cost for our node property density?
2. What is the p99 latency of ASOF JOIN on our largest projected dataset?
3. How will we handle "read-your-writes" consistency for the UI?

### Graph Logic
4. Raw SQL recursion vs overlay tools like PuppyGraph for graph traversal?
5. How do we handle deleted data for time-travel (soft delete strategy)?

### Operations
6. Self-managed ClickHouse Keeper or ClickHouse Cloud?
7. What's the migration path for historical data from HDFS?

---

## Summary

The migration from HBase/Tephra to ClickHouse is **strategically sound** (operational simplicity, cost reduction) but **technically risky** (OLAP vs graph workload mismatch). The current prototype shows promise but critical features remain unvalidated.

**Recommendation:** Complete the analysis phase by reviewing Frank's RocksDB work and Bram's Kafka Streams idea, then commit to a focused ClickHouse PoC that specifically stress-tests ASOF JOINs, indirect relations, and component merging. The PoC should run against production-like data volumes to validate performance assumptions.


---

## Observations by Claude Opus 4.5

*External review of the approach and potential blind spots.*

### What's Being Done Well

- Prioritizing topology over settings (attacking the actual pain point)
- Treating PoC code as disposable (avoids analysis paralysis)
- Recognizing you can only afford one PoC, so analysis matters
- Leveraging AI for the grunt work (smart force multiplier)

### Potential Gaps and Concerns

1. **The "read-your-writes" problem feels under-discussed.** Remco mentioned it briefly, but this could be a UX disaster. User updates a component, refreshes, sees old state. That's the kind of thing that makes customers lose trust. You need a concrete strategy here — not just "we'll figure it out."

2. **No clear rollback plan.** What if you're 6 months into production migration and discover a showstopper? Dual-write architecture was mentioned in the Gemini research but not in the meeting. That shadow-validation phase seems critical and wasn't explicitly planned.

3. **The "events" problem is hand-waved.** The discussion concluded with "maybe we don't need topology changed events" — but that's a big maybe. If internal systems depend on them for optimization (state service, topology query service), removing them could cause performance regressions elsewhere. Worth mapping out all consumers before deciding.

4. **PuppyGraph wasn't discussed at all.** The Gemini research flagged it as a potential solution for recursive traversal (indirect relations). Given that indirect relations are a known gap in the prototype, this seems worth at least a quick evaluation.

5. **No customer/product perspective in the room.** This is a deeply technical discussion, but the trade-offs (eventual consistency, slower time-travel, potential feature cuts) have product implications. When does someone like a PM or customer-facing person weigh in on what's acceptable?

6. **Storage cost assumption might be wrong.** The team said 2-3x storage is fine. But ClickHouse with validity intervals means storing every historical state, not just current. Has anyone modeled what that looks like over 1 year of retention for a large customer?

### A Question Worth Pushing On

Why is "we already have ClickHouse" not a stronger argument? The team is treating it as a nice-to-have, but operationally it's huge. One less database to secure, backup, upgrade, train people on, debug at 3am. That's not path dependence — that's operational leverage. I'd weight it higher than the discussion suggested.

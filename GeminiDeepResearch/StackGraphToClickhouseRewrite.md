# Technical Feasibility and Strategic Analysis: Migrating StackGraph from HBase/Tephra to ClickHouse

## 1. Executive Summary and Strategic Context

### 1.1 The Strategic Imperative for Migration

The Suse Observability platform (formerly StackState) occupies a critical position in the modern IT landscape, functioning as the central nervous system for enterprise monitoring. At the core of this platform lies the "4T Data Model"—Topology, Telemetry, Tracing, and Time.[^1] This model relies on the ability to not only visualize the current state of infrastructure components but to "time travel" through the historical evolution of the graph. This capability allows operators to rewind the state of their complex distributed systems to precise milliseconds in the past to diagnose root causes of incidents.

Currently, this capability is powered by StackGraph, a proprietary implementation built upon Apache HBase for storage and Apache Tephra for transaction management.[^2] While this architecture has historically provided the necessary strong consistency and row-level atomicity required for reliable graph mutations, it has incurred a substantial and growing operational tax. The engineering management team is now evaluating a migration to ClickHouse, a high-performance columnar OLAP database, to alleviate these maintenance burdens.[^3]

This report provides an exhaustive technical and strategic analysis of this proposed migration. It serves as a decision-support document for the Engineering Manager, detailing the architectural impedance mismatches, the engineering challenges of modeling temporal graphs in a columnar store, and the specific strategic inquiries required to validate the feasibility of this transition.

### 1.2 The Core Conflict: OLTP Graph vs. OLAP Columnar

The fundamental tension in this migration lies in the architectural paradigms of the two systems. The existing HBase/Tephra stack functions as a strongly consistent, row-oriented transactional store (OLTP-like properties), optimized for high-throughput random writes and point lookups—the exact primitives required for standard graph traversals and atomic topology updates.[^4]

ClickHouse, conversely, is an Online Analytical Processing (OLAP) system. It excels at scanning billions of rows to compute aggregates (e.g., "average CPU usage across 10,000 nodes") but traditionally struggles with the precise, high-concurrency point lookups and recursive traversals inherent to graph database workloads.[^6] Migrating StackGraph to ClickHouse is not merely a "database swap"; it is a re-architecture of the data model. It necessitates moving from a paradigm of "traversing pointers" to "joining sets," and from "snapshot isolation" to "eventual consistency."

The analysis suggests that while ClickHouse offers dramatic improvements in operational simplicity, ingestion speed, and storage efficiency, it requires significant engineering investment to replicate the "Time Travel" and "Graph Traversal" capabilities that HBase/Tephra provides natively. The success of this migration hinges on the team's ability to leverage advanced ClickHouse features such as ASOF JOINs, VersionedCollapsingMergeTree engines, and potentially the integration of a graph compute layer like PuppyGraph.[^8]

### 1.3 Summary of Recommendations

The report concludes that the migration is technically feasible and operationally desirable but carries high implementation risk regarding query latency for deep graph traversals. It is recommended to proceed with a targeted Proof of Concept (PoC) specifically stress-testing the ASOF JOIN mechanism for historical graph reconstruction and evaluating the operational trade-offs of eventual consistency in the topology UI.

---

## 2. Legacy Architecture Forensic Analysis: HBase and Tephra

To understand the risks of migration, we must first deeply analyze the current system to identify the implicit guarantees and behaviors that StackState relies upon. The "maintenance issues" cited as the driver for migration are rooted in the specific architectural complexity of the Hadoop ecosystem.

### 2.1 HBase Architecture and the Maintenance Burden

HBase is a wide-column store modeled after Google's Bigtable, built on top of the Hadoop Distributed File System (HDFS). Its architecture is designed for linear scalability and strictly consistent random access, but this comes at the cost of extreme moving-part complexity.[^4]

#### 2.1.1 The RegionServer and HDFS Dependency

In the HBase architecture, data is sharded into "Regions," which are continuous sorted ranges of row keys. These regions are managed by RegionServers. Crucially, the data itself does not reside on the RegionServer's local disk but is stored in HDFS as HFiles.[^5] This separation of compute (RegionServer) and storage (HDFS DataNodes) creates a complex dependency chain. A failure in the underlying HDFS layer—such as a NameNode failover issue or a DataNode disk corruption—immediately impacts the availability of the HBase regions.

For the Suse Observability team, this implies managing two distinct distributed systems: the HBase cluster and the underlying HDFS cluster. The operational overhead includes managing the NameNode High Availability (HA) setup, which involves active/standby nodes, JournalNodes, and Zookeeper Failover Controllers.[^2] The "maintenance issues" likely stem from this sprawling footprint, where debugging a simple "slow query" requires tracing calls through the HBase client, the RegionServer, the HDFS client, the DataNode, and the physical disk I/O.

#### 2.1.2 The "Region Overlap" and Corruption Nightmare

One of the most severe failure modes in HBase is "Region Overlap," a form of meta-data corruption where two different RegionServers believe they are responsible for the same range of row keys.[^10] This violates the core invariant of HBase, leading to data inconsistency and potential data loss.

Repairing such corruption often requires the use of `hbck` (HBaseFsck), a command-line utility that interacts directly with the HBase META table and HDFS region info. As noted in the research, using `hbck` is a high-risk operation that can require cluster downtime.[^11] Operators must manually inspect region boundaries, "hole" lists, and overlap details. For a team maintaining a product like Suse Observability, having to perform such "open-heart surgery" on the production database is a significant liability and a primary motivator for migration.

#### 2.1.3 Garbage Collection and "Stop-the-World" Pauses

HBase RegionServers are massive Java heaps. When handling high write throughput—typical of telemetry and topology updates—the Java Garbage Collector (GC) works intensively. If a "Stop-the-World" GC pause exceeds the ZooKeeper session timeout (typically a few seconds), the HBase Master declares the RegionServer dead.[^12]

This triggers a recovery process: the "dead" server's regions are reassigned to other servers. This involves reading the Write-Ahead Log (WAL) from HDFS and replaying edits. If the cluster is already under load, this rebalancing can cause a cascading failure or "region storm," where load shifts cause further GC pauses on the recipient nodes. ClickHouse, being a C++ based system with manual memory management, entirely eliminates this class of failure, representing a massive operational win.[^13]

### 2.2 Apache Tephra: The Transactional Complexity

A raw NoSQL store like HBase lacks cross-row or cross-region transactions. StackGraph utilizes Apache Tephra to overlay ACID transactions on top of HBase, enabling the consistent topology updates required by the 4T model.[^2]

#### 2.2.1 The Transaction Mechanism

Tephra operates by utilizing a centralized Transaction Manager that dispenses transaction IDs. When StackGraph writes an edge or node to HBase, it does not use the wall-clock time as the version. Instead, Tephra overrides the HBase cell timestamp with the Transaction ID.[^14]

This mechanism is critical for the "Time Travel" feature. It provides Snapshot Isolation. When a user queries the topology at time *T*, Tephra ensures they see a consistent view of the database as it existed at the start of the transaction corresponding to *T*. It filters out data from transactions that were uncommitted or aborted at that time.[^15]

#### 2.2.2 The "Invalid List" and Compaction Overhead

To maintain snapshot isolation, Tephra must track the state of all active and invalid (aborted) transactions. This "invalid list" is transmitted to the HBase RegionServers (via Co-processors) to filter data during reads.[^16]

The research indicates a significant scalability bottleneck here: the exclude list can grow large over time, increasing the RPC overhead for every write and read operation. Furthermore, "pruning" invalid transactions—permanently removing data associated with aborted writes—is a complex process tied to HBase compactions.[^16] If this pruning stalls, storage usage bloats, and scan performance degrades. Migrating to ClickHouse eliminates Tephra, but it also eliminates the mechanism currently used to guarantee consistency. The engineering team must essentially re-implement this consistency model or accept a lower consistency standard.

### 2.3 Operational Maintenance Summary (The "Why")

The current architecture forces the Suse Observability team to function as Hadoop administrators. They must tune JVM heaps, manage Zookeeper quorums, balance HDFS blocks, and run `hbck` repairs. This operational complexity detracts from feature development. The promise of ClickHouse is to collapse this multi-layered stack (HDFS + HBase + Tephra + ZK) into a single, vertically integrated binary that manages its own storage and replication.[^13]

---

## 3. ClickHouse Architecture: The Paradigm Shift

To evaluate the feasibility of the migration, we must contrast the legacy architecture with the proposed future state. ClickHouse is strictly column-oriented, and this fundamental difference dictates both the massive performance gains and the severe engineering challenges awaiting the team.

### 3.1 Columnar Storage Mechanics vs. Graph Access

ClickHouse stores data by column. For a table with columns `(NodeID, Type, Status, Timestamp)`, ClickHouse creates separate data files for `NodeID`, `Type`, etc.[^4]

#### 3.1.1 The Compression Advantage

Because data in a single column is often repetitive (e.g., thousands of nodes with `Status='Running'`), ClickHouse can apply aggressive compression codecs (LZ4, ZSTD, Gorilla for timestamps).[^17] This results in storage efficiency that is often 3x to 10x better than HBase's row-oriented storage.[^12] For Suse Observability, where storing historical topology snapshots can be data-intensive, this is a major strategic advantage, reducing cloud storage costs significantly.

#### 3.1.2 The Tuple Reconstruction Tax

However, graph traversal is inherently row-oriented. To traverse from Node A to Node B, the database must retrieve all properties of Node A (reconstructing the row from multiple column files) to determine the edge to Node B. In a columnar store, reconstructing a single row is expensive because it requires seeking to the correct offset in every column file and decompressing the relevant blocks.

This is the "Impedance Mismatch." HBase is optimized for `Get(RowKey)`, which is the primitive operation of graph traversal. ClickHouse is optimized for `Select Average(Metric)`, which is the primitive of analytics. The migration requires shifting the query pattern from "iterative node hopping" to "set-based processing".[^7]

### 3.2 The Sparse Index vs. Point Lookups

Unlike HBase, which uses a dense index (an entry for every key via the LSM tree), ClickHouse uses a sparse primary index. It stores index entries only for every *N*th row (where *N* is the index granularity, typically 8,192).[^19]

To find a specific `NodeID`, ClickHouse does not look up the exact location. Instead, it finds the "granule" (block of 8,192 rows) that *might* contain the ID, and then it must decompress and scan that entire granule to find the specific record.[^7]

**Implication:** Point lookups in ClickHouse are significantly slower than in HBase. If the StackState application relies on fetching single components by ID with millisecond latency, ClickHouse may fail to meet the Service Level Agreement (SLA) without aggressive caching or the use of specific high-selectivity point-query optimizations.[^7]

### 3.3 Transactional Support and ACID

ClickHouse is Eventually Consistent. While it supports atomic batch inserts (all rows in a batch are written or none are), it lacks the multi-row, cross-table ACID guarantees provided by Tephra.[^20]

#### 3.3.1 The Consistency Gap

In the current Tephra architecture, a complex topology update (e.g., deploying a new microservice involves creating 10 nodes and 20 edges) is wrapped in a transaction. Other users either see the old state or the fully new state.

In ClickHouse, updates are ingested asynchronously. There is no native mechanism to group these 30 inserts into a single atomic "snapshot" visible to readers. A user querying the graph during ingestion might see the nodes before the edges appear. This is a classic distributed systems trade-off: The team is trading strong consistency (HBase/Tephra) for operational simplicity and speed (ClickHouse). The Engineering Manager must determine if "Eventual Consistency" is acceptable for the Suse Observability product.

---

## 4. Engineering the "Time-Travelling Graph" on OLAP

The most significant engineering challenge is not the storage, but the logic. How does one model a 4T (Time-Traveling) graph in a database designed for append-only logs? This section details the specific data modeling techniques required.

### 4.1 Schema Design: The Validity Interval Model

In HBase, "updates" overwrite data (or create new versions managed by Tephra). In ClickHouse, data is immutable. To model a changing graph, we must use an Accumulating Log or Validity Interval pattern.

#### 4.1.1 The Edge Schema Proposal

Instead of storing just the edge, the table must define the period for which the edge is valid.

| Field | Type | Description |
|-------|------|-------------|
| `source_id` | String/UUID | The origin component. |
| `target_id` | String/UUID | The destination component. |
| `relation_type` | LowCardinality(String) | e.g., "calls", "hosted_on". |
| `valid_from` | DateTime64(3) | The timestamp when this relationship appeared. |
| `valid_to` | DateTime64(3) | The timestamp when it disappeared (or NULL/Future if active). |
| `version` | UInt64 | Monotonically increasing version for ordering. |

**Optimization Note:** Using `LowCardinality(String)` for the `relation_type` is crucial. ClickHouse dictionary-encodes these values, making scans over billions of edges extremely fast.[^22]

### 4.2 The "Time Travel" Mechanism: ASOF JOIN

The single most important feature for this migration is the `ASOF JOIN`.[^9] This is the "secret weapon" that makes time-series graphs feasible in ClickHouse.

#### 4.2.1 How ASOF JOIN Replaces Tephra Snapshots

In the legacy system, Tephra filtered rows based on transaction IDs. In ClickHouse, we use wall-clock time. To reconstruct the graph at `2023-10-27 14:00:00`:

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

The `ASOF JOIN` allows ClickHouse to join the edge table with the node table based on the "closest timestamp prior to the target." This efficiently stitches together the state of the topology at that precise moment without requiring a predefined snapshot.

**Risk:** ASOF JOINs are memory intensive. They typically load the right-hand side (the nodes) into a hash map. If the number of nodes is massive (tens of millions), this query could trigger Out-Of-Memory (OOM) errors. The engineering team must verify if the cluster memory is sized correctly for the dataset.[^24]

### 4.3 Recursive Traversals: The CTE Limitation

Graph databases typically support queries like "Find all services downstream of Service A." This requires recursion.

#### 4.3.1 Recursive Common Table Expressions (CTEs)

ClickHouse introduced support for Recursive CTEs in recent versions (v24.x).[^25]

```sql
WITH RECURSIVE dependency_graph AS (
    SELECT source_id, target_id, 1 as depth FROM edges WHERE source_id = 'ServiceA'
    UNION ALL
    SELECT e.source_id, e.target_id, dg.depth + 1
    FROM edges e JOIN dependency_graph dg ON e.source_id = dg.target_id
    WHERE dg.depth < 10
)
SELECT * FROM dependency_graph
```

**The Limitation:** While syntactically supported, ClickHouse's recursive engine is not optimized for deep traversals in the way Neo4j or even HBase coprocessors might be. It effectively performs iterative joins. For a "bushy" graph where the number of connections explodes with depth, this approach will degrade rapidly in performance.

#### 4.3.2 The PuppyGraph Alternative

The research highlights PuppyGraph as a potential solution for this specific gap.[^8] PuppyGraph is a query engine that sits on top of ClickHouse.

- **Zero-ETL:** It does not move data. It queries the ClickHouse tables directly.
- **Graph Logic:** It exposes Gremlin or Cypher interfaces. It handles the complexity of graph traversal logic (BFS/DFS) and translates it into optimized SQL or internal fetches against ClickHouse.
- **Strategic Fit:** Integrating PuppyGraph would effectively turn ClickHouse into the storage engine for a "Virtual Graph Database." This preserves the operational simplicity of ClickHouse (storage/compute) while regaining the graph semantic capabilities lost by leaving HBase.[^26]

### 4.4 Handling Updates and Deletes

In StackGraph, components are deleted. In ClickHouse, data is best left immutable.

#### 4.4.1 The CollapsingMergeTree

One approach is using the `CollapsingMergeTree` engine. This engine uses a `Sign` column (1 for insert, -1 for delete). When the background process merges data parts, rows with matching keys and opposing signs cancel each other out.[^27]

- **Pros:** Efficiently keeps the current state small.
- **Cons:** It physically removes history. This is antithetical to "Time Travel."

**Conclusion:** For a time-travel database, `CollapsingMergeTree` is likely inappropriate. The standard `MergeTree` with a `valid_to` column (Soft Delete) is preferred, even though it requires filtering logic in every query.[^15]

---

## 5. Migration Strategy and Risk Mitigation

Migrating a stateful, mission-critical database is a high-risk operation. The following strategy minimizes downtime and data risks.

### 5.1 The Dual-Write Architecture (Shadow Phase)

The safest path is to run both systems in parallel.

1. **Ingestion Fork:** Update the StackState Receiver/Ingestion pipeline to write incoming topology telemetry to a Kafka topic.[^1]
2. **ClickHouse Consumer:** Deploy a new service (or use ClickHouse's native Kafka Engine) to consume this topic and write to the new ClickHouse cluster.[^29]
3. **Shadow Validation:** This allows the team to compare the "Current State" in HBase vs. ClickHouse in real-time. Any discrepancy indicates a bug in the translation logic or an issue with eventual consistency lag.

### 5.2 Historical Backfill Strategy

Transferring the massive historical dataset from HDFS to ClickHouse is a non-trivial ETL task.

- **Tooling:** Use `clickhouse-local` or a Spark connector.[^3]
- **Direct HDFS Read:** ClickHouse can read Parquet/ORC files directly from HDFS. If the current HBase data can be exported to HDFS files (using HBase Snapshot Export), ClickHouse can ingest them at extremely high throughput (millions of rows per second).[^3]
- **Data Transformation:** The ETL process must convert the Tephra-based timestamps into standard epoch timestamps. This will require logic to resolve the start-time of historical transactions.

### 5.3 Operational Verification

Before decommissioning HBase, the team must verify:

1. **Query Latency:** Benchmark the critical "Time Travel" queries. If an ASOF JOIN takes 5 seconds, and the UI times out in 2 seconds, the migration fails.
2. **Disk Usage:** Confirm the compression ratios. Expectation is 3-10x reduction.
3. **Survivability:** Test node failures. ClickHouse handles replica failure gracefully, but the team must practice the recovery procedures (restoring replicas, checking data consistency).[^30]

---

## 6. Strategic Technical Inquiries & Pros/Cons Analysis

This section directly addresses the Engineering Manager's request for "questions to ask engineers" and the "pros/cons."

### 6.1 Strategic Technical Inquiries (The "Hard" Questions)

Asking the right questions will reveal if the engineering team has fully considered the implications of the "Impedance Mismatch."

#### Group 1: Performance & Data Modeling

1. **"Have we benchmarked the 'Tuple Reconstruction' cost for our specific node property density?"**
   - *Rationale:* ClickHouse is slow at reassembling wide rows. If our nodes have 500 properties, fetching a single node might require 500 disk seeks. We need to know if we should store properties as a single JSON blob (faster read, slower filter) or separate columns.[^22]

2. **"What is the p99 latency of an ASOF JOIN on our largest projected dataset?"**
   - *Rationale:* ASOF JOIN is the linchpin of the time-travel feature. We cannot assume it works at scale; we must prove it. If it fails, the entire migration thesis is invalid.[^9]

3. **"How will we handle 'Read-Your-Writes' consistency for the UI?"**
   - *Rationale:* Tephra guaranteed that if a user updated a node, they saw it immediately. ClickHouse is eventually consistent. Will the UI show a "spinner" or could it show stale data? The engineers need a strategy (e.g., forcing queries to the leader replica).[^21]

#### Group 2: Graph Logic

4. **"Are we planning to implement graph recursion in raw SQL, or are we evaluating overlay tools like PuppyGraph?"**
   - *Rationale:* Writing recursive SQL is error-prone and hard to maintain. An overlay tool might cost money but save huge amounts of developer time.

5. **"How do we handle the 'Deleted Data' problem for Time Travel?"**
   - *Rationale:* We need to ensure that "deleting" a node in the UI doesn't physically remove it from ClickHouse, or we lose the ability to see it in the past. We need a rigorous "Soft Delete" / "Valid To" schema strategy.[^32]

#### Group 3: Operations

6. **"Do we have the expertise to manage ClickHouse Keeper, or should we use ClickHouse Cloud?"**
   - *Rationale:* Replacing ZooKeeper with ClickHouse Keeper is great, but it's still a consensus system. Does the team know how to recover a failed quorum?[^30]

### 6.2 Detailed Pros and Cons

| Feature | HBase / Tephra (Current) | ClickHouse (Target) | Strategic Implication |
|---------|--------------------------|---------------------|----------------------|
| **Operational Model** | High Overhead. Requires managing HDFS (NameNodes, DataNodes), HBase (Masters, RegionServers), Zookeeper, and Tephra. Prone to GC pauses and region corruption. | Low Overhead. Single binary (or Cloud service). No HDFS dependency. No Java GC. Simplifies the stack dramatically. | **Pro for Migration.** Primary driver. Reduces "PagerDuty fatigue." |
| **Query Performance** | Point-Lookup Optimized. Fast for single-row reads (Get). Slow for aggregations (Scan). | Scan Optimized. Blazing fast for analytics/aggregations. Slower for single-row point lookups (Sparse Index). | **Trade-off.** Migration improves analytics but risks slowing down granular graph traversal. |
| **Consistency** | Strong (ACID). Tephra guarantees snapshot isolation. | Eventual. Updates propagate asynchronously. No native multi-row transactions. | **Risk.** Application logic must become robust to eventual consistency. |
| **Time Travel** | Native (via Tephra). Built-in transactional versioning. | Engineered. Requires ASOF JOIN and validity-interval schema design. | **Engineering Cost.** Requires significant dev effort to replicate the feature. |
| **Storage Cost** | High. Row-oriented storage compresses poorly. HDFS replication adds 3x overhead. | Low. Columnar storage with LZ4/ZSTD compresses 3x-10x better. | **Pro for Migration.** Direct reduction in cloud infrastructure bills. |
| **Graph Capabilities** | Low/Manual. Requires coprocessors or client-side logic for traversal. | Low/SQL-based. Recursive CTEs or external tools (PuppyGraph) required. | **Neutral/Risk.** Both require workarounds, but SQL recursion is often less performant than native traversal. |

---

## 7. Conclusion and Recommendation

### 7.1 The Verdict

Migrating from HBase/Tephra to ClickHouse is a strategically sound decision driven by the unsustainable operational cost of the Hadoop ecosystem. The "Maintenance Issues" cited by the team are inherent to the HBase architecture (GC pauses, Region overlaps, HDFS complexity) and will not improve with time. ClickHouse offers a modern, high-performance alternative that aligns with the industry trend toward unified observability backends.

However, the migration is technically perilous. It replaces a storage engine perfectly suited for graphs (Row-Key Access) with one hostile to them (Column-Scan Access).

### 7.2 The Recommendation

The Engineering Manager should authorize the migration, but only contingent on a successful "Graph Capability PoC."

**The PoC must prove:**

1. That the Sparse Index latency for point-lookups is acceptable (or mitigatable via caching).
2. That ASOF JOIN can reconstruct historical graph snapshots within the query timeout limit.
3. That the team has a viable strategy (e.g., PuppyGraph or CTEs) for Recursive Traversal.

If these three technical risks are mitigated, the operational and cost benefits of ClickHouse will be transformative for the Suse Observability platform.

### 7.3 Final Roadmap Step

Start with **Phase 1 (Dual Ingestion)** immediately. This builds the dataset required for the PoC without impacting production, allowing the team to benchmark ClickHouse against live data patterns before committing to the full cutover. This "Shadow IT" approach de-risks the migration while providing immediate visibility into the potential gains.

---

## Works Cited

[^1]: Technical overview, accessed December 8, 2025, https://assets.ctfassets.net/ud9dfq0vudar/37BRx9BHbuhsZ5V6VFkPrD/b542c8c6758de459eed29cbb396acb4b/StackState_Technical_Overview_-_Q1_2021.pdf

[^2]: Advanced Troubleshooting :: Rancher product documentation, accessed December 8, 2025, https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/install-stackstate/advanced-troubleshooting.html

[^3]: Migrating to ClickHouse using clickhouse-local | ClickHouse Docs, accessed December 8, 2025, https://clickhouse.com/docs/cloud/migration/clickhouse-local

[^4]: Overview of HBase Architecture and its Components - ProjectPro, accessed December 8, 2025, https://www.projectpro.io/article/overview-of-hbase-architecture-and-its-components/295

[^5]: Understanding HBase Architecture: A Deep Dive into Its Key Components - Medium, accessed December 8, 2025, https://medium.com/@shantanufuke/understanding-hbase-architecture-a-deep-dive-into-its-key-components-55eb4b38d1e5

[^6]: Architecture Overview | ClickHouse Docs, accessed December 8, 2025, https://clickhouse.com/docs/academic_overview

[^7]: Why can HBase perform fast point queries while ClickHouse is not suitable - Stack Overflow, accessed December 8, 2025, https://stackoverflow.com/questions/78439650/why-can-hbase-perform-fast-point-queries-while-clickhouse-is-not-suitable

[^8]: Fast Analytics and Connected Insights: Graph Analytics on ClickHouse with PuppyGraph, accessed December 8, 2025, https://www.puppygraph.com/blog/graph-analytics-on-clickhouse-with-puppygraph

[^9]: Master ASOF Join: Step-by-Step Implementation Guide - Initial Data Offering, accessed December 8, 2025, https://initialdataoffering.com/blog/master-asof-join-step-by-step-implementation-guide/

[^10]: US20130282668A1 - Automatic repair of corrupt hbases - Google Patents, accessed December 8, 2025, https://patents.google.com/patent/US20130282668A1/en

[^11]: Appendix C. hbck In Depth - DevDoc, accessed December 8, 2025, https://www.devdoc.net/bigdata/hbase-0.98.7-hadoop1/book/hbck.in.depth.html

[^12]: ClickHouse is in the house | by Zeev Feldbeine | Vimeo Engineering Blog - Medium, accessed December 8, 2025, https://medium.com/vimeo-engineering-blog/clickhouse-is-in-the-house-413862c8ac28

[^13]: ClickHouse vs Apache Pinot — which is easier to maintain? (self-hosted) - Reddit, accessed December 8, 2025, https://www.reddit.com/r/dataengineering/comments/1mrlw9e/clickhouse_vs_apache_pinot_which_is_easier_to/

[^14]: Getting Started - Apache Tephra, accessed December 8, 2025, https://tephra.apache.org/GettingStarted.html

[^15]: cdapio/tephra: Apache Tephra: Transactions for HBase. - GitHub, accessed December 8, 2025, https://github.com/cdapio/tephra

[^16]: Transaction in HBase - ApacheCon Big Data 2017 - Linux Foundation Events, accessed December 8, 2025, http://events17.linuxfoundation.org/sites/events/files/slides/Transaction%20in%20HBase%20-%20ApacheCon%20Big%20Data%202017.pdf

[^17]: Working with Time Series Data in ClickHouse, accessed December 8, 2025, https://clickhouse.com/blog/working-with-time-series-data-and-functions-ClickHouse

[^18]: ClickHouse vs. Apache Druid: A Detailed Comparison - CelerData, accessed December 8, 2025, https://celerdata.com/glossary/clickhouse-vs-apache-druid

[^19]: The definitive guide to ClickHouse query optimization (2026) | Engineering, accessed December 8, 2025, https://clickhouse.com/resources/engineering/clickhouse-query-optimisation-definitive-guide

[^20]: Honest guide to the best ClickHouse® alternatives in 2025 - Tinybird, accessed December 8, 2025, https://www.tinybird.co/blog/clickhouse-alternatives

[^21]: Transactional (ACID) support | ClickHouse Docs, accessed December 8, 2025, https://clickhouse.com/docs/guides/developer/transactional

[^22]: Schema Design | ClickHouse Docs, accessed December 8, 2025, https://clickhouse.com/docs/data-modeling/schema-design

[^23]: JOIN Clause | ClickHouse Docs, accessed December 8, 2025, https://clickhouse.com/docs/sql-reference/statements/select/join

[^24]: ClickHouse JOINs Explained: Types, Examples & Best Practices - GlassFlow, accessed December 8, 2025, https://www.glassflow.dev/blog/clickhouse-joins

[^25]: ClickHouse Release 24.4, accessed December 8, 2025, https://clickhouse.com/blog/clickhouse-release-24-04

[^26]: 5 Best Graph Database Tools in 2025 - PuppyGraph, accessed December 8, 2025, https://www.puppygraph.com/blog/graph-database-tools

[^27]: Exact and Approximate Vector Search | ClickHouse Docs, accessed December 8, 2025, https://clickhouse.com/docs/engines/table-engines/mergetree-family/annindexes

[^28]: StackState architecture | StackState v5.1 | SUSE Observability, accessed December 8, 2025, https://archivedocs.stackstate.com/5.1/use/concepts/stackstate_architecture

[^29]: How to optimize ClickHouse® for high-throughput streaming analytics - Tinybird, accessed December 8, 2025, https://www.tinybird.co/blog/clickhouse-streaming-analytics

[^30]: A guide to ClickHouse® upgrades and best practices - Instaclustr, accessed December 8, 2025, https://www.instaclustr.com/blog/a-guide-to-clickhouse-upgrades-and-best-practices/

[^31]: Structured, unstructured, and semi-structured data | Engineering | ClickHouse Resource Hub, accessed December 8, 2025, https://clickhouse.com/resources/engineering/structured-unstructured-semi-structured-data

[^32]: Managing data | ClickHouse Docs, accessed December 8, 2025, https://clickhouse.com/docs/observability/managing-data

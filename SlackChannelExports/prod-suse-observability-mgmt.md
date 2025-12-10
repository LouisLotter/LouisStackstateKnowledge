# Slack Channel: #prod-suse-observability-mgmt

Exported conversations for search and reference.

---

**Sheng Yang** (2024-09-11 22:55):
Hey, I create this channel for internal product related discussion on Observability/StackState between engineering team and product team.

---

**Sheng Yang** (2024-09-11 22:58):
has renamed the channel from "prod-observability-mgmt" to "prod-stackstate-mgmt"

---

**Sheng Yang** (2024-09-11 23:00):
@Mark Bakker In the weekly PM sync up call I remember you mentioned we’ve released 60-day release. Are we planning to announce it somewhere or we’ve already done so? I cannot find the announcement. I’ve checked <#C079ANFDS2C|> <#C078Y1ED03E|>. I probably missed some other channels.

---

**Mark Bakker** (2024-09-12 07:19):
Hi I will do that this morning. The reason for that is that is was finished late yesterday and I want engineers to be available if there is anything which is not 100% correct.

---

**Sheng Yang** (2024-11-14 02:05):
@Mark Bakker any update on getting me the access to Posthog? And how is KubeCon?

---

**Louis Lotter** (2024-11-14 07:43):
I'm not at Kubecon. Mark says they are having fun though.

---

**Mark Bakker** (2024-11-14 14:39):
I see the Posthog access is in progress @Louis Lotter thanks!
KubeCon is good, lots of interest around observability, also had some interactions around security.
Also attend quite some sessions around security will send an summary after KubeCon

---

**Sheng Yang** (2025-02-21 17:46):
has renamed the channel from "prod-stackstate-mgmt" to "prod-suse-observability-mgmt"

---

**Louis Lotter** (2025-03-05 11:19):
This weeks update:
• In progress: Fine grained role based access supporting project/ namespace level access
• In progress: Dashboarding
• In Progress: ARM Architecture Build agents
• In Progress: data-agent-for-process-agent datadog upstream merge
• In Progress: Performance improvements for health state over time.
• Paused: support for operator to install SUSE Observability as an app
    ◦ In progress: Operator for Clickhouse
    ◦ Next up: all other operators
• In progress: Support for more protocols
    ◦ PostgreSQL

---

**Louis Lotter** (2025-03-11 15:08):
This weeks update:
• Team reforming completed. Team Borg led by @Remco Beckers and Team Marvin led by @Bram Schuur
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In progress: Dogfooding
• Team Marvin:
    ◦ In progress: Fine grained role based access supporting project/ namespace level access
    ◦ In Progress: ARM Architecture Build agents
    ◦ In Progress: data-agent-for-process-agent datadog upstream merge
    ◦ Completed: Performance improvements for health state over time.

---

**Louis Lotter** (2025-03-19 16:56):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In progress: Dogfooding
• Team Marvin:
    ◦ In progress: Fine grained role based access supporting project/ namespace level access
    ◦ In Progress: Support ARM architecture in the agent
    ◦ In Progress: data-agent-for-process-agent datadog upstream merge
    ◦ In Progress: Suse Observability Release v2.3.1

---

**Louis Lotter** (2025-04-01 13:47):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In progress: Migration of workloads from GCP to AWS
    ◦ In progress: Open Telemetry documentation improvements.
    ◦ In progress: Test SUSE Observability on Rancher v2.11 pre-release
    ◦ Design and refinement: Simplify integration with other products
• Team Marvin:
    ◦ In progress: Fine grained role based access supporting project/ namespace level access
    ◦ In Progress: Support ARM architecture in the agent
    ◦ In Progress: Postgres rate/errors/duration (RED) metrics
    ◦ Completed : data-agent-for-process-agent datadog upstream merge
    ◦ Completed: Suse Observability Release v2.3.1

---

**Louis Lotter** (2025-04-01 14:54):
Oh and we are almost done with the React 18 Upgrade

---

**Louis Lotter** (2025-04-08 16:31):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In progress: Migration of workloads from GCP to AWS
    ◦ In progress: Open Telemetry documentation improvements.
    ◦ In progress: Test SUSE Observability on Rancher v2.11 pre-release
    ◦ Final Testing: React 18 Upgrade.
    ◦ Next Up: Simplify integration with other products
• Team Marvin:
    ◦ In progress: Fine grained role based access supporting project/ namespace level access 
        ▪︎ Trace Scopes
    ◦ In Progress: Support ARM architecture in the agent
    ◦ In Progress: Postgres rate/errors/duration (RED) metrics

---

**Louis Lotter** (2025-04-22 14:10):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In progress: Migration of workloads from GCP to AWS
    ◦ In progress: Bugfixes for  Suse Observability Release v2.3.2 
    ◦ In Progress: Simplify integration with other products
    ◦ Completed: Open Telemetry documentation improvements.
    ◦ Blocked: Test SUSE Observability on Rancher v2.11 pre-release
    ◦ Completed: React 18 Upgrade.
• Team Marvin:
    ◦ In progress: Fine grained role based access supporting project/ namespace level access
        ▪︎ Support PKCE OIDC Authentication
    ◦ In Progress: Support ARM architecture in the agent
    ◦ In Progress: Postgres rate/errors/duration (RED) metrics
    ◦ Completed: Chain Monitoring use case.

---

**Louis Lotter** (2025-04-30 10:10):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In progress: Improve Open Telemetry support
    ◦ In Progress: Simplify integration with other products
    ◦ In Progress: Java 11-&gt; 21 Upgrade
    ◦ Completed: Migration of workloads from GCP to AWS
    ◦ Completed: Suse Observability Release v2.3.2
• Team Marvin:
    ◦ In progress: Fine grained role based access supporting project/ namespace level access
        ▪︎ Support PKCE OIDC Authentication
    ◦ In Progress: Support ARM architecture in the agent
    ◦ In Progress: Alibaba ACK support for SUSE Observability Platform + Agent
    ◦ In Progress: Postgres rate/errors/duration (RED) metrics

---

**Louis Lotter** (2025-05-07 15:05):
*Louis Lotter*  [10:10 AM]
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In progress: Improve Open Telemetry support
    ◦ In Progress: Stackpacks 2 .0
    ◦ In Progress: Java 11-&gt; 21 Upgrade
• Team Marvin:
    ◦ In progress: Fine grained role based access supporting project/ namespace level access
        ▪︎ Prepare rancher preprod setup for rbac setup
    ◦ Almost Done: Support ARM architecture in the agent
    ◦ In Progress: Alibaba ACK support for SUSE Observability Platform + Agent
    ◦ In Progress: Postgres rate/errors/duration (RED) metrics
    ◦ In Progress: [Release] Suse Observability Release v2.3.3

---

**Louis Lotter** (2025-05-13 14:38):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In progress: Improve Open Telemetry support
    ◦ In Progress: Stackpacks 2 .0
    ◦ In Progress: Java 11-&gt; 21 Upgrade
• Team Marvin:
    ◦ In progress: Fine grained role based access supporting project/ namespace level access
        ▪︎ Create RoleTemplates for Suse Observability roles
    ◦ In Progress: Postgres rate/errors/duration (RED) metrics
    ◦ In Progress: Support ARM architecture in the agent
    ◦ Done: Alibaba ACK support for SUSE Observability Platform + Agent
        ▪︎ Deployment successful on ACK with some PVC overrides
    ◦ Completed: [Release] Suse Observability Release v2.3.3

---

**Louis Lotter** (2025-05-28 13:26):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
        ▪︎  Add/edit timeseries widget &amp; Organize widgets
    ◦ In Progress: Stackpacks 2 .0
        ▪︎ Remove Groovy from StackPacks install
    ◦ In Progress: Java 11-&gt; 21 Upgrade
    ◦ Completed: Improve Open Telemetry support
• Team Marvin:
    ◦ In progress: Fine grained role based access supporting project/ namespace level access
        ▪︎ Document Rancher/Kubernetes Authorization
    ◦ In Progress:  Suse Observability Release v2.3.4
    ◦ In Progress: Platform Readiness
        ▪︎ Remove componenttypes, relationtypes from the globalstore
    ◦ In Progress: Revisit connection correlation/tracing design for Suse Security
    ◦ Customer Testing and Documentation: Support ARM architecture in the agent
        ▪︎ ] arm64 agent e2e testing and feature parity
    ◦ Completed: Postgres rate/errors/duration (RED) metrics

---

**Sheng Yang** (2025-05-28 19:49):
Demo is great. One question regarding RBAC Agent in the demo. Is it necessary to have the explicit option there or it should be installed by default? In another word, what is the use case of not deploying RBAC agent when using with Kubernetes and Rancher?

---

**Mark Bakker** (2025-05-29 08:37):
It should be on by default, but only after delivering the public version. Everything is now still behind feature flags

---

**Louis Lotter** (2025-06-18 12:25):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In Progress: Stackpacks 2 .0
        ▪︎ Review and QA:
            • Remove Groovy from StackPacks install
            • Limit supported features
    ◦ In Progress: Java 11-&gt; 21 Upgrade
    ◦ In Prorgess: Suse Observability Release v2.3.5
• Team Marvin:
    ◦ In progress: Fine grained role based access supporting project/ namespace level access
        ▪︎ Support API keys with restricted scope
        ▪︎ Deprecate obsolete permissions
    ◦ In Testing: Platform Readiness
        ▪︎ Remove componenttypes, relationtypes from the globalstore
    ◦ In Progress: Revisit connection correlation/tracing design for Suse Security
    ◦ Customer Testing : Support ARM architecture in the agent
    ◦ Completed:  Suse Observability Release v2.3.4

---

**Louis Lotter** (2025-06-25 09:03):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In Progress: Stackpacks 2 .0
        ▪︎ In Progress:
            • Domain mode Feature flagging
        ▪︎ Review and QA:
            • Remove Groovy from StackPacks install
        ▪︎ Done:
            • Limit supported features
    ◦ In Progress: Java 11-&gt; 21 Upgrade
    ◦ Done : Suse Observability Release v2.3.5
• Team Marvin:
    ◦ In progress: Fine grained role based access supporting project/ namespace level access
        ▪︎ Support API keys with restricted scope
        ▪︎ Documentation
        ▪︎ Comprehensive RBAC test.
    ◦ 
    ◦ In Progress: Revisit connection correlation/tracing design for Suse Security
        ▪︎ Done: Platform Readiness
            • Remove componenttypes, relationtypes from the globalstore
    ◦ Done: Support ARM architecture in the agent

---

**Sheng Yang** (2025-07-01 18:16):
@Mark Bakker Are we doing/planning anything on the AI front for observability? It’s getting hot those days and there are pushing for it.

---

**Mark Bakker** (2025-07-01 20:47):
We are but we're first focussed on the ECM integration and after we will for sure focus on it. It's one of the epics directly after the current in progress once's. Would love to be faster to be fair :slightly_smiling_face:

---

**Louis Lotter** (2025-07-02 09:29):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In Progress: Stackpacks 2 .0
        ▪︎ In Progress:
            • Domain Model for components and relations
        ▪︎ Done:
            • Remove Groovy from StackPacks install
    ◦ In Progress: Java 11-> 21 Upgrade|
    ◦ CAB approval pending: DNS changes to point docs.stackstate.com (http://docs.stackstate.com) to Suse docsite
    ◦ Migrate from Artifactory to Suse Private Registry.
• Team Marvin:
    ◦ RBAC
        ▪︎ In progress: 
            • Run through RBAC demo with interested parties.
            • Testing.
            • Create agent service token from the stackpack install page.
            • User should be able to list all of their permissions using the sts-cli.
        ▪︎ Done: 
            • Support API keys with restricted scope
            • Fine grained role based access supporting project/ namespace level access
            • Documentation
    ◦ In Progress: Revisit connection correlation/tracing design for Suse Security
    ◦ In Progress: Bosch scalability investigation and support.

---

**Louis Lotter** (2025-07-09 14:19):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In Progress: Stackpacks 2 .0
    ◦ Ready to Merge: Java 11-&gt; 21 Upgrade.
    ◦ Completed: Change docs.stackstate.com (http://docs.stackstate.com) to Suse docsite
    ◦ In progress. Migrate from Artifactory to Suse Private Registry.
• Team Marvin:
    ◦ RBAC
        ▪︎ In progress:
            • Run through RBAC demo with interested parties.
        ▪︎ Done:
            • Testing.
            • Create agent service token from the stackpack install page.
            • User should be able to list all of their permissions using the sts-cli.
    ◦ In Progress: Stackpacks 2 .0
    ◦ In Progress: Revisit connection correlation/tracing design for Suse Security
    ◦ In Progress: Bosch scalability investigation and support.
    ◦ In Prgoress: Rabobank -&gt; Improve Stackgraph backup and restore perormance. (3* speedup already achieved)

---

**Louis Lotter** (2025-07-23 09:30):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In Progress: Stackpacks 2 .0
    ◦ In Progress: Java 11-&gt; 21 Upgrade.
    ◦ In Progress: Support "rancher-privileged" or "rancher-restricted" PodSecurity
    ◦ In Progress: Support self-signed certificates
    ◦ Done. Migrate from Artifactory to Suse Private Registry.
• Team Marvin:
    ◦ RBAC
        ▪︎ In progress:
            • Make service-token based install more fool-proof
        ▪︎ Done:
            • Run through RBAC demo with interested parties.
    ◦ In Progress:  In-node correlation 
    ◦ In Progress: [Release] Suse Observability Release v2.3.6 Target date  21 July 2025
    ◦ In Progress: Bosch scalability investigation and support.
    ◦ Done: Rabobank -&gt; Improve Stackgraph backup and restore perormance. (3* speedup already achieved)
    ◦ Done: Revisit connection correlation/tracing design for Suse Security

---

**Louis Lotter** (2025-07-30 10:08):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology)
    ◦ In Progress: Support "rancher-privileged" or "rancher-restricted" PodSecurity
    ◦ Testing: Support self-signed certificates
    ◦ Done: Java 11-> 21 Upgrade.
• Team Marvin:
    ◦ In Progress: Rabobank support and agent integration upgrades.
    ◦ In Progress:  In-node correlation (Suse Security collaboration)
    ◦ In Progress: Stackpacks 2.0 (Otel Topology API)
    ◦ In Progress: Bosch scalability investigation and support.
    ◦ Done: [Release] Suse Observability Release v2.3.6 Target date  21 July 2025
    ◦ Testing/Release process: RBAC -> Release must be coordinated with Rancher 2.12 release - Testing against the 2,12 pre-release atm.

---

**Louis Lotter** (2025-08-13 09:59):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology)
    ◦ Done: Support "rancher-privileged" or "rancher-restricted" PodSecurity
    ◦ Done: Support self-signed certificates
• Team Marvin:
    ◦ In Progress: Rabobank support and agent integration upgrades.
    ◦ In Progress: In-node correlation (Suse Security collaboration)
    ◦ In Progress: Bosch scalability investigation and support.
    ◦ In Progress: Remove Rancher extension requirement to use SUSE Observability with TLS ingress
    ◦ In Progress: [Release] Suse Observability Release v2.3.8 Target date  18 August 2025 (Higher risk due to Java upgrade)
    ◦ Testing/Release process: RBAC -&gt; Release must be coordinated with Rancher 2.12 release - Testing against the 2,12 pre-release atm.
        ▪︎  Contact and cooperate with itpe-team to be customer 0 and test the functionality

---

**Louis Lotter** (2025-08-27 14:11):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) - 
        ▪︎ Create OpenTelemetry connector
        ▪︎ Read Otel(Component/relation)Mapping settings in Collector
        ▪︎ Add support for CEL expression evaluation
        ▪︎ Make it easy to work on a stackpack
• Team Marvin:
    ◦ In Progress: Rabobank support and agent integration upgrades.
        ▪︎ Support rabobank moving to suse observability agent
    ◦ In Progress: In-node correlation (Suse Security collaboration)
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) - Protocols
    ◦ In Progress: Bosch scalability investigation and support.
    ◦ Testing/Release process still ongoing: RBAC -&gt; Release must be coordinated with Rancher 2.12 release - Testing against the 2,12 pre-release atm.
        ▪︎  Contact and cooperate with itpe-team to be customer 0 and test the functionality
    ◦ Done: [Release] Suse Observability Release v2.4 Target date  18 August 2025 (Higher risk due to Java upgrade)
    ◦ Done: Remove Rancher extension requirement to use SUSE Observability with TLS ingress
•

---

**Louis Lotter** (2025-09-10 11:37):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
        ▪︎ Stat Widget
        ▪︎ Gauge Widget
        ▪︎ Drawer for dashboard variables
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) -
        ▪︎ Create OpenTelemetry connector (Almost done)
        ▪︎ Add support to merge a subset of attributes
        ▪︎ Make it easy to work on a stackpack
    ◦ In Progress: Fix elasticsearch and Victoriametris backup restore at Rabobank
    ◦ Done: Stackpacks 2 .0 (OTEL Topology) 
        ▪︎ Add support for CEL expression evaluation
        ▪︎ Read Otel(Component/relation)Mapping settings in Collector
• 
• Team Marvin:
    ◦ In Progress: Rabobank support and agent integration upgrades.
        ▪︎ Support rabobank moving to suse observability agent
        ▪︎ Converting more monitors away from Groovy for performance.
    ◦ In Progress: In-node correlation (Suse Security collaboration)
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) - Protocols
    ◦ In Progress: Fix Tephra Data corruption on non HA setups.
    ◦ In Progress: Bosch scalability investigation and support.
        ▪︎ Major improvements made. Bosch will start scaling up further
    ◦ Done: RBAC
    ◦ Done: [[Release][RBAC] Suse Observability Release v2.5.0

---

**Louis Lotter** (2025-09-17 11:03):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
        ▪︎ Stat Widget
        ▪︎ Drawer for dashboard variables
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) -
        ▪︎ Validate Mapping expressions
        ▪︎ Make it easy to work on a stackpack
    ◦ Merging : Stackpacks 2 .0 (OTEL Topology) -
                ◦ Create OpenTelemetry connector.
    ◦ Done: Stackpacks 2 .0 (OTEL Topology) 
        ▪︎ Add support to merge a subset of attributes
        ▪︎ Add support for string interpolation
    ◦ Done : Dashboarding
            • Gauge Widget
    ◦ Done: Fix elasticsearch and Victoriametris backup restore at Rabobank
• Team Marvin:
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) 
        ▪︎ Implement CLI command infrastructure
    ◦ In Progress: In-node correlation (Suse Security collaboration)
    ◦ In Progress: Rabobank support and agent integration upgrades.
        ▪︎ Support rabobank moving to suse observability agent
    ◦ In Progress: Agent: Update main agent to latest datadog tag
    ◦ In progress: [QA] Add rancher on automation tools to validate extension/rancher/stackstate
    ◦ In Progress: Bosch scalability investigation and support.
        ▪︎ Major improvements made. Bosch will start scaling up further
    ◦ Done: Fix Tephra Data corruption on non HA setups.
    ◦ Done: Stackpacks 2 .0 (OTEL Topology) - Protocols

---

**Sheng Yang** (2025-09-30 21:03):
Here is the summary we’re going to communicate to the security team. Let me know if you have any questions @Louis Lotter @Mark Bakker
https://docs.google.com/document/d/1x-N1LRqdUIGWUUF9dqgyOH5TG0mLMKiv4tOdLw3ccUw/edit?usp=sharing

---

**Louis Lotter** (2025-10-01 13:40):
I made some comments. We can discuss them later today if you want.

---

**Louis Lotter** (2025-10-01 13:56):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
        ▪︎ Form for adding static list variable
        ▪︎ Selecting variables on the dashboard
        ▪︎ Virtualize widgets
        ▪︎ Connect refetch to widgets
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) -
        ▪︎ Cross-component feature flag(s) to enable/disable StackPacks 2.0
    ◦ In Progress: Create redirects from stackstate.com (http://stackstate.com) to suse.com (http://suse.com)
    ◦ Done: Stackpacks 2 .0 (OTEL Topology)
        ▪︎ Validate Otel*Mapping expressions when storing
        ▪︎ Create OpenTelemetry connector.
        ▪︎ Validate Mapping expressions
        ▪︎ Make it easy to work on a stackpack

    ◦ Done : Dashboarding
                ◦ Stat Widget
                ◦ Drawer for dashboard variables

• Team Marvin:
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology)
        ▪︎ Implement CLI command infrastructure
        ▪︎ Remove waiting for sync deletion.
    ◦ In Progress: Rabobank support and agent integration upgrades.
        ▪︎ Investigate  data corruption at RaboBank
            • bug found in Tephra. fix in progress.
        ▪︎ Support rabobank moving to suse observability agent
        ▪︎ Sync POD  high processing time monitor improvements
    ◦ In Progress: Work on top OS and non-OS agent CVEs
    ◦ In Progress: Agent: Update main agent to latest datadog tag
    ◦ In progress: [QA] Add rancher on automation tools to validate extension/rancher/stackstate
    ◦ In Progress: Bosch scalability investigation and support.
        ▪︎ Bosch is expanding their testing. Waiting for more feedback.
        ▪︎ Agent AMQP improvments.
    ◦ Done: (Stackpacks 2 .0 )Drop RocksDb from topoSync
    ◦ Done: Suse Observability Release v2.6.0
    ◦ Done: In-node correlation (Suse Security collaboration)

---

**Louis Lotter** (2025-10-08 17:30):
This weeks update:
• Team Borg:

    ◦ In progress: Dashboarding
        ▪︎ Suggestions for metric labels in the metrics legend/alias selection
        ▪︎ Selecting variables on the dashboard
    ◦ In Progress:[POC] Elasticsearch backup restore using a single command
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) -
        ▪︎ Loose ends on collector/topology protocol integration
        ▪︎ Migrate hardcoded conversion of OTEL data
        ▪︎ Cross-component feature flag(s) to enable/disable StackPacks 2.0
    ◦ Done: Create redirects from stackstate.com (http://stackstate.com) to suse.com (http://suse.com)
    ◦ Done: Stackpacks 2 .0 (OTEL Topology
    ◦ Done : Dashboarding
        ▪︎ Form for adding static list variable
        ▪︎ Virtualize widgets
        ▪︎ Connect refetch to widgets
• Team Marvin:
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology)
        ▪︎ Implement CLI command infrastructure
    ◦ In Progress: Work on top OS and non-OS agent CVEs
    ◦ In Progress: Create materialized topology exporter as a drop-in replacement for the kafka exporter
    ◦ In Progress: Investigate Process enforcer
    ◦ In Progress: Rabobank support and agent integration upgrades.
        ▪︎ Support rabobank moving to suse observability agent
        ▪︎ Monitor Health timeline only shown partially
    ◦ In progress: [QA] Add rancher on automation tools to validate extension/rancher/stackstate
    ◦ Done: Bosch scalability investigation and support.
    ◦ Done: Investigate data corruption at RaboBank, Fix will be part of the next release
    ◦ Done: Sync POD  high processing time monitor improvements

---

**Louis Lotter** (2025-10-22 13:49):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
        ▪︎ [Dashboards] Interpolating variables in the widgets
        ▪︎ [Dashboards] Markdown widget
    ◦ In Progress:[POC] Elasticsearch backup restore using a single command
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) -
        ▪︎ Implement removal of components / relations when Otel(Component/Relation)Mapping is removed
        ▪︎ Extend the TracesToTopo connector to also support MetricsToTopo
    ◦ StackGraph backup restore single cli comand
    ◦ Done : Dashboarding
            • Suggestions for metric labels in the metrics legend/alias selection
            • Selecting variables on the dashboard
    ◦ Done: Make rancher preprod use self-signed certificate
    ◦ Done: Stackpacks 2.0
            • Loose ends on collector/topology protocol integration
            • Migrate hardcoded conversion of OTEL data
            • Cross-component feature flag(s) to enable/disable StackPacks 2.0
• Team Marvin:
    ◦ In Progress: Stackpacks 2 .0
        ▪︎ Auto-install common stackpack
    ◦ In Progress: Update main agent to latest Datadog tag [7.71.2]
    ◦ In Progress: [Process Enforcer]:
        ▪︎ Runtime enforcer: investigate merging several policy proposals into one applied policy
        ▪︎ Investigate options for making the process enforcer scale to big clusters and many worloads.
    ◦ In Progress: Add Suse Observability platform and agent images to rancher security scan repository
    ◦ In progress: [QA] Add rancher on automation tools to validate extension/rancher/stackstate
    ◦ Almost Done: 
        ▪︎ Support rabobank moving to suse observability agent
        ▪︎ Monitor Health timeline only shown partially
    ◦ Done:Stackpacks 2.0, Implement CLI command infrastructure
    ◦ Done: Investigate Process enforcer
    ◦ Done: In Progress: Create materialized topology exporter as a drop-in replacement for the kafka exporter
    ◦ Done: In Progress: Work on top OS and non-OS agent CVEs

---

**Louis Lotter** (2025-10-29 14:52):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
        ▪︎ [Dashboards] Interpolating variables in the widgets
        ▪︎ Warn user when (accidentally) closing variables or widget edit drawers
    ◦ In Progress: StackGraph backup restore single cli comand
    ◦ In Progress: Fix Kafka and Clickhous Docker image builds.
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) -
        ▪︎ Performance improvements for component mapping by skipping steps when possible
    ◦ Done : Dashboarding
        ▪︎ [Dashboards] Markdown widget
        ▪︎ Lots of smaller tickets. Dashboarding is close to a demo-state now. Will share a big update on friday.
    ◦ Done: Elasticsearch backup restore using a single command
    ◦ Done: Stackpacks 2.0
        ▪︎ Extend the TracesToTopo connector to also support MetricsToTopo
        ▪︎ Implement removal of components / relations when Otel(Component/Relation)Mapping is removed
• Team Marvin:
    ◦ In Progress: Stackpacks 2 .0
        ▪︎ Support stackpack.yaml (i.e. YAML) instead of stackpack.conf (i.e. HOCON)
    ◦ In Progress: Update main agent to latest Datadog tag [7.71.2]
    ◦ In Progress: Investigate a new instance of data corruption at Rabobank
    ◦ In Progress: [Process Enforcer]:
        ▪︎ As a user I want to generate a Policy out from a PolicyProposal when I apply a label to the proposal
        ▪︎ Investigate options for making the process enforcer scale to big clusters and many worloads.
    ◦ In Progress: Add Suse Observability platform and agent images to rancher security scan repository
    ◦ In progress: [QA] Add rancher on automation tools to validate extension/rancher/stackstate
    ◦  Done:
        ▪︎ Support rabobank moving to suse observability agent
        ▪︎ Monitor Health timeline only shown partially
    ◦ Done 
        ▪︎ Auto-install common stackpack

---

**Louis Lotter** (2025-11-05 12:59):
This weeks update:
• Team Borg:
    ◦ In progress: Dashboarding
        ▪︎ Warn user when (accidentally) closing variables or widget edit drawers
        ▪︎ QA: Going through Variable user story and Validate Dynamic list variable selection
        ▪︎ [Dashboards] Toast messages need to be more obvious
    ◦ *In Progress: Stackgraph Data Corruption:*
        ▪︎ *Implement node cycling on preprod cluster*
        ▪︎ *Create chaos clusters for perpetual and manual chaos/stress testing*
    ◦ In Progress: Fix Kafka and Clickhouse Docker image builds.
    ◦ In Progress: VictoriaMetrics backup restore single cli command
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) -
        ▪︎ Performance improvements for component mapping by skipping steps when possible
    ◦ Done : Dashboarding
        ▪︎ [Dashboards] Interpolating variables in the widgets
        ▪︎ [Dashboards] Allow editing copy/paste of full Dashboard specification
        ▪︎ [Dashboards] Big chart-set widgets break drawers
    ◦ Done: 
        ▪︎ [Timeboxed + recurring] Fix biggest impact non-os platform CVEs
        ▪︎  StackGraph backup restore single cli comand
• Team Marvin:
    ◦ In Progress: Stackpacks 2 .0
        ▪︎ Update the community and prime stackpacks to use the new stackpack.yaml and be a stackpack 2.0
    ◦ In Progress: Update main agent to latest Datadog tag [7.71.2]
    ◦ *In Progress: Stackgraph Data Corruption:*
        ▪︎ Data corruption at rabobank
        ▪︎ Extract and summarize metadata information in the support package
    ◦ In Progress: [Process Enforcer]:
        ▪︎ As a user I want to generate a Policy out from a PolicyProposal when I apply a label to the proposal
        ▪︎ Investigate options for making the process enforcer scale to big clusters and many worloads.
    ◦ In Progress: Add Suse Observability platform and agent images to rancher security scan repository
    ◦ In progress: [QA] Add rancher on automation tools to validate extension/rancher/stackstate
    ◦  Done: [Release] Suse Observability Release v2.6.2 Target date 03 November 2025
    ◦ Done: Improve error reporting and troubleshooting docs for the rancher extension
    ◦ Done: Stackpacks 2.0 : Support stackpack.yaml (i.e. YAML) instead of stackpack.conf (i.e. HOCON)

---

**Louis Lotter** (2025-11-05 13:01):
Please note that we've had too many customer cases of Data corruption at customers. We have already found and fixed some causes but it is still happening so the team's primary focus is now to improve our error reporting and test enviroments to simulate the conditions where this happens at customers so we can find the root cause and get it fixed.

---

**Sheng Yang** (2025-11-05 16:46):
Sounds good. The stability is the biggest factor to retain the current customers.

---

**Louis Lotter** (2025-11-12 13:04):
A quick note before I give the days update. Renewing Gitlab has been really tough as @Gary Fentiman and the security and privacy teams are pushing from one side and Gitlab from the other side. @Sheng Yang we can discuss it tonight.
But what this means is that we may be left with no gitlab access next week until it's resolved.
@Karthik Prabakaran and @Gary Fentiman are trying to help me so it's not that I'm stuck it's more that the process started late as I did not know it was required and @Gary Fentiman only became part of the process because @Monika Bach went on holiday....
Probably my fault for not involving Gary from the beginning. Won't make that mistake again.

---

**Louis Lotter** (2025-11-12 13:04):
Gitlab is also being very unhelpful as I think they see as small fish not worth putting effort into...

---

**Louis Lotter** (2025-11-12 13:24):
This weeks updated:
• Team Borg:
    ◦ In progress: Dashboarding
        ▪︎ Bar Chart: Y-Axis labels unreadable/overlapping with min step configuration
        ▪︎ [Dashboards] Warn user when (accidentally) closing variables or widget edit drawers
        ▪︎ [Dashboards] Toast messages need to be more obvious
    ◦ *In Progress: Stackgraph Data Corruption:*
        ▪︎ Manual test failure scenarios
    ◦ In Progress: Bug: Release 2.6.2 shipped with internal, draft, Open Telemetry 2 stackpack
    ◦ In Progress: Fix Kafka and Clickhouse Docker image builds.
    ◦ In Progress: Stackpacks 2 .0 (OTEL Topology) -
        ▪︎ Add support for other otel fields (like span.name) and metric.name
    ◦ Done:
        ▪︎ 15 Dashboarding tickets Done and 4 more in Review. Check the Borg jira wall for details
        ▪︎ Stackpacks 2.0: Performance improvements for component mapping by skipping steps when possible
        ▪︎ Fix biggest impact non-os platform CVEs
        ▪︎ QA: Going through Variable user story and Validate Dynamic list variable selection
        ▪︎ Data Corruption:
            • *Implement node cycling on preprod cluster*
            • *Create chaos clusters for perpetual and manual chaos/stress testing*
• Team Marvin:
    ◦ In Progress: Update main agent to latest Datadog tag [7.71.2]
    ◦ *In Progress: Stackgraph Data Corruption:*
        ▪︎ Data corruption at rabobank
        ▪︎ Backup configurable amount of tephra WALs, making them inspectable
        ▪︎ Stress-test tephra interaction
    ◦ In Progress: Add Suse Observability platform and agent images to rancher security scan repository
    ◦ In Progress: [TIMEBOX] Reduce CVEs on spotlight
    ◦ In Progress: Investigate and fix Dynatrace missing attributes and excessive process data.
    ◦ Done:
        ▪︎ [Release] Suse Observability Release v2.6.2
        ▪︎ [QA] Add rancher on automation tools to validate extension/rancher/stackstate
        ▪︎ Create a suse observability stackpack monitor for streams that process no data and snapshots repeatedly failing
        ▪︎ Data Corruption:
            • Extract and summarize metadata information in the support package
            • Data corruption at DICTU [SURE-10904]

---

**Louis Lotter** (2025-11-12 15:01):
And an update for the Process enforcer from Alessio:
In Progress
• Kyle: Optimizing Tetragon upstream to reduce memory consumption and improve process termination efficiency
• Sam: Addressing the 38-policy-per-host limitation; workaround identified and upstream feedback is positive
• Andrea: Collaborating with upstream on workflow improvements to reduce resource overhead
• Sam and Alessio: Repository Migration, almost done.
• Alessio,Flavio, Andrea: CRD Stabilization:Finalize custom resource definitions, which will enable workflow stabilization and demo deployment.
Done:
• Andrea: Refactored code, fixing multiple bugs including the Tetragon connection issue (previously reconnecting every 30 seconds)
• Kyle: Added questions.yml file for Rancher UI configuration support
• Alessio: Implemented label-based promotion feature allowing users to convert security proposals to policies
• Andrea, Sam, Kyle: Merged optimization PRs upstream

---


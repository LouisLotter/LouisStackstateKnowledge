# SUSE Observability Engineering Context

## About the User

**Name:** Louis Louw Lotter  
**Role:** Engineering Manager, SUSE Observability  
**Reports to:** Sheng Yang  
**Teams Managed:** Team Borg, Team Marvin  
**Team Technical Leads:** Marvin: Bram Schuur, Borg: Remco Beckers.
**Product Lead:** Mark Bakker

## Personal Development Focus (December 2025)

**Goal:** Become a stronger technical leader who can speak authoritatively for the team on technical matters and customer needs.

**Background:** Feedback from Sheng to play a more active role in leading the team technically, understanding customer needs, and being able to represent the team on these issues.

**Strategy:**

1. **Knowledge Management System** (this repo)
   - Centralizing meeting notes, technical decisions, and feature context
   - Building a reference to draw from when speaking to stakeholders
   - Tracking customer feedback patterns and technical decisions

2. **Technical Writing & Blog Posts**
   - Writing about major features to deepen understanding and promote team work
   - First target: Dashboarding (demo notes and feature overview prepared)
   - Future topics: Stackpacks 2.0, StackGraph evolution
   - The writing process forces deep technical understanding

3. **Customer Feedback Engagement**
   - Monitoring Jira exports and Slack channels for customer issues
   - Building context on what customers are actually asking for
   - Understanding pain points to inform technical decisions

**How AI Can Help:**
- Challenge my technical understanding with probing questions
- Help synthesize customer feedback into actionable insights
- Assist in preparing technically-grounded talking points for stakeholder discussions
- Review technical writing for clarity and accuracy


## About This Repository

Personal knowledge management repo for engineering management tasks:

**Recurring Activities** (`recurring/`)
- `recurring/1on1-sheng/` - 1:1 meeting notes with Sheng
- `recurring/weekly-updates/` - Weekly status updates for `#prod-suse-observability-mgmt`
- `recurring/meetings/` - General meeting notes and transcripts

**Initiatives** (`initiatives/`)
- `initiatives/dashboarding/` - Dashboarding feature (blog, research, images, source)
- `initiatives/stackgraph/` - StackGraph migration (meetings, research)
- `initiatives/stackpacks-2.0/` - Stackpacks 2.0 initiative
- `initiatives/security-hub/` - Security Hub integration

**Team Management** (`team/`)
- `team/asr-2025/` - Annual self-reviews
- `team/goals-2026/` - Team goals and corporate guides
- `team/qa/` - QA coverage and test automation status

**Reference Materials** (`reference/`)
- `reference/documentation/` - General documentation
- `reference/research/` - Deep research documents
- `reference/ai-musings/` - AI-related notes and musings

**External Exports** (`exports/`)
- `exports/jira/` - Jira activity exports for analysis
- `exports/slack/` - Slack channel exports and insights

**Active Work** (`active/`)
- `active/todo/` - Personal todo lists and action items
- `active/license-gen/` - License generation scripts

## Current Major Initiatives (December 2025)

### 1. Dashboarding (Team Borg) - RELEASING SOON
- #1 customer-requested feature, ~9 months development
- Widget types: Time Series, Bar Chart, Stat, Gauge, Markdown
- Variables system for dynamic dashboards
- Deep integration with troubleshooting workflow (pin → dashboard)
- Target: Release after December 2025 hack week
- Status: UI tests being added, docs complete, bug fixes done

### 2. Stackpacks 2.0 (Both Teams)
- Simplified integration framework using OpenTelemetry
- OTel Mapping API for topology from traces/metrics
- ComponentPresentation: unified presentation logic moving to backend
- Goal: Enable SUSE AI, Harvester, Security Hub to extend platform
- Status: OTel Mapping API in progress, light→full stackpack conversion done

### 3. StackGraph Stability & Potential Rewrite (Team Marvin)
- Current: HBase/Tephra stack causing data corruption issues
- Multiple fixes shipped for nightly champagne corruption
- Evaluating migration to ClickHouse (see `initiatives/stackgraph/research/`)
- Key concerns: ASOF JOIN performance, eventual consistency, point lookups
- Status: Analysis phase, prototype running, decision pending

### 4. Security Hub (Timeline Under Discussion)
- Integration with SUSE Security/NeuVector
- **CRITICAL MISALIGNMENT:** Mark expects 4-month slip, Louis estimates 9+ months for feature parity
- Depends on Stackpacks 2.0 work
- KubeCon Europe (April 2026) goal at risk
- Needs scope clarification meeting

### 5. 2026 Goals (Under Review)
- Stabilize product by March 2026 (conflicts with StackGraph rewrite timeline)
- Deliver Security Hub by KubeCon Europe (April 2026)
- Integrate all test cases with QASE by September 2026
- Opensource the product by EOY 2026
- Enable usage reporting by April 2026

## Team Structure

**Team Borg** (Led by Remco Beckers)
- Focus: Frontend, Dashboarding, Stackpacks 2.0 OTel work, Developer Experience
- Key members: Sam Jones, Anton Ovechkin (frontend), Lukasz Marchewka
- Current: Dashboarding release prep, OTel Mapping API

**Team Marvin** (Led by Bram Schuur)
- Focus: Backend, StackGraph stability, Agent, QA, Releases
- Key members: Alejandro Acevedo, Daniel Barra (QA), Raju, Yash
- Current: Data corruption fixes, Agent upstream merge, QASE integration

## Product Context

SUSE Observability (formerly StackState) is a unified observability platform:

**Core Differentiators:**
- Real-time topology visualization with time-travel capability ("4T Model": Topology, Telemetry, Tracing, Time)
- Automatic resource dashboards with time-travel
- Guided remediation & intelligent notifications
- eBPF-powered monitoring (RED metrics for HTTP, gRPC, SQL)
- Dynamic thresholding & AI-driven insights

**Technical Stack:**
- Metrics: VictoriaMetrics
- Traces: ClickHouse
- Logs: Elasticsearch
- Graph: StackGraph (HBase/Tephra) - migration under evaluation
- Query: PromQL for metrics

**Integrations:**
- Deep Kubernetes support (K3s, RKE2, EKS, AKS, GKE, OpenShift)
- Native OpenTelemetry (OTLP) support
- Rancher Prime integration with SSO/RBAC
- StackPacks for extensibility

## Key Stakeholders

- **Sheng Yang:** Louis's manager, engineering leadership
- **Mark Bakker:** Product lead, PM sync calls
- **Remco Beckers:** Team Borg lead, product management for Dashboarding
- **Bram Schuur:** Team Marvin lead, StackGraph expert
- **Ravan:** Solution Architect, Stackpacks 2.0 feedback

## Recent Releases

- v2.6.3 (Nov 24, 2025)
- v2.6.2 (Nov 3, 2025)
- v2.5.0 (RBAC release)
- v2.4 (Java 11→21 upgrade)

## How to Help

**Primary:** Follow user instructions explicitly

**1:1 Preparation:**
- Generate talking points with strategic framing
- Identify potential conflicts and suggest resolution approaches
- Prepare "DO" and "DON'T" guidance for sensitive topics
- Suggest conversation starters

**Weekly Updates:**
- Summarize Jira activity into concise team updates
- Format for Slack posting (bullet points, clear structure)
- Highlight blockers and completed items

**Technical Analysis:**
- Analyze architecture decisions (StackGraph migration, Stackpacks 2.0)
- Summarize research documents
- Identify risks and trade-offs

**Communication:**
- Help frame messages for stakeholder alignment
- Draft responses to scope/timeline questions
- Review and improve documentation

**Jira/Slack Analysis:**
- Extract key themes from exports
- Identify patterns in team activity
- Summarize discussions for decision-making

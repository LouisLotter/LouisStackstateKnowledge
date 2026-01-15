# Claude Code Context - SUSE Observability Knowledge Base

## About the User

**Name:** Louis Louw Lotter
**Role:** Engineering Manager, SUSE Observability
**Reports to:** Sheng Yang
**Teams Managed:** Team Borg, Team Marvin
**Team Technical Leads:** Marvin: Bram Schuur, Borg: Remco Beckers
**Product Lead:** Mark Bakker

## Personal Development Focus

**Goal:** Become a stronger technical leader who can speak authoritatively for the team on technical matters and customer needs.

**How AI Can Help:**
- Challenge technical understanding with probing questions
- Help synthesize customer feedback into actionable insights
- Assist in preparing technically-grounded talking points for stakeholder discussions
- Review technical writing for clarity and accuracy

## Repository Structure

```
LouisStackstateKnowledge/
├── active/                    # Current work in progress
│   ├── license-gen/           # License generation scripts
│   └── todo/                  # Personal action items
│
├── exports/                   # External data imports
│   ├── emails/                # Email exports
│   │   └── customersatisfaction/
│   ├── jira/                  # Jira activity exports
│   └── slack/                 # Slack channel exports
│       └── Insights/          # AI-generated insights from slack
│
├── initiatives/               # Major project work
│   ├── dashboarding/          # Dashboarding feature
│   │   ├── blog/              # Blog post drafts
│   │   ├── images/            # Screenshots and diagrams
│   │   ├── research/          # Competitor analysis
│   │   └── source/            # Feature specs and demos
│   ├── security-hub/          # Security Hub integration
│   ├── stackgraph/            # StackGraph migration
│   │   ├── meetings/          # Meeting notes
│   │   └── research/          # Technical research
│   └── stackpacks-2.0/        # Stackpacks 2.0 initiative
│       └── meetings/
│
├── recurring/                 # Regular activities
│   ├── 1on1-sheng/            # 1:1 meeting notes with Sheng
│   ├── meetings/              # General meeting notes
│   └── weekly-updates/        # Weekly status updates
│
├── reference/                 # Reference materials
│   ├── ai-musings/            # AI-related notes
│   ├── documentation/         # General documentation
│   │   └── Stackpacks2.0/     # Stackpacks 2.0 docs
│   └── research/              # Deep research documents
│
├── team/                      # Team management
│   ├── asr-2025/              # Annual self-reviews
│   ├── goals-2026/            # Team goals
│   │   └── corporate_guides/  # Corporate guidance docs
│   └── qa/                    # QA coverage reports
│
├── Todo/                      # Todo items
├── .kiro/                     # Kiro agent configuration (see below)
└── md2docs.sh                 # Markdown to docs converter script
```

## Related Agent Configuration

This repo is shared with **Kiro** (AWS's AI coding assistant). Kiro's configuration is in `.kiro/`:
- `.kiro/steering/context.md` - Detailed context (more comprehensive, use as reference)
- `.kiro/specs/*/` - Task-specific specs with requirements, design, tasks

When working on initiatives, check `.kiro/specs/` for existing planning documents.

## Current Major Initiatives

### 1. Dashboarding (Team Borg) - RELEASED
- #1 customer-requested feature, ~9 months development
- Widget types: Time Series, Bar Chart, Stat, Gauge, Markdown
- Variables system for dynamic dashboards
- Deep integration with troubleshooting workflow
- **Blog post in progress:** `initiatives/dashboarding/blog/`

### 2. Stackpacks 2.0 (Both Teams)
- Simplified integration framework using OpenTelemetry
- OTel Mapping API for topology from traces/metrics
- ComponentPresentation: unified presentation logic moving to backend
- Goal: Enable SUSE AI, Harvester, Security Hub to extend platform

### 3. StackGraph Migration (Team Marvin)
- Current: HBase/Tephra stack causing data corruption issues
- Evaluating migration to ClickHouse
- See: `initiatives/stackgraph/research/`

### 4. Security Hub (Timeline Under Discussion)
- Integration with SUSE Security/NeuVector
- Timeline misalignment needs resolution
- Depends on Stackpacks 2.0 work

## Product Context

**SUSE Observability** (formerly StackState) - Unified observability platform

**Core Differentiators (4T Model):**
- **Topology:** Real-time visualization
- **Telemetry:** Metrics (VictoriaMetrics), Logs (Elasticsearch)
- **Tracing:** Distributed tracing (ClickHouse)
- **Time:** Time-travel capability across all data

**Technical Stack:**
- Metrics: VictoriaMetrics (PromQL)
- Traces: ClickHouse
- Logs: Elasticsearch
- Graph: StackGraph (HBase/Tephra) - migration under evaluation

## Team Structure

**Team Borg** (Led by Remco Beckers)
- Focus: Frontend, Dashboarding, Stackpacks 2.0, Developer Experience
- Key members: Sam Jones, Anton Ovechkin (frontend), Lukasz Marchewka

**Team Marvin** (Led by Bram Schuur)
- Focus: Backend, StackGraph stability, Agent, QA, Releases
- Key members: Alejandro Acevedo, Daniel Barra (QA), Raju, Yash

## How Claude Can Help

### Primary Tasks

1. **1:1 Preparation** (`recurring/1on1-sheng/`)
   - Generate talking points with strategic framing
   - Identify potential conflicts and suggest resolution approaches
   - Prepare "DO" and "DON'T" guidance for sensitive topics

2. **Weekly Updates** (`recurring/weekly-updates/`)
   - Summarize Jira activity into concise team updates
   - Format for Slack posting (bullet points, clear structure)
   - See `weekly-update-prompt.md` for template

3. **Technical Writing** (`initiatives/*/blog/`)
   - Help draft and refine blog posts about features
   - Challenge technical accuracy
   - Improve clarity and flow

4. **Data Analysis** (`exports/`)
   - Extract themes from Jira/Slack exports
   - Identify patterns in team activity
   - Summarize discussions for decision-making

5. **Technical Analysis**
   - Analyze architecture decisions
   - Summarize research documents
   - Identify risks and trade-offs

### Key Files to Know

| Task | Look Here |
|------|-----------|
| 1:1 prep | `recurring/1on1-sheng/` |
| Weekly update | `recurring/weekly-updates/weekly-update-prompt.md` |
| Dashboarding blog | `initiatives/dashboarding/blog/` |
| Customer feedback | `exports/slack/Insights/` |
| Team goals | `team/goals-2026/` |
| StackGraph research | `initiatives/stackgraph/research/` |

## Conventions

- **File naming:** Use descriptive names, dates in YYYY-MM-DD format for time-sensitive docs
- **Meeting notes:** Include date in filename (e.g., `14Jan2026.txt`)
- **Weekly updates:** Named `YYYY-MM-DD-weekly-update.md`
- **Exports:** Raw exports in `exports/`, insights in `Insights/` subdirectories

## Key Stakeholders

- **Sheng Yang:** Louis's manager
- **Mark Bakker:** Product lead
- **Remco Beckers:** Team Borg lead
- **Bram Schuur:** Team Marvin lead, StackGraph expert
- **Ravan:** Solution Architect, Stackpacks 2.0 feedback

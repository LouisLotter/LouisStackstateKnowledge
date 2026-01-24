# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Repository

Personal knowledge management repo for Louis Lotter, Engineering Manager at SUSE Observability (formerly StackState). Used for meeting prep, weekly updates, technical writing, and team management.

**Teams Managed:** Team Borg (led by Remco Beckers), Team Marvin (led by Bram Schuur)
**Reports to:** Sheng Yang | **Product Lead:** Mark Bakker

## Useful Commands

```bash
# Convert markdown to docx for Google Docs upload (requires pandoc)
./md2docs.sh <markdown-file>

# Generate license (in active/license-gen/)
./stackstate-license -createlicense 2026-12-12
```

**Jira Export Filter** (for weekly updates):
```
(updated >= -14d OR created >= -14d ) AND Status != "To Bulk" AND Status != "Ready to work on" AND Status != "Needs more info" AND Status != Backlog order by created DESC
```

## Key Workflows

### Weekly Updates

See `recurring/weekly-updates/weekly-update-prompt.md` for the full template. The workflow:
1. Export Jira activity to `exports/jira/JiraExport8DaysEnding[DATE].txt`
2. Run the template to generate three outputs:
   - `recurring/weekly-updates/YYYY-MM-DD-weekly-update.md` (concise)
   - `recurring/weekly-updates/YYYY-MM-DD-weekly-update-indepth.txt` (for 1:1 prep)
   - Slack message (copy/paste to `#prod-suse-observability-mgmt`)

### 1:1 Preparation

For 1:1s with Sheng (`recurring/1on1-sheng/`):
- Generate talking points with strategic framing
- Identify potential conflicts and suggest resolution approaches
- Prepare "DO" and "DON'T" guidance for sensitive topics

## Repository Structure

| Directory | Purpose |
|-----------|---------|
| `recurring/1on1-sheng/` | 1:1 meeting notes with Sheng |
| `recurring/weekly-updates/` | Weekly status updates |
| `initiatives/` | Major project work (dashboarding, stackgraph, stackpacks-2.0, security-hub) |
| `exports/jira/` | Jira activity exports for analysis |
| `exports/slack/` | Slack channel exports; `Insights/` subdirectory has AI-generated summaries |
| `team/goals-2026/` | Team goals and corporate guides |
| `team/asr-2025/` | Annual self-reviews |
| `active/` | Current work in progress |
| `reference/` | Reference materials and research |
| `.kiro/` | Kiro agent configuration; check `.kiro/specs/` for initiative planning docs |

## File Naming Conventions

- **Weekly updates:** `YYYY-MM-DD-weekly-update.md`
- **Meeting notes:** `DDMmmYYYY.txt` (e.g., `14Jan2026.txt`)
- **Jira exports:** `JiraExport8DaysEnding[DATE].txt`
- **Time-sensitive docs:** Use `YYYY-MM-DD` prefix

## Current Initiatives

| Initiative | Team | Status | Key Directory |
|------------|------|--------|---------------|
| Dashboarding | Borg | Released | `initiatives/dashboarding/` (blog in progress) |
| Stackpacks 2.0 | Both | In progress | `initiatives/stackpacks-2.0/` |
| StackGraph Migration | Marvin | Analysis phase | `initiatives/stackgraph/research/` |
| Security Hub | TBD | Timeline under discussion | `initiatives/security-hub/` |

## Product Context (SUSE Observability)

**Core Differentiators (4T Model):**
- **Topology:** Real-time visualization
- **Telemetry:** Metrics (VictoriaMetrics/PromQL), Logs (Elasticsearch)
- **Tracing:** Distributed tracing (ClickHouse)
- **Time:** Time-travel capability across all data

**Technical Stack:** VictoriaMetrics, ClickHouse, Elasticsearch, StackGraph (HBase/Tephra, migration to ClickHouse under evaluation)

## Writing Guidelines (External Content)

When writing customer-facing content (blogs, docs, marketing):

### Avoid Em-Dashes
Em-dashes (—) signal AI-generated text. Use commas, parentheses, periods, or colons instead.
- "the feature—which is great—works well" → "the feature, which is great, works well"

### Avoid AI-Implying Language
Don't apply "knows," "understands," or "intelligent" to software features:
- "Dashboards that know your architecture" → "Dashboards connected to your architecture"
- "smart defaults" → "sensible defaults"

### Avoid Vague Marketing Terms
Be specific instead of using "native," "seamless," or "powerful." Describe what actually happens.

## Key Stakeholders

| Person | Role |
|--------|------|
| Sheng Yang | Louis's manager |
| Mark Bakker | Product lead |
| Remco Beckers | Team Borg lead |
| Bram Schuur | Team Marvin lead, StackGraph expert |
| Ravan | Solution Architect, Stackpacks 2.0 feedback |

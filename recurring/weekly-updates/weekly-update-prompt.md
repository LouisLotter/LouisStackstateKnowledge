# Weekly Update Generation Prompt

Use this prompt template each week to generate all weekly update artifacts in one go.

## Template

```
Generate my weekly update for [DATE]. 

1. Look at the previous two weekly updates in recurring/weekly-updates/ for format reference

2. Use the Jira export at exports/jira/[JIRA_EXPORT_FILE].txt to generate:
   - A markdown weekly update file at recurring/weekly-updates/[DATE]-weekly-update.md
   - An in-depth update file at recurring/weekly-updates/[DATE]-weekly-update-indepth.txt (for my 1:1 with Sheng)
   - A Slack-friendly version (output directly in chat)

3. The Slack version should:
   - Use clear section headers with no emoji
   - Separate Team Borg, Team Marvin, and Stackpacks 2.0
   - Use bullet points with "Done:" and "In progress:" prefixes
   - Include a "Main themes" summary at the end
   - Use generous newlines for readability

4. The in-depth version should include:
   - Detailed breakdown by epic/initiative
   - Story points and assignees where available
   - Customer impact notes
   - Talking points for my 1:1 with Sheng
   - Wins, concerns, and questions to ask
   - Release notes preview
```

## Example Usage

```
Generate my weekly update for 21 January 2026.

1. Look at the previous two weekly updates in recurring/weekly-updates/ for format reference

2. Use the Jira export at exports/jira/JiraExport8DaysEnding21Jan2026.txt to generate:
   - A markdown weekly update file at recurring/weekly-updates/2026-01-21-weekly-update.md
   - An in-depth update file at recurring/weekly-updates/2026-01-21-weekly-update-indepth.txt
   - A Slack-friendly version (output directly in chat)
```

## Pre-requisites

Before running this prompt:
1. Export Jira activity for the past ~8 days and save to `exports/jira/`
2. Name the file consistently (e.g., `JiraExport8DaysEnding[DATE].txt`)

## Output Files

This prompt generates:
- `recurring/weekly-updates/YYYY-MM-DD-weekly-update.md` - Concise markdown for reference
- `recurring/weekly-updates/YYYY-MM-DD-weekly-update-indepth.txt` - Detailed version for 1:1 prep
- Slack message (in chat) - Copy/paste ready for `#prod-suse-observability-mgmt`

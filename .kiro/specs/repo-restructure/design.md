# Design Document: Repository Restructure

## Overview

This design document outlines the restructure of Louis's personal knowledge management repository from its current organic structure into a clean, purpose-driven organization. The restructure consolidates 15+ top-level folders into 6 logical categories while preserving all content and updating internal references.

## Architecture

### Current Structure (Before)

```
/
├── 2025ASR/                    # Annual self-reviews
├── Blogs/                      # Blog content (Dashboarding)
├── Documentation/              # General docs
├── GeminiDeepResearch/         # Research documents
├── Goals2026/                  # Team goals
├── JiraExports/                # Jira data exports
├── LicenseKeyGeneration/       # Utility scripts
├── Meetings/                   # Meeting notes (Stackpacks, TTT)
├── MusingsOnAI/                # Personal notes
├── OpusOverviews/              # AI-generated overviews
├── Sheng1on1/                  # 1:1 meeting notes
├── SlackChannelExports/        # Slack exports
├── StackstateQA/               # QA documentation
├── Todo/                       # Personal todos
├── Updates/                    # Weekly updates
├── md2docs.sh                  # Utility script
└── Shortcuts.txt               # Reference file
```

### Proposed Structure (After)

```
/
├── recurring/                  # Regular activities
│   ├── 1on1-sheng/            # 1:1 meetings with Sheng
│   ├── weekly-updates/        # Weekly status updates
│   └── meetings/              # General meeting notes
│
├── initiatives/               # Project-specific content
│   ├── dashboarding/          # Dashboarding feature
│   │   ├── blog/
│   │   ├── research/
│   │   └── images/
│   ├── stackgraph/            # StackGraph migration
│   ├── stackpacks-2.0/        # Stackpacks 2.0 initiative
│   └── security-hub/          # Security Hub integration
│
├── team/                      # Team management
│   ├── asr-2025/              # Annual self-reviews
│   ├── goals-2026/            # Team goals
│   └── qa/                    # QA documentation
│
├── reference/                 # Reference materials
│   ├── documentation/         # General documentation
│   ├── research/              # Deep research documents
│   └── ai-musings/            # AI-related notes
│
├── exports/                   # External data exports
│   ├── jira/                  # Jira exports
│   └── slack/                 # Slack channel exports
│
├── active/                    # Current work
│   ├── todo/                  # Daily todos
│   └── license-gen/           # License generation scripts
│
├── .kiro/                     # Kiro configuration (unchanged)
├── .git/                      # Git repository (unchanged)
├── md2docs.sh                 # Utility script (root)
└── Shortcuts.txt              # Reference file (root)
```

## Components and Interfaces

### Folder Mapping

| Current Location | New Location | Notes |
|-----------------|--------------|-------|
| `Sheng1on1/` | `recurring/1on1-sheng/` | 1:1 meeting notes |
| `Updates/` | `recurring/weekly-updates/` | Weekly status updates |
| `Meetings/` | Split | Content distributed by initiative |
| `Meetings/Stackpacks2.0/` | `initiatives/stackpacks-2.0/meetings/` | Initiative-specific |
| `Meetings/TimeTravelingTopology/` | `initiatives/stackgraph/meetings/` | Initiative-specific |
| `Blogs/Dashboarding/` | `initiatives/dashboarding/` | Full blog content |
| `GeminiDeepResearch/` | `initiatives/stackgraph/research/` | StackGraph research |
| `2025ASR/` | `team/asr-2025/` | Annual reviews |
| `Goals2026/` | `team/goals-2026/` | Team goals |
| `StackstateQA/` | `team/qa/` | QA documentation |
| `Documentation/` | `reference/documentation/` | General docs |
| `OpusOverviews/` | `reference/research/` | AI overviews |
| `MusingsOnAI/` | `reference/ai-musings/` | AI notes |
| `JiraExports/` | `exports/jira/` | Jira data |
| `SlackChannelExports/` | `exports/slack/` | Slack exports |
| `Todo/` | `active/todo/` | Daily todos |
| `LicenseKeyGeneration/` | `active/license-gen/` | Utility scripts |

### Reference Updates Required

The following files contain internal folder references that must be updated:

1. **`.kiro/steering/context.md`** - Primary steering file with folder documentation
   - Update "About This Repository" section with new paths
   - Update all backtick-quoted folder references

## Data Models

### Folder Naming Convention

All folders follow the pattern: `lowercase-with-hyphens`

- No spaces
- No underscores
- No capital letters
- Descriptive names preferred over abbreviations

### File Preservation

All files maintain their original names and content. Only their location changes.

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: File Count Preservation

*For any* restructure operation, the total count of non-directory files before restructure SHALL equal the total count after restructure (excluding .git internals).

**Validates: Requirements 2.4**

### Property 2: Folder Naming Convention Compliance

*For any* folder created during restructure, the folder name SHALL match the pattern `^[a-z0-9]+(-[a-z0-9]+)*$` (lowercase alphanumeric with hyphens).

**Validates: Requirements 1.3**

### Property 3: No Stale References in Steering File

*For any* folder path referenced in the steering file after restructure, that path SHALL exist as a valid directory in the repository.

**Validates: Requirements 6.1, 6.3**

### Property 4: Old Folder Names Removed from References

*For any* document in the repository after restructure, the document SHALL NOT contain references to the old folder names (Sheng1on1, JiraExports, SlackChannelExports, etc.) as path references.

**Validates: Requirements 6.2**

## Error Handling

### Potential Issues

1. **File conflicts**: If a file with the same name exists in the target location
   - Resolution: Rename with suffix or merge manually

2. **Broken references**: External links or bookmarks to old paths
   - Resolution: Document old-to-new mapping for manual updates

3. **Hidden files**: .DS_Store and other system files
   - Resolution: Move or delete as appropriate

## Testing Strategy

### Verification Approach

Since this is a file reorganization task (not code), testing focuses on verification scripts:

1. **Pre-restructure inventory**: Count all files and record their paths
2. **Post-restructure verification**: 
   - Verify file count matches
   - Verify all new folders exist
   - Verify no old top-level folders remain (except .git, .kiro)
   - Verify steering file references are valid

### Manual Verification Checklist

- [ ] All files accessible in new locations
- [ ] Steering file updated with correct paths
- [ ] No broken internal links
- [ ] Git history preserved (commits intact)
- [ ] Kiro specs still functional

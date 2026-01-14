# Requirements Document

## Introduction

This document specifies the requirements for restructuring Louis's personal knowledge management repository. The repository has grown organically and needs a cleaner, more intuitive organization to improve findability and maintainability. The restructure must also update any internal document references to reflect the new folder structure.

## Glossary

- **Repository:** The personal knowledge management git repository used by Louis for engineering management tasks
- **Internal Reference:** A path or folder name mentioned within a document that points to another location in the repository
- **Steering File:** A Kiro configuration file (`.kiro/steering/context.md`) that provides AI context about the repository structure
- **Content Category:** A logical grouping of related documents based on their purpose or topic

## Requirements

### Requirement 1

**User Story:** As a user, I want a clear folder structure organized by content purpose, so that I can quickly locate documents without remembering arbitrary folder names.

#### Acceptance Criteria

1. WHEN a user looks at the top-level folder structure THEN the Repository SHALL present folders with descriptive names that indicate their content purpose
2. WHEN organizing content THEN the Repository SHALL group related documents into no more than 7 top-level categories to maintain cognitive simplicity
3. WHEN naming folders THEN the Repository SHALL use lowercase-with-hyphens naming convention for consistency
4. WHEN a folder contains time-based content (meetings, updates, todos) THEN the Repository SHALL organize files chronologically within that folder

### Requirement 2

**User Story:** As a user, I want recurring activities (1:1s, weekly updates, meetings) grouped together, so that I can find all my regular work in one place.

#### Acceptance Criteria

1. WHEN the user needs to access 1:1 meeting notes THEN the Repository SHALL provide a dedicated location for all 1:1 content
2. WHEN the user needs to access weekly updates THEN the Repository SHALL provide a dedicated location for all weekly update content
3. WHEN the user needs to access general meeting notes THEN the Repository SHALL provide a dedicated location for meeting-related content
4. WHEN recurring content is reorganized THEN the Repository SHALL preserve all existing files without data loss

### Requirement 3

**User Story:** As a user, I want initiative-specific content (Dashboarding, StackGraph, etc.) organized by project, so that I can find all materials related to a specific initiative in one place.

#### Acceptance Criteria

1. WHEN the user works on a specific initiative THEN the Repository SHALL provide a dedicated folder for that initiative's content
2. WHEN initiative content exists across multiple current folders THEN the Repository SHALL consolidate that content into the initiative folder
3. WHEN an initiative has sub-categories (research, blog, meetings) THEN the Repository SHALL organize those as subfolders within the initiative folder

### Requirement 4

**User Story:** As a user, I want reference materials (exports, documentation, research) organized separately from active work, so that I can distinguish between working documents and source materials.

#### Acceptance Criteria

1. WHEN the user needs to access Jira or Slack exports THEN the Repository SHALL provide a dedicated location for external data exports
2. WHEN the user needs to access general documentation THEN the Repository SHALL provide a dedicated location for reference documentation
3. WHEN the user needs to access research materials THEN the Repository SHALL provide a dedicated location for research content

### Requirement 5

**User Story:** As a user, I want team-related content (ASRs, goals, QA) organized together, so that I can find all team management materials in one place.

#### Acceptance Criteria

1. WHEN the user needs to access annual self-reviews THEN the Repository SHALL provide a dedicated location for ASR content
2. WHEN the user needs to access team goals THEN the Repository SHALL provide a dedicated location for goals content
3. WHEN the user needs to access QA-related materials THEN the Repository SHALL provide a dedicated location for QA content

### Requirement 6

**User Story:** As a user, I want all internal document references updated after the restructure, so that links and paths in documents remain valid.

#### Acceptance Criteria

1. WHEN the restructure is complete THEN the Steering File SHALL reflect the new folder structure with accurate path references
2. WHEN a document contains references to old folder paths THEN the Repository SHALL update those references to the new paths
3. WHEN updating references THEN the Repository SHALL verify that all updated paths point to valid locations

### Requirement 7

**User Story:** As a user, I want utility files and scripts to remain accessible at the root level, so that I can quickly access commonly used tools.

#### Acceptance Criteria

1. WHEN the restructure is complete THEN the Repository SHALL keep utility scripts (md2docs.sh, Shortcuts.txt) at the root level
2. WHEN the restructure is complete THEN the Repository SHALL preserve the .kiro configuration folder structure unchanged
3. WHEN the restructure is complete THEN the Repository SHALL preserve the .git folder unchanged

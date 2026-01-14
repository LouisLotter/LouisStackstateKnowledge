# Implementation Plan

- [ ] 1. Create new folder structure
  - [ ] 1.1 Create top-level folders (recurring, initiatives, team, reference, exports, active)
    - Create all 6 top-level directories
    - _Requirements: 1.1, 1.2, 1.3_
  - [ ] 1.2 Create recurring subfolders (1on1-sheng, weekly-updates, meetings)
    - _Requirements: 2.1, 2.2, 2.3_
  - [ ] 1.3 Create initiatives subfolders (dashboarding, stackgraph, stackpacks-2.0, security-hub)
    - _Requirements: 3.1_
  - [ ] 1.4 Create team subfolders (asr-2025, goals-2026, qa)
    - _Requirements: 5.1, 5.2, 5.3_
  - [ ] 1.5 Create reference subfolders (documentation, research, ai-musings)
    - _Requirements: 4.2, 4.3_
  - [ ] 1.6 Create exports subfolders (jira, slack)
    - _Requirements: 4.1_
  - [ ] 1.7 Create active subfolders (todo, license-gen)
    - _Requirements: 7.1_

- [ ] 2. Move recurring content
  - [ ] 2.1 Move Sheng1on1/* to recurring/1on1-sheng/
    - _Requirements: 2.1, 2.4_
  - [ ] 2.2 Move Updates/* to recurring/weekly-updates/
    - _Requirements: 2.2, 2.4_

- [ ] 3. Move initiative content
  - [ ] 3.1 Move Blogs/Dashboarding/* to initiatives/dashboarding/
    - Preserve blog/, images/, research/, source/ subfolders
    - _Requirements: 3.1, 3.2, 3.3_
  - [ ] 3.2 Move Meetings/Stackpacks2.0/* to initiatives/stackpacks-2.0/meetings/
    - _Requirements: 3.1, 3.2_
  - [ ] 3.3 Move Meetings/TimeTravelingTopology/* to initiatives/stackgraph/meetings/
    - _Requirements: 3.1, 3.2_
  - [ ] 3.4 Move GeminiDeepResearch/* to initiatives/stackgraph/research/
    - _Requirements: 3.1, 3.2_
  - [ ] 3.5 Move OpusOverviews/Stackpacks2.0.md to initiatives/stackpacks-2.0/
    - _Requirements: 3.1, 3.2_

- [ ] 4. Move team content
  - [ ] 4.1 Move 2025ASR/* to team/asr-2025/
    - _Requirements: 5.1, 2.4_
  - [ ] 4.2 Move Goals2026/* to team/goals-2026/
    - Preserve corporate_guides/ subfolder
    - _Requirements: 5.2, 2.4_
  - [ ] 4.3 Move StackstateQA/* to team/qa/
    - _Requirements: 5.3, 2.4_

- [ ] 5. Move reference content
  - [ ] 5.1 Move Documentation/* to reference/documentation/
    - _Requirements: 4.2, 2.4_
  - [ ] 5.2 Move MusingsOnAI/* to reference/ai-musings/
    - _Requirements: 4.3, 2.4_

- [ ] 6. Move exports content
  - [ ] 6.1 Move JiraExports/* to exports/jira/
    - _Requirements: 4.1, 2.4_
  - [ ] 6.2 Move SlackChannelExports/* to exports/slack/
    - Preserve Insights/ subfolder
    - _Requirements: 4.1, 2.4_

- [ ] 7. Move active content
  - [ ] 7.1 Move Todo/* to active/todo/
    - _Requirements: 2.4_
  - [ ] 7.2 Move LicenseKeyGeneration/* to active/license-gen/
    - _Requirements: 7.1, 2.4_

- [ ] 8. Cleanup empty old folders
  - [ ] 8.1 Remove empty old top-level folders
    - Remove: Sheng1on1, Updates, Blogs, Meetings, 2025ASR, Goals2026, StackstateQA, Documentation, MusingsOnAI, GeminiDeepResearch, JiraExports, SlackChannelExports, Todo, LicenseKeyGeneration, OpusOverviews
    - _Requirements: 1.1_

- [ ] 9. Update internal references
  - [ ] 9.1 Update .kiro/steering/context.md with new folder paths
    - Update "About This Repository" section
    - Replace all old folder references with new paths
    - _Requirements: 6.1, 6.2, 6.3_

- [ ] 10. Final verification
  - [ ] 10.1 Verify file count matches pre-restructure count
    - Count files before and after (excluding .git)
    - _Requirements: 2.4_
  - [ ] 10.2 Verify all new folders exist and contain expected content
    - _Requirements: 1.1, 2.1, 2.2, 2.3, 3.1, 4.1, 4.2, 4.3, 5.1, 5.2, 5.3_
  - [ ] 10.3 Verify steering file references point to valid paths
    - _Requirements: 6.3_

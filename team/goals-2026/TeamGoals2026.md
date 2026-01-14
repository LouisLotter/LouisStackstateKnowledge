# SUSE Observability Team Goals - FY2026

*Ready-to-use goals for Team Borg & Team Marvin. Pick the ones relevant to your role.*

---

## Goal 1: Product Stabilization

**Goal:** Achieve zero critical data corruption incidents on the chaos test instance by March 2026.

**Key Results:**
- Identify and resolve all StackGraph/Tephra stability issues surfaced by chaos testing
- Implement monitoring and alerting for early detection of data integrity issues
- Document root causes and fixes in runbooks for future reference

**Success Metric:** Chaos instance runs 30 consecutive days without data corruption

---

## Goal 2: QASE Test Integration

**Goal:** Integrate all automated test suites with QASE reporting by September 2026.

**Key Results:**
- Complete Playwright → QASE integration for UI test reporting
- Ensure 100% of release validation test scenarios are tracked in QASE
- Add test coverage for Dashboarding and new FY26 features

**Success Metric:** All test runs visible in QASE dashboard with pass/fail tracking

---

## Goal 3: Stackpacks 2.0 Delivery

**Goal:** Deliver Stackpacks 2.0 framework enabling Rancher portfolio integrations by March 2026.

**Key Results:**
- Complete OTel Mapping API for topology generation from traces/metrics
- Migrate ComponentPresentation logic to backend
- Document integration patterns for partner teams (Security Hub, SUSE AI)

**Success Metric:** At least one external team successfully builds an integration using Stackpacks 2.0

---

## Goal 4: Security Hub Platform Enablement

**Goal:** Deliver platform capabilities required for Security Hub integration by April 2026.

**Key Results:**
- Implement security data ingestion pipeline via Stackpacks 2.0
- Enable security-specific topology visualization in the UI
- Complete theme switching support for NeuVector branding requirements

**Success Metric:** Security Hub team can ingest and visualize security data using our APIs

---

## Goal 5: Usage Telemetry Implementation

**Goal:** Enable feature usage reporting for on-prem deployments by April 2026.

**Key Results:**
- Implement telemetry collection for key features (Dashboards, Topology, Traces)
- Build phone-home mechanism for non-airgap deployments
- Create usage analytics dashboard for product team insights

**Success Metric:** Usage data collected from 50%+ of eligible deployments

---

## Goal 6: Open Source Preparation

**Goal:** Prepare codebase for public GitHub release by EOY 2026.

**Key Results:**
- Separate proprietary build tooling from open-sourceable code
- Audit and remove all hardcoded credentials and internal references
- Set up automated GitLab → GitHub mirroring pipeline

**Success Metric:** Clean GitHub mirror running with automated sync from GitLab

---

## Goal 7: Delivery Mechanism Improvement

**Goal:** Reduce installation and upgrade support burden by 40% by EOY 2026.

**Key Results:**
- Simplify Helm chart configuration with sensible defaults
- Improve error messaging and troubleshooting documentation
- Automate common post-installation validation checks

**Success Metric:** 40% reduction in installation-related support tickets vs FY25

---

## Goal 8: AI-Powered Productivity

**Goal:** Achieve 20% productivity improvement through AI tool adoption by Q2 2026, scaling to 40% by Q4.

**Key Results:**
- Adopt AI-assisted code review and documentation workflows
- Implement AI tooling for automated test generation
- Track and report time savings from AI adoption

**Success Metric:** Documented productivity gains meeting SUSE targets (20% Q2, 40% Q4)

---

## Goal 9: CVE Management Automation

**Goal:** Reduce manual CVE remediation effort by 60% through automation by Q3 2026.

**Key Results:**
- Automate dependency scanning and CVE detection in CI/CD pipeline
- Implement automated PR generation for version upgrades with low-risk CVE fixes
- Create dashboard tracking CVE backlog, age, and resolution time
- Establish SLA-based alerting for critical/high severity CVEs

**Success Metric:** Average CVE resolution time reduced by 50%, manual triage hours cut by 60%

---

## How to Use

1. Select goals relevant to your role and team (Borg/Marvin)
2. Copy to your Workday goal entry
3. Adjust key results if needed for your specific contribution
4. Discuss with Remco or Bram to confirm alignment
5. Document by end of January 2026

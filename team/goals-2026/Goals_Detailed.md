# SUSE Observability 2026 Goals - Detailed Breakdown

*Prepared for Team Lead Discussion - January 6, 2026*

---

## 1. Productization

### 1.1 Improve Delivery Mechanism for On-Prem Prime Customers (EOY 2026)

**What this means:**
- Move away from complex YAML-based deployments toward a more streamlined installation experience
- Focus on the operator pattern for easier lifecycle management
- Helm values chart replacement work already in progress

**Current state:**
- Rancher Extension handles much of the integration
- Helm-based deployment requires significant expertise

**Open questions for Sheng:**
- What does "improved" look like? One-click install? Simplified Helm? Full operator?
- Is this about installation cadence, upgrade experience, or both?

**Team impact:** Primarily Team Marvin (backend/infrastructure)

Notes for AI: We need to formulate this goal to be as generic as possible. primarily we want to reduce the support load
associated with installing/upgrading the product. 



---

### 1.2 Plan for Delivery via AppCo (EOY 2026)

**What this means:**
- Integration with SUSE's Application Collection delivery mechanism
- Note: Goal is to have a *plan*, not necessarily full delivery

**Concern raised with Sheng:**
- This is mostly AppCo team's work - how can this be *our* goal?
- Need clarity on what "our" deliverable is vs. what we support

**Recommendation:** Reframe as "Support AppCo team with integration requirements" or clarify ownership

**Team impact:** Cross-team coordination, likely minimal direct engineering

- notes for AI: Don't leave this too late as appco may not have time later in the year. Ideally this would have been done in 2026 but
we are settling for having a plan.

---

### 1.3 Stabilize the Product (March 2026)

**What this means:**
- Address known stability issues, particularly StackGraph/Tephra data corruption
- Reduce operational incidents and customer-reported issues

**⚠️ CRITICAL CONFLICT:**
- If "stabilize" includes the StackGraph rewrite → March is NOT realistic
- StackGraph rewrite to ClickHouse is under evaluation (see GeminiDeepResearch/)
- Multiple fixes shipped for nightly champagne corruption, but fundamental architecture issues remain

**Questions to clarify with Sheng:**
1. Does "stabilize" mean fixing current issues OR completing the rewrite?
2. Should this be timeboxed ("spend Q1 on stability") rather than date-driven?
3. What's the success metric? X% reduction in incidents? Zero data corruption?

**Team impact:** Team Marvin (StackGraph expertise with Bram)

notes for AI:
- We created a chaos instance it's still finding issues so our focus is tomake the chaos instance stable.
- If we do not manage to stabilize the chaos instance, we may at some point have to pivot to a rewrite by storing
data in clickhouse

---

## 2. Stack Harmonization

### 2.1 StackPack Feature for Rancher Portfolio Integration (March 2026)

**What this means:**
- Stackpacks 2.0 work enabling other SUSE products to integrate
- OTel Mapping API for topology from traces/metrics
- ComponentPresentation moving to backend

**Current status:** ✅ On track
- OTel Mapping API in progress
- Light-to-full stackpack conversion done
- This work unlocks Security Hub and other integrations

**Team impact:** Both teams - Team Borg (OTel work), Team Marvin (backend)


---

### 2.2 Deliver Security Hub (November 2026)///  (KubeCon Europe - April 2026)  // will be showing hackweek AI

**What this means:**
- Integration with SUSE Security/NeuVector
- Visualization of security data within SUSE Observability

**⚠️ CRITICAL MISALIGNMENT (discussed with Sheng Dec 16):**

| Perspective | Timeline | Scope |
|-------------|----------|-------|
| Mark's view | 4-month slip from original | "Releasable thing" - smaller scope |
| Louis's view | 9+ months for anything releasable | Feature parity with NeuVector |

**Dependencies:**
- Stackpacks 2.0 work (makes integration easier)
- Theme switching work (frontend)
- Process Enforcer progress (on track for March 2026 - good news!)

**Key insight from Process Enforcer:**
- Andrea built custom eBPF agent during hack week (merged Dec 15)
- Memory usage dropped from 3MB/policy to KB-level
- Kubewarden/CNCF productization path being pursued by Security team

**Questions to resolve:**
1. What is the actual MVP scope? Minimal integration vs. feature parity?
2. Can we phase delivery? MVP by April, full parity by EOY?
3. Is Kubewarden-only on Stackpacks 2.0 sufficient for KubeCon?

**Recommendation:** Need scope definition meeting with Mark and Sheng

**Team impact:** Both teams - significant effort

Notes for AI: This goal is too large and coupled with the roadmap and product decisions we want to limit this goal to the core 
functionality that will enable wherever the product team wants to take this.

-- Metrics for us: platform support for security data integration and visualization.
-- formulate an agent and integration related goal here

---

## 3. Operations

### 3.1 Integrate All Test Cases with QASE (September 2026)

**What this means:**
- All test scenarios tracked and reported through QASE
- Unified test management across Playwright, Python/Beest, CLI tests

**Current status:**
- QASE Beest integration live: https://app.qase.io/run/STACKSTATE/dashboard/36
- QASE integration complete for both Playwright and Python tests
- ~4500 tests visible in GitLab pipeline reports

**Remaining work:**
- Playwright → QASE integration for release validation
- Rancher downstream cluster test scenarios
- CLI test coverage expansion
- UI test scenarios for new features (Dashboards)

**Team impact:** Primarily Team Marvin (QA with Daniel Barra)

---

### 3.2 Opensource the Product (EOY 2026)

**What this means:**
- Make SUSE Observability source code publicly available
- Technical Support has requested code access

**Open questions:**
- Can we opensource on GitLab? Or must it be GitHub?
- What's the opensourcing strategy aligned with SUSE expectations?
- Licensing model?

    ----Discuss this with Mark. We need to split the build from what we release as opensource.
    ----scrub build related things automatically and push it across to github. Does not allow for contributions.

**Note:** No clear opensourcing strategy has been aligned yet

**Team impact:** Cross-team, primarily process/legal work

Update: The decision now is to open source the code but to exclude anything related to building the product. So we will
have the full code and pipelines on gitlab and mirror everything than should be open source to github.

---

## 4. Telemetry

### 4.1 Enable Usage Reporting for Features (April 2026) April will be very hard for this September ?

**What this means:**
- Track which features customers are using and how
- Understand adoption patterns across the user base

**Considerations:**
- On-prem vs. SaaS - different approaches needed
- Phone-home integration? Check-for-updates mechanism?
- **Won't work with airgap deployments** - need alternative approach
- UI tracking for feature usage analytics

**Should be straightforward** for non-airgap deployments

**Team impact:** Both teams - instrumentation work

--- Ask for a demo of what harvester and longhorn is doing from Sheng
--- Use Obsevability(Stackstate) How do we find a virtuos cycle for this.

---


//to AI ignore the rest of this file.

## ⚠️ Missing Goals (Raised with Sheng)

### CVE Management & Security Profile
- Ongoing critical work not reflected in goals
- Significant time investment from the team

### Automation of Manual CVE/Version Upgrade Work
- Currently a major time sink
- Should be a goal to reduce operational burden

### SaaS
- Is this still a goal or deprioritized?
- No mention in 2026 goals

---

## 📊 Summary: Risk Assessment

| Goal | Target | Risk Level | Key Concern |
|------|--------|------------|-------------|
| Delivery mechanism | EOY | 🟡 Medium | Scope unclear |
| AppCo plan | EOY | 🟢 Low | Ownership question |
| Stabilize product | March | 🔴 High | StackGraph rewrite conflict |
| Rancher StackPacks | March | 🟢 Low | On track |
| Security Hub | April | 🔴 High | Scope misalignment |
| QASE integration | Sept | 🟢 Low | Good progress |
| Opensource | EOY | 🟡 Medium | No strategy yet |
| Usage reporting | April | 🟢 Low | Airgap limitation |

---

## Discussion Points for Team Leads

1. **Stabilization vs. Rewrite** (Bram): What's realistic for March? Can we stabilize without the rewrite, or is the rewrite the only path to true stability?

2. **Security Hub scope** (Both): What's the minimum viable integration? Can we phase this?

3. **Stackpacks 2.0 timeline** (Remco): Are we confident in March delivery? What could derail this?

4. **Test coverage expansion** (Both): What's the priority order for QASE integration work?

5. **CVE automation**: Should we push to add this as an explicit goal?

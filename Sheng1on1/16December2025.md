# 1:1 with Sheng - December 16, 2025

---

## 1. Weekly Update (Quick Summary)

*TL;DR:*
• **Dashboarding:** Nearing release - bug fixes done, docs complete, UI tests being added
• **Stackpacks 2.0:** OTel Mapping API progressing, light-to-full stackpack conversion done
• **StackGraph Data Corruption:** Multiple fixes shipped, HDFS underreplication resolved
• **Agent:** RBAC token refresh fix merging, SLES 16 OOM fix done, Slack rate limiting fixed
• **QA:** QASE integration complete for both Playwright and Python tests
• **Infrastructure:** Elasticsearch startup improvements, chaos-2 cluster decommissioned

*(Full detailed update available if Sheng wants specifics)*

---

## 2. Security Hub Timeline - CRITICAL MISALIGNMENT (MUST DISCUSS)

### The Core Problem
**Mark and I have fundamentally different understandings of what "Security Hub" means:**

| Mark's View | My View |
|-------------|---------|
| Needs to be a "releasable thing" | Needs feature parity with NeuVector before release |
| Implies smaller scope, sooner delivery | Based on Security workshop discussions in office |
| 4-month slip from original plan | 9+ months to anything truly releasable |

### What I told Mark:
> "I don't think we will have anything 'releasable' in less than 9 months."

### My response to Mark earlier:
- The Stackpacks 2.0 work should make Security Hub integration easier
- Frontend team has planned theme switching work to simplify things
- Team feels we need to unlock other teams with great Stackpacks work first
- The real risk for SUSE Security is on the **agent side**, not our platform

### Questions for Sheng:
1. **What is the actual scope expectation?** 
   - Minimal "releasable" integration (Mark's view)?
   - Feature parity with NeuVector (my understanding from workshop)?
2. Where did this misalignment come from? Was something communicated that I missed?
3. How do we reconcile the April KubeCon goal with either timeline?
4. Should we have a 3-way alignment call (you, me, Mark)?

### 💡 How to Handle This:

**DO:**
- Frame as "seeking clarity" not "Mark is wrong"
- Ask Sheng what *he* understood the scope to be
- Propose a scope definition meeting with all stakeholders
- Offer options: "If scope is X, timeline is Y. If scope is A, timeline is B."

**DON'T:**
- Make it adversarial between you and Mark
- Commit to a timeline without scope clarity
- Let this fester - it needs resolution now

**Suggested framing:**
> "Mark and I realized we have different understandings of Security Hub scope. He's thinking 'releasable integration' while I understood from the workshop that we needed NeuVector feature parity. Can you help clarify what the actual expectation is? Because those are very different timelines - 4 months vs 9+ months."

**Possible outcomes to push for:**
1. **Define MVP scope explicitly** - What's the minimum "releasable" thing?
2. **Phase the delivery** - MVP by April, full parity by EOY?
3. **Adjust the goal** - If parity is required, April is unrealistic

---

## 3. 2026 Goals Review (From Sheng)

### Productization
| Goal | Target | My Questions/Concerns |
|------|--------|----------------------|
| Improve delivery mechanism for on-prem Prime | EOY 2026 | What does this mean? Cadence? One-click install? AppCo? We're already working on helm values chart replacement. Rancher Extension handles a lot. |
| Plan for delivery via AppCo | EOY 2026 | Have a *plan* or *deliver*? This is mostly AppCo team's work - how can this be our goal? |
| Stabilize the product | March 2026 | If we need to switch technology (StackGraph rewrite), March is NOT viable. Should this be timeboxed instead of date-driven? |

### Stack Harmonization
| Goal | Target | My Questions/Concerns |
|------|--------|----------------------|
| StackPack feature for Rancher portfolio integration | March 2026 | Stackpacks 2.0 should make this easy. Why duplicate roadmap items? |
| Deliver Security Hub | KubeCon Europe (April 2026) | **CONFLICT:** Mark says 4-month slip. How do we limit scope? Kubewarden-only on Stackpacks 2.0? Just color/theme changes? |

### Operations
| Goal | Target | My Questions/Concerns |
|------|--------|----------------------|
| Integrate all test cases with QASE | September 2026 | QA team goal - reasonable |
| Opensource the product | EOY 2026 | Technical Support wants code access. Can we opensource on GitLab? Still no opensourcing strategy aligned with SUSE expectations. |

### Telemetry
| Goal | Target | My Questions/Concerns |
|------|--------|----------------------|
| Enable usage reporting for features | April 2026 | On-prem? SaaS? Phone-home integration? Check-for-updates? Won't work with airgap. Should be straightforward otherwise. |

### ⚠️ Missing Goals I Expected to See:
- **CVE management & security profile** - This is ongoing critical work
- **Automation of manual CVE/version upgrade work** - Major time sink currently

### ❓ Unclear Items:
- **SaaS** - Is this still a goal or not?
- **Kubewarden as first Stackpacks 2.0 use case** - Is ImageScanner included?

**💡 Tips for Discussion:**
1. Push back on hard dates for "Stabilize" - ask for timeboxed approach instead
2. Clarify ownership: "Is AppCo delivery *our* goal or *their* goal with our support?"
3. Ask about Security Hub scope reduction given the slip
4. Raise missing CVE automation goal - this is real work we're doing

---

## 4. Test Coverage Discussion (Follow-up from last week)

**Link to share:** Test report showing ~4500 tests:
https://gitlab.com/stackvista/stackstate/-/pipelines/2218235101/test_report

**Note:** JUnit XML test reports can be imported into QASE

**Open questions from last week:**
- How long does the nightly test run take?
- Need full report of all testing coverage

**💡 Tip:** If Sheng asks about test coverage progress, share the GitLab link and mention QASE integration is complete.

---

## 5. StackGraph Rewrite (Ongoing Topic)

**Status:** The rewrite needs to happen - this is acknowledged.

**Impact on goals:**
- Makes "Stabilize by March" unrealistic if rewrite is in scope
- Need to clarify: Is stabilization *with* or *without* the rewrite?

**💡 Tip:** Ask directly: "Does 'stabilize' mean fixing current issues or completing the rewrite?"

---

## 6. Action Items from Last Week

| Item | Status |
|------|--------|
| File EIO ticket for NeuVector access | ❓ Check if done |
| Get nightly test run duration | ❓ Pending |
| Full testing coverage report | ❓ Pending |

---

## My Agenda for Tonight

1. **Quick update** - Share TL;DR, offer details if wanted
2. **Security Hub slip** - Align on what this means for 2026 goals
3. **2026 Goals clarification** - Go through my questions above
4. **Test coverage** - Share GitLab link, discuss QASE progress
5. **StackGraph rewrite** - Clarify timeline expectations

---

## Conversation Starters

- "I heard from Mark that Security Hub might slip 4 months - was this already on your radar?"
- "Looking at the 2026 goals, I have some clarifying questions about scope and ownership..."
- "The team is making great progress on Stackpacks 2.0 - this should unlock Security Hub integration"
- "On stabilization - if StackGraph rewrite is in scope, March isn't realistic. Can we discuss?"

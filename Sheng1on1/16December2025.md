# 1:1 with Sheng - December 16, 2025

## 📋 Discussion Checklist

- [ ] **Weekly Update** - Share TL;DR (Section 1)
- [ ] **�  Process Enforcer Update** - Good news from Security collaboration (Section 1.5)
- [ ] **🔴 Security Hub Scope** - Critical misalignment with Mark, need clarity (Section 2)
- [ ] **2026 Goals** - Clarify "Stabilize", AppCo ownership, missing CVE goal (Section 3)
- [ ] **Test Coverage** - Share GitLab link, QASE integration done (Section 4)
- [ ] **StackGraph Rewrite** - Does "stabilize" include the rewrite? (Section 5)
- [ ] **Action Items** - NeuVector EIO ticket done, test duration still pending (Section 6)
- [ ] **Technical Leadership** - Share strategy + customer feedback alignment (Section 7)
   Missing the meeting yesterday. No heads up or question on whether I'm available etc. Generally being excluded from most meetings where Mark is present. Simply missed it.

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

## 1.5 Process Enforcer Update (SUSE Security Collaboration) - GOOD NEWS

**Context:** Sam Wang and Kyle Dong from our teams have been contributing to the Process Enforcer project with the SUSE Security team.

### Major Development This Week
- **Andrea Terzolo built a custom eBPF agent during hack week** that replaces the Tetragon dependency
- Approved by both Flavio Castelli and Alessio Biancalana, **merged to main December 15th**
- **Memory usage dropped from 3MB per policy to KB-level** - massive improvement
- Risk assessed as minimal per Alessio

### Project Health
| Metric | Status |
|--------|--------|
| Items Done | 97 ✅ |
| Items Blocked | 2 (tracking only - not actually blocking) |
| Timeline | On track for March 2026 |

### Our Team's Contributions
- **Kyle Dong:** Upstreamed socktrack_map optimization (merged in Tetragon v1.7.0), saves ~2.8 MB/policy
- **Sam Wang:** Working on shared override_tasks map PR, reviewed Andrea's agent work
- Both are now wrapping up upstream PRs as "good citizenship" - no longer critical path since custom agent approach decouples from Tetragon

### Key Quote from Alessio:
> "The risk is minimal actually, in the beginning I was a little bit worried but since we managed to swap what we had on main with Andrea's implementation I'm very confident"

### Productization Path (NEW INFO)
- **Flavio and Davide are pushing to make Process Enforcer part of Kubewarden**
- This means it will become a **CNCF project** with certification and community governance
- Kubewarden is evolving into the foundation for **SUSE Security 6.0**
- Per Alessio: "The productization phase will require a little bit of time but not much"

**💡 Why mention this to Sheng:**
- Shows strong cross-team collaboration between Observability and Security
- Our engineers are contributing meaningfully to a strategic SUSE initiative
- The March 2026 timeline aligns with Security Hub discussions
- Demonstrates technical leadership from Sam and Kyle
- **Kubewarden/CNCF path** shows Security team has clear productization strategy independent of us

---

## 2. Security Hub Timeline - CRITICAL MISALIGNMENT (MUST DISCUSS)

### The Core Problem
**Mark and I have fundamentally different understandings of what the "Security Hub"  deliverables for2026 meant:**

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

Mostly about the operator. not easy to deliver with yaml etc.


| Improve delivery mechanism for on-prem Prime | EOY 2026 | What does this mean? Cadence? One-click install? AppCo? We're already working on helm values chart replacement. Rancher Extension handles a lot. |
| Plan for delivery via AppCo | EOY 2026 | Have a *plan* or *deliver*? This is mostly AppCo team's work - how can this be our goal? |
| Stabilize the product | March 2026 | If we need to switch technology (StackGraph rewrite), March is NOT viable. Should this be timeboxed instead of date-driven? |

### Stack Harmonization
| Goal | Target | My Questions/Concerns |
|------|--------|----------------------|
| StackPack feature for Rancher portfolio integration | March 2026 | On track already |
| Deliver Security Hub | KubeCon Europe (August experimental 2026) | **CONFLICT:** Mark says 4-month slip. How do we limit scope? Kubewarden-only on Stackpacks 2.0? Just color/theme changes?  All the Stackpacks 2.0 work will make this a lot easier|

### Operations
| Goal | Target | My Questions/Concerns |
|------|--------|----------------------|
| Integrate all test cases with QASE | September 2026 | QA team goal - reasonable |
| Opensource the product | EOY 2026 | Technical Support wants code access. Can we opensource on GitLab? Still no opensourcing strategy aligned with SUSE expectations. |

### Telemetry
| Goal | Target | My Questions/Concerns |
|------|--------|----------------------|
| Enable usage reporting for features | April 2026 | On-prem? SaaS? Phone-home integration? Check-for-updates? Won't work with airgap. Should be straightforward otherwise. 
UI tracking ???| how many people is using our software and what features are they using.

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

The current QASE Beest tests no not show the full spin up and spin down time. Only the time the tests are running.

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
| File EIO ticket for NeuVector access | ✅ Created today - didn't need access last week so it didn't reach top of todolist until now |
| Get nightly test run duration | ❓ Pending |
| Full testing coverage report | ❓ Pending |

---

## 7. Follow-up: Technical Leadership Feedback (From 2 Weeks Ago)

**The feedback:** Sheng asked me to play a more active role in leading the team technically, understanding customer needs, and being able to speak for the team on these issues.

**My strategy to address this:**

1. **Knowledge Management System** (this repo)
   - Centralizing meeting notes, technical decisions, and feature context
   - Building a reference I can draw from when speaking to stakeholders
   - Work in progress, but already helping me prepare for discussions like this one

2. **Blog Posts on Major Features**
   - Writing about features (done and upcoming) to:
     - Promote the team's work externally
     - Share knowledge within SUSE
     - Deepen my own technical understanding through the writing process
   - First target: Dashboarding (already have demo notes and feature overview prepared)
   - Future: Stackpacks 2.0, StackGraph evolution

3. **Closer Engagement with Customer Feedback**
   - Using Jira exports and Slack channel monitoring to stay on top of issues
   - Building context on what customers are actually asking for

### 📊 Evidence: Our Work Aligns with Customer Needs

I've consolidated customer feedback from ~18 months of Slack channels and support tickets. Here's how our current work maps directly to the top pain points:

| Customer Pain Point (Persistent 18+ months) | Our Response |
|---------------------------------------------|--------------|
| **Custom Dashboarding** - #1 feature request since early 2025 | ✅ Releasing after hack week |
| **RBAC agent token refresh bug** - 24hr expiry causing SRA failures | ✅ Fix merging now |
| **StackGraph/Tephra data corruption** - #1 operational concern | ✅ Multiple fixes shipped this quarter |
| **Stackpacks extensibility** for non-K8s workloads | ✅ Stackpacks 2.0 OTel Mapping API in progress |

**Key insight:** The RBAC token refresh fix was explicitly listed as an "Immediate Q1 2026" recommendation in my customer feedback analysis - we're already ahead of that timeline.

**💡 How to present this:**
> "I've been consolidating customer feedback from the last 18 months. What's encouraging is that our current priorities directly address the top pain points: Dashboarding was the #1 feature request, the RBAC token refresh bug we're fixing now was flagged as critical, and StackGraph stability has been the #1 operational concern - which we've been actively fixing. We're not just doing technical work, we're responding to what customers actually need."

**💡 How to present this:**
> "I've been thinking about your feedback on technical leadership. I've started building a knowledge management system to track our technical decisions and feature context - it's helping me prepare for conversations like this one. I'm also planning to write blog posts about our major features, starting with Dashboarding. The writing process forces me to understand things deeply, and it promotes the team's work. Does this align with what you had in mind?"

---

## My Agenda for Tonight

1. **Quick update** - Share TL;DR, offer details if wanted
2. **Security Hub slip** - Align on what this means for 2026 goals
3. **2026 Goals clarification** - Go through my questions above
4. **Test coverage** - Share GitLab link, discuss QASE progress
5. **StackGraph rewrite** - Clarify timeline expectations
6. **Technical leadership feedback** - Share my strategy (knowledge repo + blog posts)

---

## Conversation Starters

- "I heard from Mark that Security Hub might slip 4 months - was this already on your radar?"
- "Looking at the 2026 goals, I have some clarifying questions about scope and ownership..."
- "The team is making great progress on Stackpacks 2.0 - this should unlock Security Hub integration"
- "On stabilization - if StackGraph rewrite is in scope, March isn't realistic. Can we discuss?"

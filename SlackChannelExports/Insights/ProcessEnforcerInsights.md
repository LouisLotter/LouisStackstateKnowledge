# Process Enforcer Initiative - Insights Summary

**Channel:** #discuss-process-enforcer  
**Date Range:** October 8, 2025 - December 17, 2025  
**Purpose:** Technical collaboration between SUSE Security (NeuVector) and observability teams on the new Tetragon-based process enforcer

---

## Executive Summary

The Process Enforcer is a new runtime security component originally built on Cilium's Tetragon, now using a **custom eBPF agent** to replace/enhance NeuVector's existing process enforcement capabilities. The project made a major architectural pivot during hack week (December 2025) where Andrea Terzolo built a custom agent, which has been **approved by both Flavio and Alessio** and merged to main.

**Target:** March 2026 release (non-GA but production-quality)

### Latest Status (Week of December 16, 2025)
- **Andrea:** Finalized custom agent implementation (hack week output)
- **Sam & Kyle:** Reviewed Andrea's work + wrapped up lingering Tetragon upstream work
- **Alessio & Kyle:** Finalized WorkloadPolicyProposal CRD rework
- **Next sprint:** Finalize remaining TODO items from agent merge
- **Following sprint:** Start wrapping up for delivery

---

## Key Technical Challenges Identified & Resolved

### 1. eBPF Scalability Limits (RESOLVED)
**Problem:** Tetragon had hard limits that blocked enterprise-scale deployments:
- 38 policy limit from `BPF_MAX_TRAMP_LINKS` (eBPF trampoline limit)
- 128 policy limit from internal map sizing
- ~7-8 MB memory per policy (unacceptable for large clusters)

**Solutions Implemented:**
- Kyle Dong upstreamed `socktrack_map` optimization (merged in Tetragon v1.7.0) - saves ~2.8 MB/policy
- `BPF_F_NO_PREALLOC` flag for policy maps - reduces memory from ~7MB to ~1.5MB per policy
- Sam Wang working on shared `override_tasks` map PR (#4244)
- Policy filter map size now configurable

**Current State (with Tetragon):** Memory reduced from ~8MB to ~1.5-2MB per policy (73% reduction)

**🎉 Custom Agent Result:** Memory now down to **"some KB per policy"** (per Alessio) - from 3MB to KB-level. This is a massive improvement that makes the custom agent approach clearly worthwhile.

### 2. Per-CPU Memory Scaling (IDENTIFIED)
**Problem:** Per-CPU arrays scale with core count:
- 16 cores → ~1.9 MB per policy
- 96 cores → ~8.3 MB per policy  
- 384 cores (AWS max) → potentially much higher

**Key Maps Affected:**
- `process_call_heap`: 25,612 bytes × ncpu
- `string_maps_heap`: 16,388 bytes × ncpu
- `data_heap`: 32,772 bytes × ncpu

**Status:** Documented, potential optimization paths identified but not yet prioritized

### 3. Kernel Compatibility Matrix
**Findings:**
- `fmod_ret` (BPF_MODIFY_RETURN) requires Linux 5.7+
- LSM BPF requires Linux 5.7+ and `CONFIG_BPF_LSM`
- ARM eBPF trampoline requires Linux 6.0+
- Amazon Linux 8.8 (kernel 4.18) is problematic - may need exclusion

**Supported Distros Verified:**
- SLE Micro 6.0, SLES 15 SP7, Leap 15.6 (kernel 6.4)
- Ubuntu 22.04 LTS (kernel 5.15)
- Rocky Linux 9.4 (kernel 5.14)
- RHEL 10 (kernel 6.12)

---

## Major Architectural Pivot (December 2025)

### Custom Agent Replaces Tetragon Dependency

**Decision:** During hack week, Andrea Terzolo built a custom eBPF agent that extracts only the Tetragon components needed, eliminating the full Tetragon dependency.

**Rationale:**
- Persistent performance issues with Tetragon's generic approach
- Upstream PRs taking too long to merge
- Need for tighter control over eBPF program behavior
- Simpler codebase focused on specific use case

**PR #79 Status:** ✅ Merged December 15, 2025 - **Approved by both Flavio Castelli and Alessio Biancalana**

**Risk Assessment (per Alessio):**
> "The risk is minimal actually, in the beginning I was a little bit worried but since we managed to swap what we had on main with Andrea's implementation I'm very confident"

**Memory Impact:**
> "As a gain we actually lowered memory usage from 3 megs per policy to some KB per policy" - Alessio Biancalana

**Remaining Work (Detailed Backlog from Team):**

*Note: Some items are duplicates, some not required for technical preview stage*

**Container/Pod Metadata & Lifecycle:**
- Support OCI hook to get pod/containers metadata as soon as they are created
- Investigate filesystem scraping instead of CRI client to retrieve cgroupID
- Add cache for deleted pods/containers (handle delay in event processing)
- Investigate if pod can have generated name without ownerReference
- Check if cgroup path is correct at startup instead of during execution
- Send initial /proc state when the agent starts
- Missing retry logic for cgroup resolution failures

**Policy & Rules:**
- Support workloadPolicy update on RulesByContainer field
- Investigate if we can exclude learning events from processes on the node (not inside a pod)
- Define protection strategy between upgrades
- Understand how to manage overlapping policy eBPF side

**eBPF & Kernel:**
- Pin eBPF programs/maps
- Improve eBPF map lifecycle management
- Investigate if we can use batch eBPF operations when updating maps
- Support protect mode on kernels that don't have fmod_ret
- Test eBPF program with multiple kernels
- Add unit/e2e-test to check cgroupv1 support
- Support configurable procfs and cgroupfs
- Add linter for BPF programs

**Observability & Debugging:**
- Associate the OTEL span with the policy that generated the violation
- Provide metrics of eBPF programs to userspace for debugging
- Send eBPF debug logs to userspace
- Review event fields to make them actionable

**Security & Operations:**
- Daemon should run with minimal capabilities

**Testing:**
- Check if the e2e test issue on OTEL is resolved

---

## CRD Design Evolution

### Final CRD Structure (v0.2.0)
1. **WorkloadPolicyProposal** (renamed from WorkloadSecurityPolicyProposal)
   - Learning mode output
   - `rulesByContainer` structure implemented

2. **PodPolicy** (renamed from WorkloadSecurityPolicy)
   - Simplified from original design
   - Status field replaces separate `WorkloadSecurityPolicyTuning` CRD
   - Label selector approach for flexibility

3. **ClusterWorkloadSecurityPolicy** - Removed

### Key Design Decisions:
- No strict `security.rancher.io/policy` label requirement - users can use standard k8s selectors
- Status reporting per-node with conditions for failed nodes
- Workload-based policy binding (Deployment, StatefulSet, DaemonSet, CronJob)
- Standalone pods explicitly not supported (by design)

---

## Upstream Contributions

| PR/Issue | Status | Impact |
|----------|--------|--------|
| tetragon#4211 (socktrack_map) | ✅ Merged | -2.8 MB/policy |
| tetragon#4244 (shared override_tasks) | 🔄 In Review | Removes 38 policy limit |
| tetragon#4340 (BPF_F_NO_PREALLOC flag) | 🔄 In Review | -73% memory |
| tetragon#4331 (policy filter map size) | 🔄 In Review | Removes 128 policy limit |
| tetragon#4191 (scalability discussion) | 📝 Open | Long-term architecture |

---

## Team & Collaboration Model

**SUSE Security Team:**
- Flavio Castelli - Technical leadership
- Alessio Biancalana - Project coordination, CRD rework
- Andrea Terzolo - eBPF expertise, custom agent author
- Davide Iori - Product/UX

**SUSE Observability (Contributing):**
- Sam Wang - Tetragon expertise, upstream contributions
- Kyle Dong - Memory optimization, upstream PRs
- Bram Schuur - Architecture input

**Collaboration Pattern:**
- Daily standups (paused during hack week)
- Weekly planning/refinement
- Active upstream engagement with Tetragon community
- Shared GitHub project board

---

## Product Alignment

### March 2026 Target Scope:
- Process enforcement (allow/deny executables)
- Learn → Monitor → Enforce workflow
- Per-workload policies (not per-node)
- Kubernetes-native CRDs

### Explicitly Deferred:
- File system access enforcement (low customer priority per field feedback)
- Policy templating (requested but not MVP)
- Container-level selectors

### Field Feedback (December 16, 2025):
- ✅ K8s-native CRDs approach validated
- ✅ Learn-Monitor-Enforce UX preserved
- ⚠️ Templating needed for advanced customers (post-MVP)
- ℹ️ File enforcement not primary use case

---

## Productization Strategy (December 17, 2025)

### Kubewarden Integration
**Key development:** Flavio and Davide are pushing to make the Process Enforcer **part of Kubewarden**.

**What is Kubewarden?**
- CNCF Sandbox project for Kubernetes policy management
- Policy engine that uses WebAssembly for policy execution
- Already part of SUSE's security portfolio
- Provides admission control and runtime policies

**Implications:**
- Process Enforcer will become a **CNCF project** component
- Gets "product goodies" - certification, community governance, etc.
- Positions as part of **SUSE Security 6.0** evolution
- The custom eBPF agent will be opensourced/promoted through Kubewarden

### Productization Timeline (per Alessio)
> "To release it that's basically the plan, the productization phase will require a little bit of time but not much I think"

**Current focus:** Finalizing the core functionality first, productization planning in parallel

### Strategic Context
This aligns with the broader SUSE Security strategy:
- Kubewarden evolving into SUSE Security 6.0 foundation
- Process Enforcer adds runtime enforcement to Kubewarden's admission control
- Combined offering: admission policies (Kubewarden) + runtime enforcement (Process Enforcer)

---

## Project Board Status (December 17, 2025)

**Source:** GitHub Project Board - Runtime Enforcer

| Column | Count | Notes |
|--------|-------|-------|
| No Status | 6 | Backlog/triage items |
| Todo | 22 | Prioritized work |
| In Progress | 7 | Active development |
| Pending Review | 5 | Awaiting review |
| Blocked | 2 | Upstream dependencies |
| **Done** | **97** | ✅ Significant progress |

### "Blocked" Items (Tracking Only - Not Actually Blocking)
Per Alessio: "We are just wrapping up the work so we are not labeled as bad actors that leave the work open but the most important things now are inside the repo. The blocked items right now are just there for tracking's sake."

1. **Upstream discussion on supporting use case by default** - Cleanup/good citizenship
2. **128 policy limit error** - Tetragon workaround (Kyle's PR in review) - nice-to-have, not critical path

### Active Work (In Progress)
- `BPF_F_NO_PREALLOC` evaluation (memory optimization)
- Policy rules update behavior fix
- Container image signing with cosign
- **[EPIC] WorkloadPolicy rework** - Major CRD refactoring

### Backlog Highlights (No Status/Todo)
- **ARM Support** - Feature request tracked
- **OpenTelemetry integration** - Metrics and traces for observability
- **Platform support spreadsheet** - Documentation needed
- **Init container vs main container policy separation** - Enhancement
- **Bash script whitelist investigation** - Security consideration
- **Live demo environment deployment** - Validation milestone

### Labels in Use
- `tetragon-workaround` - Items requiring upstream fixes or workarounds
- `enhancement` - New features
- `documentation` - Docs work
- `github_actions` - CI/CD improvements

---

## Risk Assessment

| Risk | Severity | Mitigation |
|------|----------|------------|
| Custom agent maintenance burden | Medium | Focused scope, documented links to Tetragon source |
| Upstream PR delays | Low | Custom agent eliminates dependency; "blocked" items are just tracking/cleanup |
| Memory on high-core systems | Medium | Documented, optimization paths identified |
| ARM support gaps | Low | Linux 6.0+ requirement documented; tracked in backlog |
| March timeline | Medium | 97 items done, MVP scope well-defined |

---

## Action Items for Status Update

1. **Highlight the pivot:** Custom agent merged, reducing Tetragon dependency
2. **Memory wins:** 73% reduction achieved through upstream contributions
3. **CRD rework:** In progress on `crd-rework` branch
4. **Timeline:** On track for March 2026 with defined MVP scope
5. **Team collaboration:** Strong cross-team engagement, active upstream participation

---

## Key Quotes

> "If we really want to hook the LSM api we cannot go under 5.7" - Andrea Terzolo

> "All we made should be made with production in mind if it comes to Agent code running on customer systems... We don't call it GA but we should aim for GA standards" - Mark Bakker

> "We are on the right path" - Davide Iori (after field validation call)

---

*Last Updated: December 17, 2025*

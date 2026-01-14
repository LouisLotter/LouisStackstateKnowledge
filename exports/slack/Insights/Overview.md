# SUSE Observability Customer Feedback Overview

**Consolidated Analysis: March 2024 - December 2025**  
**Sources:** #discuss-observability-stackstate, #prod-ranchersupport-suseobservability

---

## Executive Summary

This document synthesizes customer feedback from three separate analyses spanning ~18 months. The consistency of themes across time periods and channels validates these as **systemic issues** requiring strategic attention, not isolated incidents.

### Top 5 Persistent Pain Points (All Sources Agree)

| Issue | Severity | Duration | Status |
|-------|----------|----------|--------|
| **1. Installation/Upgrade Complexity** | Critical | 18+ months | Ongoing |
| **2. RBAC/Authentication Limitations** | High | 18+ months | v2.5.0 shipped, issues remain |
| **3. Storage Compatibility (Longhorn/NFS)** | High | 18+ months | Documented, not solved |
| **4. Licensing/SCC Key Distribution** | Medium | 12+ months | Bulk fix done, still recurring |
| **5. Documentation Gaps** | Medium | 18+ months | Incremental improvements |

---

## 1. Installation & Deployment (CRITICAL - All Sources)

### Consistent Themes Across All Periods

**Upgrade Stability** - The #1 operational concern:
- Tephra/HBase data corruption during upgrades (mentioned in ALL three analyses)
- Custom integrations/stackpacks breaking during upgrades
- Rabobank incident (weekend support required) cited multiple times
- Recovery often requires settings backup restore or PVC deletion

**Air-Gapped Deployments**:
- Documentation gaps persist (helm commands reference wrong sources)
- Image registry configuration confusion
- Customers (Infosys, others) repeatedly struggle

**Resource/Startup Issues**:
- Pods failing liveness/readiness probes
- Kafka topic creation timing causing cascading failures
- CPU throttling causing Tephra startup failures (fixed in v2.1.0)

**Storage Requirements**:
- **SSD required** - not clearly documented initially
- **Longhorn/NFS NOT recommended** - causes data corruption
- Customers repeatedly discover this the hard way

> **Key Quote:** "The cost for such a setup is just too high - had to setup a system with 3 master+12 worker just to get this running for monitoring an environment of 30 nodes" - Martin Weiss

---

## 2. Authentication & RBAC (HIGH PRIORITY - All Sources)

### Evolution Over Time

| Period | Status | Key Issues |
|--------|--------|------------|
| Mar-Aug 2025 | #1 request | Namespace-scoped RBAC missing |
| Jul-Dec 2025 | v2.5.0 shipped | OIDC integration complexity, token expiry bugs |
| Support Channel | Ongoing | Certificate chain issues, OIDC setup confusion |

### Persistent Issues (Even After v2.5.0)
- Rancher OIDC integration trips up many customers
- Azure AD / Keycloak group prefix mismatches
- **RBAC agent token refresh bug** - 24hr expiry causes recurring failures
- CORS configuration required after 2.4.0 (not prominently documented)
- `?client_name=StsOidcClient` callback URL requirement unclear

### What Customers Actually Need
> "Members belonging to a specific team should only see their namespace workloads, metrics, logs"

---

## 3. Feature Gaps (Consistent Across All Sources)

### Logging - The Biggest Gap

| Capability | Status | Timeline |
|------------|--------|----------|
| Pod logs (stdout) | ✅ Supported | Available |
| OTLP Logs | ❌ Not supported | Q4 2026 |
| System logs (journalctl) | ❌ Not supported | Q4 2026 |
| Linux/Windows host logs | ❌ Not supported | Q4 2026 |
| Log shipping to external systems | ❌ Not supported | TBD |

**Customer Impact:** OTLP logs pushed to Q4 2026 caused "major disappointment"

### Other Consistent Feature Requests

| Feature | First Requested | Current Status |
|---------|-----------------|----------------|
| Custom Dashboarding | Early 2025 | Releasing KubeCon NA 2025 |
| CRD Monitoring | Mid 2025 | 2026+ roadmap |
| Control Plane Monitoring | Mid 2025 | Not OOTB |
| FinOps/Cost Management | 2025 | 18+ months out |
| Edge/Offline Support | 2025 | "Years away" |
| Non-K8s Workloads (VMs) | 2025 | Stackpacks 2.0 will help |

---

## 4. Sizing & Resource Concerns (Consistent Theme)

### The Core Problem
Customers perceive SUSE Observability as **too expensive to run** for smaller deployments.

### Specific Issues (All Sources)
- 150-HA minimum for production HA is prohibitive
- Cannot upgrade non-HA to HA (requires reinstall)
- No smaller HA profiles available
- Memory-heavy nodes skew sizing calculations
- Trial setups hitting component limits with large clusters

### Roadmap Response
- Smaller HA profiles planned for H2 2026
- Resource optimization work acknowledged but not prioritized

---

## 5. Licensing & SCC (Recurring Operational Issue)

### Problems Identified
- SCC-generated keys frequently wrong format or missing
- Rancher Suite customers don't automatically get Observability keys
- NFR/MSP subscriptions particularly problematic
- Internal employees unclear on process

### Actions Taken
- Bulk fix of 500+ keys (August 2025)
- Process documented but still manual

### Clarifications Needed (Customers Confused)
1. Management nodes are FREE (don't count toward license)
2. SUSE Observability included in Rancher Prime
3. Cannot run outside Rancher without separate license

---

## 6. Documentation Gaps (Persistent Across All Sources)

### Most Frequently Cited Gaps

| Gap | Impact | Status |
|-----|--------|--------|
| Air-gapped installation | High | Fixed Dec 2025 |
| SSD storage requirement | High | Now documented |
| OIDC callback URL format | High | Improved |
| CORS configuration | Medium | Documented |
| Sizing for memory-heavy clusters | Medium | Still unclear |
| Service token vs API key migration | Medium | Needs work |
| Port requirements for firewalls | Medium | Requested |
| OpenTelemetry HTTP ingress | Medium | Requested |

### Customer Feedback Pattern
> "Docs say optional but it's actually required"  
> "Installation steps very difficult to find via Google"  
> "New permissions don't match documentation"

---

## 7. Support Patterns & Escalation

### High-Touch Customers (Mentioned Multiple Times)
- **Rabobank** - Multiple incidents, custom stackpack, weekend support
- **Kroger** - OIDC issues, feature requests
- **BASF** - Linux logs requirement, roadmap discussions
- **Solidigm** - Long-term roadmap questions
- **Infosys** - Air-gapped deployment struggles

### What Works Well
- Quick response to critical incidents (weekend support appreciated)
- Detailed incident reports valued
- Support package collection tool helpful
- Playground environment (observability.suse.com) valuable

### What Needs Improvement
- Log collection script (STAC-21890) - repeatedly requested
- Clearer escalation paths
- Better troubleshooting documentation

---

## 8. Positive Signals (Don't Lose Sight)

### Customer Appreciation
- "SUSE support really helped us well" - Rabobank
- Dapr integration success - Sandvik
- Release process improvements praised
- Self-monitoring stackpack useful

### Product Strengths
- Topology visualization unique differentiator
- Time-travel capability valued
- Rancher integration improving
- RBAC release (v2.5.0) addresses top request

---

## 9. Consolidated Recommendations

### Immediate (Q1 2026)
1. **Fix RBAC agent token refresh bug** - 24hr expiry causing SRA failures
2. **Improve OIDC error messages** - Customers struggle silently
3. **Document CORS requirements prominently** - Breaking change from 2.4.0
4. **Create log collection script** - STAC-21890, requested for 12+ months

### Short-Term (H1 2026)
1. Add Rancher service annotations OOTB for long-polling services
2. Create compatibility matrix (values chart, agent, extension versions)
3. Improve control plane monitoring OOTB
4. Streamline license key distribution via SCC

### Medium-Term (H2 2026)
1. Smaller HA profiles for cost-sensitive customers
2. Non-HA to HA upgrade path
3. OTLP logs support (currently Q4 2026)
4. System-level logs collection

### Strategic (2027+)
1. CRD support in topology
2. Edge deployment optimization
3. FinOps/cost management
4. Non-K8s workload native support

---

## 10. Key Metrics to Track

| Metric | Current State | Target |
|--------|---------------|--------|
| Upgrade success rate | Unknown (incidents common) | >95% |
| Time to first data | Unknown | <30 min |
| OIDC setup success rate | Low (many support tickets) | >80% |
| Documentation satisfaction | Low (gaps cited) | Positive feedback |
| Support ticket volume | High | Reduce by 30% |

---

## Appendix: Source Document Summary

| Document | Period | Focus |
|----------|--------|-------|
| CustomerFeedbackInsights.md | Mar-Aug 2025 | General feedback, feature requests |
| DiscussObservabilityPart2Insights.md | Jul-Dec 2025 | Technical issues, RBAC release |
| supportInsights.md | Jul-Dec 2024 | Support patterns, tooling needs |

---

*Last Updated: December 2025*  
*Next Review: March 2026*

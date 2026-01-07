# SUSE Observability Customer Feedback Insights

**Analysis Period:** March 2025 - August 2025  
**Source:** #discuss-observability-stackstate Slack channel exports  
**Generated:** December 2025

---

## Executive Summary

This analysis covers ~6 months of customer interactions in the SUSE Observability support channel. The data reveals clear patterns in customer pain points, feature requests, and operational challenges that inform product priorities and support strategies.

**Key Themes:**
1. Installation & deployment complexity (especially OpenShift, certificates)
2. Authentication/RBAC limitations (most requested feature)
3. Licensing/SCC key distribution issues
4. Upgrade stability concerns (Tephra/HBase data corruption)
5. Integration gaps (logs, CRDs, non-K8s workloads)

---

## 1. Installation & Deployment Issues

### OpenShift/ARO Challenges
- **SecurityContextConstraints (SCC)** causing ClickHouse pods to fail
- Customers need explicit guidance on OpenShift-specific configurations
- Pod security context settings frequently need adjustment

### Certificate/TLS Issues
- Self-signed certificates require `skipSslValidation` workaround
- Customers confused about where to configure custom CAs (server vs agent)
- LDAP authentication with custom CAs particularly problematic
- Java certificate validation stricter than other tools (Grafana, etc.)

### Resource Sizing & Startup
- Pods failing liveness/readiness probes during initial startup
- Customers underestimating resource requirements
- NFS storage **not recommended** for production (causes issues)
- SSD storage required but not clearly documented
- Kafka topic creation timing issues causing cascading failures

### Common Installation Questions
- "What profile should I use for X nodes?"
- "Can I use local-path-provisioner?"
- "Why are pods in CrashLoopBackOff?"

---

## 2. Authentication & RBAC (Highest Priority)

### Current State Feedback
- **#1 customer request**: Namespace-scoped RBAC
- Current RBAC only scopes topology, not metrics/logs/traces
- Customers need team-based access control per namespace
- LDAP/OIDC configuration complex and error-prone

### Specific Customer Requests
- "Members belonging to a specific team should only see their namespace workloads, metrics, logs"
- Integration with Rancher roles/RBAC
- Service token management for multi-cluster deployments

### Known Issues
- Custom role syntax errors in YAML cause silent failures
- `redirectUri` often needs explicit configuration despite docs saying optional
- Certificate chain validation issues with LDAP

### Status
- RBAC with Rancher integration is **top priority** (in development)
- New RBAC agent required for full functionality
- Internal teams (itpe-core) eager to be early testers

---

## 3. Licensing & SCC Key Distribution

### Recurring Problems
- SCC-generated keys frequently wrong format or missing
- Rancher Suite customers don't automatically get Observability keys
- NFR subscriptions often missing Observability entitlement
- Internal employees unclear on how to obtain keys

### Process Issues
- Keys must be requested via SD ticket to SCC team
- Bulk fix of 500+ keys done in August 2025
- MSP subscriptions particularly problematic
- No automated key generation for SUSE AI Suite customers

### Workarounds
- Engineering generating ad-hoc keys (not sustainable)
- Keys can only expire at end of months (limitation)

---

## 4. Upgrade & Stability Issues

### Tephra/HBase Data Corruption
- Multiple customers affected by data corruption during upgrades
- "Cannot un-exist verified existing stackelement" errors
- Nightly "champagne" corruption issues
- Fixes shipped in 2.3.6+ but intermittent issues persist

### Upgrade Challenges
- 2.3.4 → 2.3.6/2.3.7 upgrades particularly problematic
- Custom integrations/stackpacks break during upgrades
- Data migration bugs affecting customers with custom configurations
- Rabobank incident required weekend support intervention

### Recovery Procedures
- Settings backup restore clears StackGraph (fastest recovery)
- Manual PVC deletion sometimes required
- Customers requesting better upgrade documentation

---

## 5. Feature Gaps & Requests

### Logging
- **Pod logs only** - no support for:
  - Linux/systemd logs
  - Windows Event Viewer
  - Graylog integration
  - General log shipping to external systems (ELK)
- "Generalized logging" on roadmap for 2026

### Kubernetes Resources
- No HTTPRoute support (Gateway API)
- CRD support requested but not on short-term roadmap (2026+)
- Ingress components exist but no metrics attached

### Non-K8s Workloads
- VMs, Linux hosts, databases not supported out-of-box
- OpenTelemetry-based integration coming "in coming months"
- Edge deployment not developed yet (years away)

### UI/UX Requests
- Cannot reorder left navigation menu items
- Proxy path support broken (UI rewrites paths incorrectly)
- One-click cluster observation from Rancher UI requested

---

## 6. Agent & Data Collection

### Common Questions
- Agent caching behavior during disconnects
- Concurrent connection limits
- Self-monitoring capability (supported via SUSE Observability stackpack)
- Service token reuse across clusters (OK until RBAC release)

### Resource Consumption
- ~5-20 KiB/s bandwidth per standard node (4 vCPU, 16 GiB)
- Memory requests ~1.4 GiB total (not per node)
- Logs agent shows gradual memory increase (potential leak, not problematic yet)

### Fleet Deployment
- Customers deploying to 99+ clusters via Fleet
- Questions about stackpack instance creation order
- Agents without stackpacks cause 500 errors in ingestion

---

## 7. Integration & Extensibility

### OpenTelemetry
- OTLP vs OTLP-HTTP configuration confusion
- TLS configuration for OTel endpoints
- Custom metrics via OTel collector supported

### Rancher UI Extension
- Service token configuration issues causing 401/502 errors
- URL format confusion (should be hostname only, no path)
- Custom CA certificates not automatically trusted by Rancher proxy

### External Systems
- Grafana datasource integration documented
- Power monitoring via Kepler (x86-64 only, Intel RAPL)
- GPU power via NVIDIA GPU Operator

---

## 8. Documentation Gaps

### Identified Issues
- "next" vs "latest" URL confusion in Google results
- Missing IOPS/storage requirements (SSD required)
- RBAC documentation outdated vs actual permissions
- Release notes missing significant changes (RBAC permissions)

### Customer Feedback
- "Installation steps very difficult to find via Google"
- "Docs say optional but it's actually required"
- "New permissions don't match documentation"

---

## 9. Support Patterns

### High-Touch Customers
- **Rabobank**: Multiple incidents, custom stackpack, weekend support
- **Kroger**: OIDC issues, feature requests
- **BASF**: Linux logs requirement, roadmap discussions
- **Solidigm**: Long-term roadmap questions

### Common Support Escalation Triggers
1. Upgrade failures with data corruption
2. Authentication configuration issues
3. Pod startup failures (resource/timing)
4. License key problems

### Positive Feedback
- "SUSE support really helped us well"
- Quick response to weekend incidents appreciated
- Detailed incident reports valued by customers

---

## 10. Recommendations

### Short-Term (Q1 2026)
1. **Document SSD storage requirement** explicitly
2. **Improve upgrade testing** for custom configurations
3. **Streamline license key distribution** via SCC
4. **Add skipSslValidation to questions.yaml** (done in recent release)

### Medium-Term (2026)
1. **Complete RBAC with Rancher integration** (in progress)
2. **Generalized logging support**
3. **One-click cluster observation** from Rancher UI
4. **HTTPRoute/Gateway API support**

### Long-Term
1. **CRD support** in topology
2. **Edge deployment** optimization
3. **Non-K8s workload** native support

---

## Appendix: Key Jira References

| Issue | Description |
|-------|-------------|
| STAC-22411 | External secrets issue |
| STAC-22443 | Static pod logs bug |
| STAC-22596 | Thread silently continuing issue |
| STAC-23121 | Broken custom view after upgrade |
| STAC-23153 | Health port conflict with NVIDIA dcgm |
| STAC-23181 | CLI bug with scope parameter |
| STAC-21415 | Menu ordering feature request |

---

*This document should be updated quarterly as new patterns emerge from customer feedback.*

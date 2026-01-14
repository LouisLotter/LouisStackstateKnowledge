# SUSE Observability Customer Feedback & Common Questions Analysis
## Source: discuss-observability-stackstate Slack Channel (Part 2: July - December 2025)

---

## Executive Summary

This analysis covers ~5 months of customer interactions, support questions, and internal discussions. Key themes emerge around **installation/upgrade challenges**, **RBAC/authentication complexity**, **resource requirements concerns**, and **feature gaps** (especially around logs and edge computing).

---

## 1. Most Common Technical Issues

### 1.1 Installation & Upgrade Problems
| Issue | Frequency | Severity |
|-------|-----------|----------|
| Tephra/HBase data corruption during upgrades | High | Critical |
| Pods not starting after cluster reboot | Medium | High |
| Air-gapped installation documentation gaps | Medium | Medium |
| Helm `--reuse-values` causing config corruption | Medium | Medium |

**Key Examples:**
- Rabobank experienced multiple upgrade issues (2.3.5 → 2.3.6 → 2.3.7) with custom integrations breaking
- Kafka checkpoint file corruption after VM shutdown (Ron Terry - SKO demo environment)
- OTEL collector config corruption when using `--reuse-values` in air-gapped setups

### 1.2 Authentication & RBAC Challenges
| Issue | Frequency | Notes |
|-------|-----------|-------|
| Rancher OIDC integration complexity | Very High | Multiple customers struggled |
| Azure AD / Keycloak prefix issues | High | Group name prefixes cause mismatches |
| Service token expiration in RBAC agent | Medium | 24hr expiry causing recurring failures |
| CORS configuration for UI extension | High | Required after 2.4.0 upgrade |

**Critical Finding:** The RBAC agent doesn't refresh service account tokens, causing failures after 24 hours. Workaround: restart deployment every 12 hours.

### 1.3 Storage & Performance Issues
| Issue | Frequency | Impact |
|-------|-----------|--------|
| Longhorn/NFS incompatibility with StackGraph | High | Data corruption risk |
| HBase region server issues | Medium | Service degradation |
| Slicing pod OOM on large deployments | Medium | Requires memory tuning |
| High HTTP latency false positives (long polling) | Medium | Rancher services affected |

**Recommendation from team:** Use SSD-equivalent storage, avoid Longhorn for production.

---

## 2. Most Requested Features

### 2.1 High Priority (Frequently Requested)
1. **Custom Dashboarding** - #1 customer request, releasing after December 2025 hack week
2. **OTLP Logs Support** - Pushed to Q4 2026 (major disappointment expressed)
3. **System-level logs collection** (journalctl, kubelet) - Q4 2026
4. **Control Plane Monitoring** (etcd, API server, scheduler metrics) - Not OOTB
5. **FinOps/Cost Management** - On backlog, not prioritized for 18+ months

### 2.2 Medium Priority
- PDF report generation
- CRD monitoring and visualization
- Subpath URL support (e.g., `domain.com/observability`)
- Edge computing / offline data collection
- Audit logging for compliance

### 2.3 Explicitly Not Supported (Yet)
- Running SUSE Observability outside Rancher-managed clusters (licensing issue)
- 2nd tier storage for long retention
- External Elasticsearch integration
- More than 30-day retention (officially)

---

## 3. Sizing & Resource Concerns

### Common Customer Feedback:
> "The cost for such a setup is just too high - had to setup a system with 3 master+12 worker just to get this running for monitoring an environment of 30 nodes" - Martin Weiss

### Key Sizing Issues:
| Concern | Customer Impact |
|---------|-----------------|
| 150-HA minimum for production HA | Too expensive for small deployments |
| Cannot upgrade non-HA to HA | Requires complete reinstall |
| No smaller HA profiles available | Requested for H2-2026 |
| Memory-heavy nodes skew sizing calculations | Confusion on profile selection |

### Sizing Calculation Example (from thread):
- 9 control nodes (16 cores, 128GB) + 15 workers (64 cores, 1024GB)
- CPU calculation: 1104/4 = 276 standard nodes
- RAM calculation: 16512/16 = 1032 standard nodes
- Result: Requires 4000-HA profile (largest available)

---

## 4. Integration & Compatibility Questions

### 4.1 Frequently Asked Integrations
| Integration | Status | Notes |
|-------------|--------|-------|
| Rancher UI Extension | Supported | Multiple CORS/auth issues reported |
| Azure AD via Rancher | Supported | Requires `client_name` query param |
| Keycloak via Rancher | Supported | Group prefix issues |
| Grafana datasource | Supported | Documented |
| Splunk/Dynatrace | Via Platform Optimization SKU | Legacy customers only |
| NewRelic | Not supported | No integration path |
| Alibaba Cloud ACK | Tested, revalidation pending | Mid-December 2025 |
| NVIDIA DCGM (GPU metrics) | Via OTEL collector | Manual setup required |
| Dapr tracing | Works via OTEL | Sandvik confirmed working |

### 4.2 Rancher Version Compatibility
- UI Extension has specific compatibility matrix
- Agent works with any supported K8s version
- RBAC integration requires Rancher 2.12+ for full functionality

---

## 5. Documentation Gaps Identified

1. **Air-gapped installation** - Commands incorrectly reference helm repo instead of .tgz files
2. **OIDC callback URL** - `?client_name=StsOidcClient` requirement not clear
3. **CORS configuration** - Required after 2.4.0, not prominently documented initially
4. **Sizing profiles** - No clear guidance on memory-heavy vs CPU-heavy clusters
5. **Service token vs API key** - Migration path unclear for RBAC
6. **Stackpack upgrade requirements** - Manual "Update" button click needed after platform upgrade

---

## 6. Positive Feedback & Success Stories

### What Customers Appreciate:
- "Suse support really helped us well" - Rabobank (after weekend incident)
- Dapr integration "got it working today" - Sandvik
- Self-monitoring stackpack useful for observability cluster health
- Playground environment (observability.suse.com) valuable for exploration

### Release Process Improvements:
> "Our release process is so much better now. Kudos @Daniel Barra and everyone else involved. The release notes looks great." - Louis Lotter

---

## 7. Licensing & Pricing Clarifications

### Key Points Confirmed:
1. **Management nodes are FREE** - Nodes running K8s management, Security, or Observability don't count toward license
2. **Worker nodes only** - Only nodes running containerized workloads are counted
3. **SUSE Observability included in Rancher Prime** - No separate license needed
4. **Cannot run outside Rancher** without separate Observability-only license

### Common Confusion:
- Customers think they need to pay for Observability cluster resources
- SCC registration codes sometimes generated incorrectly (bulk fix done August 2025)

---

## 8. Roadmap Items Mentioned

| Feature | Timeline | Notes |
|---------|----------|-------|
| Custom Dashboarding | KubeCon NA 2025 | MVP in ~2 months from Oct 2025 |
| Stackpacks 2.0 (OTEL-based) | "Coming months" | Easier integrations |
| Auto-upgrade OOTB Stackpacks | In progress | STAC-23236 |
| OTLP Logs | Q4 2026 | Pushed back significantly |
| System-level logs | Q4 2026 | journalctl, kubelet |
| AI-driven remediation | Q3 2026 | Part of Security Hub |
| Smaller HA profiles | H2 2026 | Resource optimization |
| Open-sourcing | EOY 2026 | Plans in progress |

---

## 9. Action Items for Engineering/Product

### Immediate (Bugs/Issues):
1. **Fix RBAC agent token refresh** - 24hr expiry causing recurring failures
2. **Document CORS requirements prominently** - Many customers hit this after 2.4.0
3. **Fix air-gapped documentation** - Helm commands reference wrong sources

### Short-term:
1. Add Rancher service annotations OOTB to disable HTTP latency monitors for long-polling services
2. Improve error messages for OIDC configuration issues
3. Create compatibility matrix for values chart versions

### Medium-term:
1. Evaluate smaller HA profiles for cost-sensitive customers
2. Consider non-HA to HA upgrade path
3. Improve control plane monitoring OOTB

---

## 10. Key Contacts & Escalation Patterns

### Most Active Support Contributors:
- **Bram Schuur** - Technical lead, StackGraph expert
- **Alejandro Acevedo Osorio** - Deep troubleshooting, HBase issues
- **Remco Beckers** - Agent, OTEL, general architecture
- **Frank van Lankvelt** - OIDC, RBAC, UI extension
- **Vladimir Iliakov** - SaaS, deployment configurations
- **Mark Bakker** - Product decisions, roadmap, licensing

### Escalation Path:
1. Slack channel for initial triage
2. Support package collection (documented tool)
3. Internal Jira (stackstate.atlassian.net) for bugs
4. SURE Jira for customer-facing issues

---

*Analysis completed: December 2025*
*Data range: July 2025 - December 2025*

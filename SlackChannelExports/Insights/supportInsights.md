# Customer Support Insights from #prod-ranchersupport-suseobservability

Analysis of support interactions from July 2024 through December 2024.

---

## 1. Installation & Configuration Challenges
- **Air-gapped deployments** - Multiple customers (Infosys, others) struggle with air-gapped installation, especially around image registry configuration and documentation clarity
- **Helm chart issues** - Recurring problems with `suse-observability-values` chart not generating expected output files
- **OpenTelemetry setup** - Customers need clearer guidance on configuring OTLP ingress, especially for HTTP vs gRPC protocols
- **External secrets integration** - Issues with ExternalSecrets not working properly with helm values

## 2. Documentation Gaps (Frequently Requested)
- Rancher Manager version compatibility for UI extension
- Port requirements for firewall configuration (agent ↔ cluster communication)
- SMTP/email notification setup
- OpenTelemetry ingress configuration for HTTP (not just gRPC)
- Air-gapped installation scripts (docker vs containerd confusion)
- OIDC authentication setup

## 3. Stability & Resource Issues
- **Tephra pod startup failures** - CPU throttling causing readiness probe failures (fixed in v2.1.0)
- **Kafka lock issues** - Especially with NFS storage (not recommended for production)
- **Component limits** - Trial setups hitting 1K component limits with large clusters
- **Pod crashloops** after cluster maintenance/patching

## 4. Scale & Production Readiness
- David Noland's Rancher Hosted use case: 20+ clusters on a "trial" setup that needs production-grade HA
- Customers with 2000+ namespaces hitting UI performance issues
- Need for proper sizing guidance and migration paths

## 5. Licensing & Onboarding
- License key expiration confusion (SCC showing different dates than actual)
- Unclear onboarding process for trial → production
- Questions about free tier vs paid subscriptions

## 6. Feature Requests from Customers
- Long-term log storage (currently limited retention)
- Component data in remediation guides
- External monitors visibility in UI
- Metric stream interface improvements

## 7. Support Tooling Needs
- **Logs/config collection script** - Repeatedly requested, ticket created (STAC-21890)
- Better troubleshooting documentation for common issues
- Clear escalation paths between Rancher support and StackState engineering

## 8. UI Extension Issues
- Certificate chain problems with self-signed/private CA setups
- "Cluster not observed" errors even when agent is healthy
- Version compatibility issues (v0.5 → v1.0 upgrade needed)

---

## Suggested Priorities

1. **Documentation improvements** - Air-gapped setup, OpenTelemetry configuration, certificate handling
2. **Support tooling** - Log collection script (STAC-21890)
3. **Stability fixes** - Resource-constrained environments, probe timing
4. **Clearer trial → production migration path**

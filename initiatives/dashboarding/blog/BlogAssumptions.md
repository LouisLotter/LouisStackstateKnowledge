# Dashboarding Blog - Key Assumptions for Review

**Purpose:** Before we research and write the dashboarding announcement blog, we need alignment on these core assumptions. Please provide feedback.

---

## Target Audience

| Assumption | Details |
|------------|---------|
| Primary audience | Platform Engineers, SREs, DevOps practitioners |
| Secondary audience | IT Operations / NOC teams, Developers ("build it, run it") |
| Technical level | Comfortable with PromQL, Kubernetes, observability concepts |
| Current tooling | Many already use Grafana + Prometheus stack |

**Question for reviewers:** Are we missing any key audience segments? Should we prioritize differently?

---

## Primary Competitors (for blog research)

| Vendor | Why included |
|--------|--------------|
| **Grafana Labs** | Direct comparison - users familiar with Grafana dashboards |
| **Datadog** | Market leader in observability, strong content marketing |
| **New Relic** | Enterprise observability, similar positioning |
| **Dynatrace** | AI-driven observability, enterprise focus |
| **Honeycomb** | Kubernetes-focused, modern observability perspective |
| **Groundcover** | Startup, eBPF-based, cloud-native approach |
| **Komodor** | Kubernetes troubleshooting focus |
| **Red Hat** | SUSE's direct enterprise competitor |

**Feedback received:** ✅ Added Kubernetes-focused startups (Honeycomb, Groundcover, Komodor) for modern perspective + Red Hat as SUSE's direct competitor

---

## Pain Points We're Addressing

| Pain Point | Priority | How Dashboarding Solves It |
|------------|----------|---------------------------|
| **Cross-component visibility gap** | **PRIMARY** | Before: metrics tied to individual components. Now: unified view across business processes, user flows, pipelines |
| **Troubleshooting friction** | **PRIMARY** | Before: context-switching between tools. Now: pin metrics during investigation, build dashboard on-the-fly |
| **Custom metrics visualization** | Secondary | Before: metric explorer (ad-hoc) or metric bindings (complex). Now: quick PromQL → dashboard |
| **Tool sprawl** | Secondary | Before: separate Grafana instance. Now: dashboarding integrated into observability platform |
| **Grafana migration barrier** | Secondary | Before: familiar workflows locked in Grafana. Now: similar concepts, easier transition |

**Feedback received:** ✅ Focus on cross-component visibility gap and troubleshooting friction as the top two pain points. They're closely related - the reason you want to use dashboards during troubleshooting is to gather cross-component metrics.

---

## Key Differentiators to Highlight

| Differentiator | Why it matters |
|----------------|----------------|
| **Topology integration** | Widgets link back to components - unique to SUSE Observability |
| **Troubleshooting workflow** | Pin → Dashboard flow during incident investigation |
| **Time travel** | View dashboard state at any historical point |
| **RBAC-aware** | Data visibility respects existing permissions |
| **StackPack bundling** | Dashboards can ship with integrations |

**Question for reviewers:** Are these the strongest differentiators? Should we lead with different ones?

---

## Messaging Positioning

**Current assumption:** Position dashboarding as a Grafana replacement for most use cases.

> "SUSE Observability dashboards eliminate the need for a separate Grafana instance for most monitoring needs. Only users with very specific or advanced visualization requirements would still need Grafana."

**Feedback received:** ✅ Updated positioning - we DO want people to replace Grafana for all not-so-advanced use cases to reduce tool sprawl. Only very specific needs require Grafana.

---

## Use Cases for the Blog

| Use Case | Source | Notes |
|----------|--------|-------|
| Single-app technical dashboard | Sock Shop | Response times, CPU usage/throttling with `topk(5,...)` queries to avoid chart clutter |
| Business metrics dashboard | Sock Shop (if metrics available) | Number of checkouts, with markdown widget linking to technical dashboard for troubleshooting |
| Incident investigation dashboard | Demo (troubleshooting workflow) | Pin → Dashboard flow during investigation |

**Feedback received:** ✅ Dropped cross-cluster example (setup no longer available). Better example: single-app technical metrics dashboard + business dashboard with markdown links between them.

---

## Known Limitations (Transparency)

**Current scope:**
- Only metrics supported (no other data types like logs, traces in dashboards)
- 5 widget types vs. Grafana's extensive library
- No team-specific sharing yet (only public/private)
- No direct Grafana dashboard import

**Feedback received:** ✅ Be honest about current scope without overpromising future features. Don't mention "we'll add more widgets" or "Grafana import coming" unless there's a committed timeline. Past experience (e.g., traces) shows features may not be touched for 1-2 years after initial release.

---

## Feedback Requested By

Please provide feedback on these assumptions so we can proceed with research and writing.

**Reviewers:** Bram Schuur, Remco Beckers, [others?]

**Deadline:** [TBD]

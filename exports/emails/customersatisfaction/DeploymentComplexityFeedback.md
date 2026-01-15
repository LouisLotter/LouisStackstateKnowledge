# Product Feedback: Deployment Complexity

**Date:** January 15, 2026 | **For:** Mark Bakker

---

## The Feedback

**Hirslanden Gruppe** (Case 01612759, Jan 13):
> "Deployment model (Helm charts) is insufficient to satisfactory resolve dependencies and operational complexities... requiring manual troubleshooting and guessing which one is not working correctly."

They requested a Kubernetes operator. This pattern appears across multiple customers in Slack — pods in CrashLoopBackOff, cascading failures, no visibility into what's broken.

---

## Why Not an Operator

We've looked at this before. CRD versioning, migration burden, and lifecycle management would add complexity rather than reduce it.

---

## What We've Done Recently

1. **Fixed OOM after K8s upgrades** — directly relevant to Hirslanden's issue
2. **Data corruption fixes** — system recovers cleanly when components restart unexpectedly
3. **Simplified backup/restore** — single-command restore capability
4. **Air-gap support** — removed external CDN dependencies

---

## What We're Working On

**Helm chart simplification** — eliminating the two-step install (`helm template` + `helm install`) by merging the values generator into the main chart. Enables standard GitOps and Rancher workflows.

---

## Recommendation

Consider "deployment health visibility" for 2026 planning — a CLI or post-install hook that tells customers what's broken. Lightweight, no operator required.

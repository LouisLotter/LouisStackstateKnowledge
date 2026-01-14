# 1:1 Prep with Sheng - Stackpacks 2.0 Overview
**Date:** January 14, 2026

---

## What is Stackpacks 2.0?

Stackpacks 2.0 is an initiative to simplify how external applications integrate with SUSE Observability. The core problem it solves:

**Current State:** Adding support for a new application (like Kubewarden, Harvester, or Security Hub) requires weeks of work, including complex topology synchronizations, Groovy scripting, and deep platform knowledge.

**Target State:** Application maintainers can add support for their application to SUSE Observability without spending weeks on it, using open standards (OpenTelemetry) and simple configuration.

---

## Why This Matters Strategically

1. **Enables SUSE Product Integration** - Security Hub, Harvester, SUSE AI, and other SUSE products can extend the platform without our team becoming a bottleneck
2. **Leverages OpenTelemetry** - Aligns with SUSE's open-source philosophy; we get hundreds of integrations "for free" via OTel ecosystem
3. **Reduces Maintenance Burden** - No more custom topology syncs per integration; one generic OTel-based approach
4. **Customer Self-Service** - Users can add support for their custom applications without deep platform expertise

---

## Key Technical Components

### 1. OTel Mapping API (STAC-23427) - COMPLETED ✅
The centerpiece of Stackpacks 2.0. Allows defining how OpenTelemetry attributes map to topology components.

**How it works:**
- Define component mappings in YAML (no Groovy required)
- Specify which OTel attributes create which component types
- Use templates for identifiers: `urn:opentelemetry:namespace/${vars.namespace}:service/${input.attributes['service.name']}`
- Conditions control when components are created
- Relations can be defined between components

**Example use case:** A Kubernetes pod span with attributes like `k8s.pod.name`, `k8s.namespace.name`, `k8s.cluster.name` can automatically create Pod components in topology without custom sync code.

### 2. Stackpack Simplification
- Stackpacks can now be installed as dependencies (e.g., Kubewarden depends on OpenTelemetry stackpack)
- Menu entries, overview pages, and highlight pages can be added via configuration
- Goal: CLI scaffolding command to create basic stackpack structure

### 3. Architecture Decision
The team evaluated multiple approaches for processing OTel data:
- **Chosen approach:** Generic Sync Service with filtering - OTel Collector sends relevant spans/attributes to Sync Service, which creates components based on mapping configuration
- This balances performance (filtering at collector) with flexibility (mapping logic in sync service)

---

## Recent Progress (Last 3 Weeks)

### Completed
- **STAC-24115: Implement API handlers** - CRUD API for OTel mappings (Lukasz) - Done 13 Jan
- **STAC-24116: Implement permissions for OTel Mappings** - RBAC integration (Lukasz) - Done 13 Jan
- **STAC-23427: Create OTel Mapping API** - Parent story marked Done 13 Jan

### In Progress
- Sprint "Stackpacks 2 - 1" active on Team Borg
- Integration testing and validation ongoing

---

## How This Connects to Other Initiatives

| Initiative | Dependency on Stackpacks 2.0 |
|------------|------------------------------|
| **Security Hub** | Critical - needs OTel mapping to create NeuVector topology |
| **GenAI Demo** | Uses OTel mapping for AI service topology |
| **Kubewarden** | Already using OTel service/instance components as workaround |
| **Opensource Goal** | Simpler integration model makes platform more accessible |

---

## Talking Points for Sheng

**Progress Update:**
- "OTel Mapping API is now complete - this is the foundation for Stackpacks 2.0"
- "Lukasz finished both the CRUD handlers and RBAC permissions last week"
- "This unblocks Security Hub integration work"

**Strategic Framing:**
- "This positions us well for the KubeCon Europe timeline - Security Hub can now build on this foundation"
- "The approach aligns with SUSE's open-source philosophy by leveraging OpenTelemetry"

**If Asked About Timeline:**
- OTel Mapping API: Done ✅
- Security Hub using this: Depends on scope discussion (separate topic)
- Full Stackpacks 2.0 vision (CLI tooling, documentation, etc.): Ongoing

---

## Questions to Raise

1. Should we prioritize documentation/examples for the OTel Mapping API to help Security Hub team get started?
2. Do we need to coordinate with Ravan on the GenAI use case to validate the API design?

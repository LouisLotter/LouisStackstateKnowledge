## Stackpacks 2.0 Overview

**What is it?**

Stackpacks 2.0 is a major architectural initiative at SUSE Observability to redesign how UI presentation is configured for components. The core goal is to make the platform extensible and compositional, enabling teams like SUSE AI, Harvester, and Security Hub to integrate their products without fighting against the current system's limitations.

**The Problem**

The current presentation system relies on multiple disconnected settings (MainMenu, HighlightPages, OverviewPages, QueryViews, ComponentTypes, etc.) that don't compose well together. Key pain points include:
- Stack packs from different sources conflict or don't work together (e.g., Kubernetes filters work but OTel filters don't)
- Extending a presentation requires extending the entire overview page and forcing components to change types
- Hard-coded behaviors scattered throughout the frontend
- One-to-one matching between components and presentations is too rigid
- Users can't easily customize or extend existing presentations

**The Solution: ComponentPresentation**

The proposal introduces a single unified setting called `ComponentPresentation` that consolidates all presentation logic. Key characteristics:
- Uses a binding system (component type or STQL query) to match components
- All presentation fields are optional and compositional
- Multiple presentations can apply to a single component with a rank/precedence system for merging
- Moves presentation logic from frontend to backend, enabling better backwards compatibility and abstraction
- Supports a `mode` field for different contexts (observability, security, cost)

**Implementation Approach**

The team plans an incremental rollout:
1. Feature-flagged development for Stackpacks 2.0
2. Design and implement each presentation subsection one by one
3. Maintain backwards compatibility with current settings
4. Create a backend API abstraction so the frontend no longer deals directly with settings DTOs

**Target Use Cases**

- SUSE product teams adding detailed observability for their products
- Customers adding observability for non-SUSE or non-Kubernetes applications
- Security Hub integration with mode switching and summary overviews
- CRD (Custom Resource Definition) presentation customization
- End-users customizing OTel data presentation with technology-specific attributes

**Open Questions**

Several design decisions remain unresolved: binding performance (ComponentTypes vs STQL), deprecation of QueryViews, handling of MetricBindings, support for multiple component types per component, and templating for properties in topology mappings.

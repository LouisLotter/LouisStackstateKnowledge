# SUSE Observability Enterprise Dashboarding: Complete Feature Overview

## Executive Summary

Enterprise Dashboarding is a major new capability in SUSE Observability that has been in development for approximately nine months. It represents the **#1 most requested feature by customers**, with sales engineers estimating that 5 out of 5 customers they speak with will adopt dashboarding upon release. The feature is scheduled to launch shortly after the December 2025 hack week.

---

## Why Dashboarding Was Added

### Customer Demand
- The most requested feature from customers
- Users familiar with Grafana/Prometheus workflows expect dashboarding capabilities
- Potential to migrate existing Grafana dashboards to SUSE Observability

### Cross-Component Visibility Gap
Before dashboarding, SUSE Observability could visualize metrics and information per component with excellent out-of-the-box defaults. However, these visualizations were **tied to individual components**. Users needed the ability to:
- Monitor business processes spanning multiple components
- Track user flows through applications (e.g., checkout and payment processes in e-commerce)
- Observe data processing pipelines end-to-end
- Create unified views across their entire infrastructure

### Accelerated Troubleshooting
Dashboards integrate directly into the troubleshooting workflow:
- Quickly gather metrics from multiple components during incident investigation
- Pin and collect relevant data in one place
- Share dashboards with colleagues for collaborative troubleshooting
- Correlate data across different parts of the system

### Simplified Custom Metrics Visualization
Previously, viewing custom metrics required either:
- Using the metric explorer (queries written ad-hoc, not easily saved)
- Creating metric bindings (more complex, less user-friendly)

Dashboards provide a **quick and easy way** to visualize custom metrics with immediate value—just input a PromQL query and see results instantly.

---

## Core Features

### Dashboard Management

#### Privacy & Sharing
- **Private dashboards** (default): Only visible to the creator
- **Public dashboards**: Visible to all users with access to SUSE Observability
- **Starred dashboards**: Appear prominently in the main menu for quick access
- Easy sharing via URL copy/paste for public dashboards

#### Dashboard Settings
- **Save time range**: Lock dashboard to a specific time range (useful for control room displays)
- **Save variables**: Persist variable selections in the dashboard
- **Save data refresh interval**: Control automatic data refresh behavior
- Viewers can customize these settings if not locked by the dashboard owner

#### Dashboard Organization
- Filter views: All dashboards, Starred dashboards (with planned additions for "My dashboards" and "Shared with me")
- Dashboard list shows ownership and public/private status
- Clone dashboards with "Save as..." functionality

---

## Widget Types

### 1. Time Series Chart
The most commonly used widget for visualizing metrics over time.

**Features:**
- Multiple PromQL queries per widget (each produces a line)
- Configurable legend (position, mode, table format with aggregations)
- Y-axis customization (unit, label, min/max values, decimals)
- Thresholds (horizontal lines marking important values)
- Visual settings (connect null values for continuous lines)
- Legend aggregations: max, min, average, first, last, sum

### 2. Bar Chart
Visualizes time series data as bars.

**Features:**
- Same legend, Y-axis, and threshold options as Time Series Chart
- Ideal for comparing discrete time periods

### 3. Stat Chart
Displays a single prominent value with optional sparkline.

**Features:**
- Large, easy-to-read number display
- Optional sparkline showing historical trend
- Configurable unit and decimal places
- Calculation method selection (last, average, max, min, sum, etc.)
- Color thresholds to highlight concerning values
- Multiple stats can be displayed in a single widget (multiple queries = multiple stats)

### 4. Gauge Chart
Displays a value against a maximum, like a speedometer.

**Features:**
- Visual gauge representation
- Configurable maximum value
- Threshold-based color changes (e.g., green → orange → red)
- Percentage-based or absolute threshold modes
- Ideal for saturation/usage metrics (CPU, memory, budget limits)

### 5. Markdown Widget
Adds contextual text information to dashboards.

**Features:**
- Full markdown support
- Links (internal to SUSE Observability and external)
- Icons and emojis
- Useful for documentation, instructions, or context

---

## Variables System

Variables enable **dynamic, reusable dashboards** that can be parameterized for different use cases.

### Variable Types

#### Text Variable
- Simple text input
- Can set initial value
- Can be made read-only

#### List Variable
Four source types for populating options:

1. **Metric Label Names**: Query available label names from metrics
2. **Metric Label Values**: Query values for a specific label (e.g., all cluster names)
3. **Metric PromQL**: Custom PromQL query to derive values
4. **Static List**: Manually defined label/value pairs

### List Variable Options
- **Sort**: Alphabetical, numerical, etc.
- **Allow multiple values**: Select more than one option
- **Include Everything**: Add an "all values" option with optional custom value

### Using Variables
- Syntax: `${variable_name}` in compatible fields
- Usable in: queries, widget names, descriptions, links, other variables
- Multi-value variables interpolate as regex groups: `(value_1|value_2)`
- Use PromQL regex matcher `=~` for multi-value variables

### Variable Display
- Variables appear at top of dashboard near time range selector
- First few variables visible; rest in "More" dropdown
- Click to open selector and change values
- Widgets react immediately to variable changes

---

## Troubleshooting Integration

One of the most powerful aspects of dashboarding is its **deep integration with SUSE Observability's troubleshooting workflow**.

### Pin & Add Workflow
1. While investigating a component, pin interesting metrics
2. Add pinned items to a new or existing dashboard
3. Continue investigating, adding more metrics as needed
4. Dashboard automatically includes links back to source components

### Automatic Links
- Widgets added from component views include automatic links back to the originating component
- First link displays prominently; additional links in dropdown
- Links can open in same tab or new tab
- Manual links can be added (internal or external URLs)

### Correlation & Investigation
- Drag markers on charts to identify correlations
- Compare metrics from different components side-by-side
- Time range synchronization across all widgets
- Share investigation dashboards with colleagues

---

## Technical Features

### PromQL Query Support
- Full PromQL query language support
- Auto-complete for label names and values
- Alias support with label interpolation (e.g., `${pod_name}`)
- Multiple queries per widget

### YAML Configuration
- Every widget and dashboard has a YAML representation
- Edit YAML directly for advanced configuration
- Copy/paste YAML between widgets or instances
- Export entire dashboard as YAML for backup or migration

### RBAC Integration
- Dashboard visibility respects existing role-based access control
- Users only see data they have permission to access
- A public dashboard may show different data to different users based on their permissions

### StackPack Integration
- Dashboards can be included in StackPacks
- Out-of-the-box dashboards for supported technologies
- Custom StackPacks can bundle dashboards for specific use cases

### CLI Support
- Dashboard CRUD operations available via `stackstate-cli`
- Enables automation and GitOps workflows

---

## User Experience Details

### Widget Organization
- **Drag and drop**: Move widgets by dragging the title area
- **Resize**: Drag bottom-right corner of widgets
- **Auto-arrange**: Other widgets automatically rearrange when moving/resizing
- **Standard placement**: New widgets appear at top-left by default

### Saving & State Management
- Blue "Save Dashboard" button indicates unsaved changes
- "Save as..." creates a copy of the dashboard
- Toast notifications for unsaved changes with links back to dirty dashboards
- Changes preserved even if save fails

### Time Range Behavior
- Dashboard uses globally selected time range by default
- Can lock specific time range in dashboard settings
- Time travel integration: view historical dashboard state
- URL includes time range for sharing specific views

---

## Design Philosophy

### Grafana-Inspired, Purpose-Built
The widget selection was based on analysis of the most-used widgets in open-source Grafana dashboards:
- Time Series (most common)
- Gauge
- Stat
- Bar Chart
- Markdown (for context)

However, SUSE Observability is **not trying to be a dashboarding tool**—it's an observability platform with dashboarding capabilities that integrate deeply with topology, health, and troubleshooting features.

### Feedback-Driven Development
The team actively solicits specific feedback:
- Which data do you want to visualize?
- What kind of visualization is needed?
- What's the goal/use case?
- Why can't existing widgets accomplish this?

---

## Planned Future Enhancements

Based on Jira tickets and meeting discussions:

### Near-term
- Quick filters for "My dashboards" and "Shared with me"
- Drag on time series/bar chart to select time range
- Consistent text case styling across UI
- Various bug fixes and polish items

### Medium-term
- Share dashboards with specific teams (not just public/private)
- Security Hub integration (security metrics already work; dedicated visualizations planned)
- Additional widget types based on customer feedback

### Long-term
- Easy Grafana dashboard import
- Prometheus alert-rule import
- Deeper integration with upcoming features

---

## Key Differentiators from Grafana

While inspired by Grafana, SUSE Observability dashboards offer unique advantages:

1. **Topology Integration**: Widgets link back to components in the topology view
2. **Troubleshooting Workflow**: Pin metrics during investigation and promote to dashboards
3. **Time Travel**: View dashboard state at any historical point
4. **RBAC-Aware**: Data visibility respects existing permissions
5. **StackPack Bundling**: Dashboards can be packaged with integrations
6. **Unified Platform**: No need for separate dashboarding tool

---

## Summary

Enterprise Dashboarding transforms SUSE Observability from a component-centric monitoring tool into a flexible platform for cross-system visibility. By combining familiar dashboarding concepts with deep platform integration, it enables:

- **Business process monitoring** across multiple components
- **Faster troubleshooting** through collaborative investigation
- **Easier onboarding** for users familiar with Grafana
- **Quick value realization** from custom metrics
- **Unified observability** without tool sprawl

The feature represents nine months of development effort, with significant contributions from the frontend team (Sam Jones and Anton Ovechkin) and product management (Remco Beckers), delivering a professional-grade dashboarding experience that customers have been requesting as their #1 priority.


---

# Addendum: Additional Context for Blog Writing

## Quotable Moments & Talking Points

### On Customer Demand
> "It is the number one requested feature by our customers... one of our sales engineers remarked that he thought five out of five customers he talks to would start using dashboarding once we release it."
— Remco Beckers, Sprint Review Demo

### On the Value Proposition
> "We don't do things just because customers ask for it. We also need to have something that we deliver with it, right? Some value that it brings."
— Remco Beckers

### On Design Philosophy
> "We're not a dashboarding tool... but we do see that there's probably some widget that people would really like to have."
— Remco Beckers

---

## Concrete Use Case Examples

### 1. E-Commerce Checkout Monitoring
- Monitor checkout and payment processes across multiple microservices
- Track payment success rates prominently (Stat widget showing "273 successful payments in the last hour")
- Correlate frontend latency with backend processing times

### 2. Topology Processing Pipeline (Internal SUSE Observability Use Case)
- Dashboard shown in demo monitors SUSE Observability's own topology sync health
- Stat widgets showing: incoming data rates, processing nodes, sync latency
- Gauge widget for "budget saturation" (hitting limits = missing data)
- Variables for cluster and namespace selection

### 3. Kubernetes Resource Monitoring
- Memory usage per pod across namespaces
- CPU saturation gauges with threshold warnings
- Variables to switch between clusters/namespaces without duplicating dashboards

### 4. Incident Investigation Dashboard
- Created on-the-fly during troubleshooting
- Example from demo: "Troubleshooting downtime during demo"
- Pinned metrics from catalog service showing memory spikes correlating with HTTP latency
- Automatic links back to source components for deeper investigation

---

## Demo Applications Referenced

1. **Telescope Shop** (OpenTelemetry Demo)
   - Based on the OpenTelemetry telescope demo application
   - Used to demonstrate payment tracking and business metrics

2. **Sock Shop**
   - Another demo setup used for Kubernetes monitoring examples
   - Shows container memory usage, pod metrics

---

## Technical Details for Developer-Focused Content

### Storage Backend
- Metrics: VictoriaMetrics
- Traces: ClickHouse
- Logs: Elasticsearch

### Data Standards
- Native OpenTelemetry (OTLP) support
- PromQL for all metric queries
- Standardized label conventions (e.g., `cluster_name` for cluster identification)

### Widget YAML Structure Example
```yaml
plugin:
  kind: GaugeChart
  spec:
    thresholds:
      defaultColor: "#33A02C"
      steps:
        - color: "#E31A1C"
          value: 0.9
        - color: "#FF7F00"
          value: 0.8
      mode: absolute
    max: 1
    format:
      unit: short
      decimalPlaces: 0
    calculation: last
  queries:
    - query: sum by (cluster_name, namespace, pod_name) (kubernetes_state_container_cpu_limit{...})
      alias: Limit - ${cluster_name} - ${namespace} - ${pod_name}
links:
  - url: /#/components/urn:kubernetes:...
    name: calico-node-t268w (pod)
    targetBlank: false
display:
  name: CPU Usage
  description: ""
```

### Air-Gapped Environment Consideration
- Known issue: Monaco editor loads JS from CDN (jsdelivr.net)
- Being addressed for air-gapped deployments where external network access is restricted

---

## Competitive Positioning Notes

### vs. Grafana
| Aspect | Grafana | SUSE Observability |
|--------|---------|-------------------|
| Primary Purpose | Dashboarding tool | Observability platform with dashboarding |
| Topology Awareness | No | Yes - automatic component links |
| Time Travel | No | Yes - view historical state |
| Troubleshooting Integration | Separate workflow | Integrated pin → dashboard flow |
| RBAC | Separate system | Inherited from platform |
| Widget Count | Hundreds | Focused set (5 core types) |

### Messaging Angle
SUSE Observability dashboards are **not trying to replace Grafana** for users who need extensive dashboarding customization. Instead, they provide:
- A familiar interface for Grafana users
- Deep integration with observability workflows
- Reduced tool sprawl for teams already using SUSE Observability

---

## Known Limitations (Transparency for Honest Content)

### Current Release
- No team-specific sharing (only public/private) — planned for future
- Limited to 5 widget types (vs. Grafana's extensive library)
- No direct Grafana dashboard import (yet)

### UI Polish Items in Progress
- Variable name truncation display issues
- Gauge widget text sizing at different zoom levels
- Markdown widget text wrapping in editor

---

## Audience-Specific Angles

### For Platform Engineers / SREs
- Emphasize: Cross-cluster visibility, variables for multi-tenant environments, RBAC integration
- Hook: "Finally, one dashboard for all your clusters"

### For Developers ("Build it, Run it")
- Emphasize: Quick custom metrics visualization, troubleshooting workflow, no complex setup
- Hook: "From code to dashboard in minutes"

### For IT Operations / NOC Teams
- Emphasize: Control room displays with locked time ranges, public dashboards, business KPI tracking
- Hook: "Your wall display, always up-to-date"

### For Existing Grafana Users
- Emphasize: Familiar concepts, PromQL support, potential migration path
- Hook: "Everything you know, plus topology context"

---

## Timeline & Team Recognition

- **Development Duration**: ~9 months
- **Sprint Review Date**: November 28, 2025
- **Planned Release**: Shortly after December 2025 hack week
- **Key Contributors**:
  - **Remco Beckers**: Product management, ticket writing, demo presentation
  - **Sam Jones**: Frontend development
  - **Anton Ovechkin**: Frontend development
  - **Ovidiu Boc: Visual Desginer
  - **Team Borg**: Overall development team

---

## Related SUSE Observability Concepts to Reference

When writing about dashboards, these existing features provide context:

1. **Automatic Resource Dashboards**: Pre-existing per-component dashboards that consolidate metrics, events, logs, traces — dashboarding extends this to cross-component views

2. **Time Travel**: Core platform capability that dashboards inherit — "rewind the movie" to see historical state

3. **Guided Remediation**: Monitors and remediation guides that dashboards can link to

4. **StackPacks**: Integration framework that can now include dashboards

5. **Metric Bindings**: The "harder" way to visualize custom metrics that dashboards simplify

---

## SEO / Keyword Suggestions

Primary: SUSE Observability dashboards, Kubernetes monitoring dashboard, observability dashboarding
Secondary: PromQL dashboard, Grafana alternative, cross-cluster monitoring, topology-aware dashboards
Long-tail: "how to create observability dashboards", "Kubernetes business metrics dashboard", "troubleshooting with dashboards"

---

## Content Format Ideas

1. **Tutorial**: "Building Your First SUSE Observability Dashboard in 5 Minutes"
2. **Use Case**: "Monitoring Your E-Commerce Checkout Flow End-to-End"
3. **Comparison**: "SUSE Observability Dashboards vs. Grafana: When to Use What"
4. **Deep Dive**: "Variables and Dynamic Dashboards: A Complete Guide"
5. **Workflow**: "From Incident to Insight: Using Dashboards for Faster Troubleshooting"
6. **Migration**: "Bringing Your Grafana Workflows to SUSE Observability"





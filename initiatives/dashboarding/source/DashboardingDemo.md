# Dashboards in SUSE Observability

**Sprint Review Demo - November 28, 2025**

---

## Introduction

Today we're showing our latest and greatest feature: Dashboards. It's been a long time coming. The whole team has contributed to it, but especially the two frontend developers have been working really hard at it over approximately nine months. We're super excited to show it off and show how it all fits together. We plan to launch it just after hack week.

This presentation covers:
- Why we built dashboards
- What's included
- How it works
- Demo walkthrough

---

## Why Dashboards?

### The #1 Requested Feature

Dashboards are the number one requested feature by our customers. One of our sales engineers remarked that he thought five out of five customers he talks to would start using dashboarding once we release it. The expectations are high.

But we don't do things just because customers ask for it. We also need to deliver value.

### Current Limitations

What we already can do in SUSE Observability is visualize metrics and other information per component, and we ship a lot of out-of-the-box defaults for that. However:
- Those defaults are hard to add custom settings and custom metrics to
- They are still tied to a single component
- Sometimes you want an overview across multiple components

### Use Cases for Cross-Component Views

- **Business processes**: Take three metrics from one component and two from another to show how your business is doing
- **User flows through application**: Monitor your checkout and payment process (usually multiple components) together in one dashboard
- **Data processing pipelines**: View the entire pipeline in one place

### Troubleshooting Integration

We've integrated dashboards into SUSE Observability so you can quickly create a dashboard while troubleshooting. You can add metrics from whatever you're troubleshooting at that moment to the dashboard, gather all information in one place, and then share the dashboard with colleagues to troubleshoot together on the same data.

### Easier Migration from Grafana + Prometheus

Many of our customers and open source users are using Grafana and Prometheus for monitoring and alerting. They are very familiar with dashboards because that's the main user interface for Grafana. They have asked multiple times if they can recreate their Grafana dashboards in SUSE Observability.

### Quick Way to Visualize Custom Metrics

If you add metrics to your own application and collect them with the OpenTelemetry collector, they get stored in SUSE Observability. Before dashboards, viewing those metrics meant either:
- Using the metric explorer (always writing queries at view time with no way to store them easily)
- Making metric bindings (more work and less user-friendly)

The dashboard UI provides a quick and easy way to click together a dashboard, put in a PromQL query, show the metrics, and immediately get value out of it.

---

## What's Included

### Dashboard Visibility
- **Private dashboards**: By default, when you make a dashboard it will be private
- **Public dashboards**: You can make dashboards public so everyone with access to your SUSE Observability instance can view them

### Supported Widgets

We support multiple widgets for visualizing metrics:
- **Time series chart** 📈 (already existed)
- **Bar chart** 📊
- **Gauge**
- **Stats**
- **Markdown** (for textual/contextual information)

We chose these widgets by looking at the most used widgets in open source Grafana dashboards. The big chunk are these four types, plus markdown for contextual information.

### Variables

Variables are essential on a dashboard so you don't have to copy and paste the same dashboard multiple times for different applications or namespaces (for example, in Kubernetes).

### StackPack Integration

Dashboards have been integrated into StackPacks. When you create a StackPack, you can include one or more dashboards to offer out of the box for the tool you are supporting.

### RBAC Permissions

Important: Even though a user may have access to a dashboard, it doesn't mean the user can see the data visualized on the dashboard. It still depends on the RBAC permissions the user has. One user might see more metrics in the same dashboard than another, or some users might not see any metrics because they are not allowed to see those metrics.

---

## Demo Walkthrough

### Dashboards Menu

In the main menu, there's now a "Dashboards" entry. Just like views, you can also star dashboards. You get a list and overview of all dashboards with filters on top.

- **Open lock icon**: Public dashboard
- **Closed lock icon**: Private dashboard
- Dashboard ownership determines edit/copy/delete permissions

### Widget Types Overview

#### Markdown Widget
- Gets rendered as markdown
- Can use links (both internal to SUSE Observability and external)
- Supports icons and avatars
- When editing, you get a big input field for markdown and a preview on the top right

#### Stats Widget
- Main goal: Show one big number
- Example: Payments over the last hour (e.g., "273 successful payments")
- Includes a **sparkline** (small chart underneath) showing historical data
- Sparkline can be disabled in settings
- Supports one or more PromQL queries
- Alias controls what appears in the legend/top of the stat
- Multiple queries or multiple time series from a single query each render as separate values

#### Bar Chart
- Standard bar chart visualization
- Query part is the same as other widgets
- Legend can be positioned (right or bottom)
- Can include a table legend
- Y-axis settings available
- Supports thresholds (appear as lines on the chart)

#### Time Series Chart
- Supports multiple queries
- More settings available including min/max for y-axis
- Can fix y-axis to a certain range or leave on auto
- Thresholds change line colors

#### Gauge Widget
- Shows usage compared to a limit (like a speedometer)
- Useful for budget saturation or percentage-based metrics
- Configure thresholds at percentage points (e.g., 80% and 90%)
- Colors indicate danger levels (orange = getting dangerous, red = critical)
- Thresholds can be set as absolute values or percentages of maximum

### Widget Settings

Common settings across metric widgets:
- **Units**: Short, percentage, bytes, etc.
- **Thresholds**: Determine colors based on values
- **Legend options**: List or table format
- **Table legend**: Can include aggregations (max, min, average, first, last, sum) and sort by these values

### Dashboard Layout

- New widgets are placed at the left bottom by default
- Drag and drop any widget to reorganize
- Resize widgets as needed
- Other widgets shuffle around to make space
- Changes are not auto-saved; use the "Save Dashboard" button
- "Save Dashboard As" creates a copy

### Variables

#### Creating Variables
1. Access via the dashboard dropdown menu → Variables
2. Variable types: Text and List
3. List variable data sources:
   - Static list (manually typed values)
   - Metric label names
   - Metric label values (query the metric store)

#### Using Variables
- Reference in queries using `${variable_name}` syntax
- Example: Replace hardcoded cluster name with `${cluster}`
- Selecting different variable values updates all widgets using that variable

### YAML Editing

- Every widget is defined in YAML (or JSON)
- All UI settings have YAML equivalents
- Edit YAML directly for quick changes
- Copy/paste YAML to quickly duplicate widgets with modifications
- Dashboard-level YAML available for copying entire dashboards between instances

### Troubleshooting with Dashboards

#### Workflow
1. Navigate to a component with issues
2. Pin metrics or use the triple-dot menu to "Add to Dashboard"
3. Create a new dashboard or add to existing
4. Continue investigating other components, adding relevant metrics
5. Organize widgets on the dashboard
6. Correlate data across metrics to identify issues

#### Automatic Links
- When adding a metric from a component, a link is automatically added back to that component
- Click the link to jump back to the component
- Links section shows all associated links
- First link shows fully; additional links appear in a dropdown
- Can add custom links (internal or external, same tab or new tab)

### Time Range

- Dashboard time range follows the globally selected time range by default
- Can save a specific time range into the dashboard
- Useful for control room displays that should always show "last hour"

### Sharing Dashboards

- Make a dashboard public
- Copy and paste the URL to share with colleagues
- Recipients can open the same dashboard with the same time range
- Public dashboards appear in the public dashboards list

---

## Product Improvements Triggered by Dashboards

- Manual refresh option on Dashboards (also added to Logs, Metrics, Traces, etc.)
- Improvement notifications
- Auto-complete suggestions for metric labels in chart legend

---

## Providing Feedback

We're happy to get feedback on what people are still missing or what they would want to work differently. When providing feedback, try to be as specific as possible:

### For Additional Widgets
- Which data do you want to visualize?
- What kind of visualization should it be?
- What's the goal? Why is this specific widget needed?
- Why can't you achieve this with an existing widget?

### For Extra Features on Widgets
- What's the goal?
- What should it do or look like?

We can't promise we'll implement everything, but the most requested features will be collected and revisited to improve dashboarding.

---

## Future Considerations

### Team-Based Sharing
One frequently requested feature is the ability to share monitors, metric bindings, and dashboards with a particular team. This is not possible with the first release but is planned for a future update.

### Security Hub Integration
When Security Hub launches, specific visualizations for security will be added to both overview/highlight pages and dashboards. Security metrics will already work with the current dashboarding since it's just metrics. The aim is to have the same widgets available across all overview pages and dashboards.

---

## Acknowledgments

Special thanks to:
- **Remco Beckers**: Product management, writing tickets, and overall coordination
- **Sam and Anton**: Frontend development work

The team worked on this for approximately nine months, and the result looks professional and polished.

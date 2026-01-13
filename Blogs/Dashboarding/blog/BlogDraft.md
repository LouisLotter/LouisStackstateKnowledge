# Stop Context Switching: Dashboards Connected to Your Kubernetes Architecture

*Introducing Dashboarding for SUSE Observability*

**Today, we're releasing Dashboarding for SUSE Observability.** It's our most requested feature, bringing custom dashboards directly into your troubleshooting workflow.

---

## The 2 AM Context Switch

It's 2 AM. Your phone buzzes with an alert: latency spike on the checkout service. You're already awake. Muscle memory kicks in.

Tab one: Grafana. You find the dashboard, but the spike is there, staring back at you. No context. Just a line going up.

Tab two: kubectl. You're hunting for the pod. Which namespace was it again?

Tab three: Your log aggregator. You paste in the pod name, adjust the time range. Wait, is this UTC or local time?

Tab four: Back to Grafana. You try to line up the timestamps manually. Was that memory spike at 2:03 or 2:04?

This is the "Alt-Tab tax" on troubleshooting. It's not just the context switching. It's that *you* become the integration layer. Each tool has its own time range, its own data format, its own view of the world. None of them talk to each other.

**The hardest part of debugging isn't finding the data. It's connecting it.**

---

## The Problem: Dashboards Are Dumb Glass

Here's an uncomfortable truth: most dashboards are just pixels. They show you *that* something happened, but not *why*.

**The cross-component visibility gap:** Your business processes span multiple services. A checkout flow touches the frontend, cart, payment gateway, inventory. But dashboards are static. You have to predict what you'll need to see together *before* the incident happens.

**The troubleshooting friction:** You see a memory spike on one chart. Is it related to the latency spike on another? The charts don't know. They show their data, but not how it connects to the rest of your system.

**The missing piece:** Whether you're running a separate dashboarding tool or doing without, there's a gap. Custom dashboards that understand your architecture and integrate with your troubleshooting workflow. That's what's been missing.

We wanted one tool to see what's happening. We got three or four that don't talk to each other.

---

## The Solution: Dashboards Connected to Your Architecture

What if your dashboard was connected to your system topology?

SUSE Observability's new Dashboarding isn't just another charting tool. It's topology-aware: every widget links directly to the components in your architecture. No datasource configuration, no plugin management, no separate login.

> **📸 VISUAL: Hero Screenshot**
> *Place `DashboardDemo1.png` here. Annotate with arrows pointing to topology links on widgets. Caption: "Each widget links directly to the component in your architecture. Click the chart, see the context."*

**Stop managing dashboards. Start using them.**

The difference is in the details. Every widget knows where its data comes from. That time series showing memory usage? Click on the link, and you're looking at the pod in your topology. Not a query builder, not a search box, but the actual component with its health state and related services.

**What you get:**
- Five core widget types: Time Series, Bar Chart, Stat, Gauge, and Markdown
- Full PromQL support with auto-complete for labels and values
- Variables for dynamic filtering across clusters, namespaces, and services
- Automatic links from widgets to their source components

Here's a concrete example: tracking the top 5 pods by CPU usage:

```promql
topk(5,sum by(pod_name)(rate(container_cpu_usage{namespace="${namespace}"}[5m])))
```

Drop that into a Time Series widget, add a `${namespace}` variable, and you've got a dashboard that works across every namespace, with each data point linking back to the actual pod.

---

## The Workflow: Build Context, Don't Just View It

Most dashboards are destinations, you go there to look at data. SUSE Observability dashboards are workflows. You build them as you investigate.

### The Pin-to-Dashboard Workflow

You're investigating a latency spike on the catalog service. While looking at the component, you notice memory usage correlating with the spike. One click to pin the metric. Another click to add it to a dashboard. You keep investigating, pinning more metrics as you go.

> **📸 VISUAL: GIF or Strip Image**
> *Create a GIF showing the "Pin to Dashboard" action from a component view. Alternatively, use `DashboardDemo3.png` with caption: "Pin it. Build it. Fix it."*

By the time you've found the root cause, you've built a "War Room" view that captures the entire investigation. The dashboard becomes a record of your investigation, not a static display you hope has the right charts.

### Time Travel: Context Preservation

Because this is SUSE Observability, your dashboard inherits Time Travel. You're not just setting a time range on a chart. You're freezing the state of the entire system.

- View your dashboard at any historical point
- Share the exact moment with colleagues: "Look at 2:47 AM when the spike happened"
- Everyone sees the same context, the same state, the same relationships

**The dashboard is a workflow, not a destination.**

---

## Why Not Just Use Grafana?

Grafana is excellent at visualization. If you need 50 widget types or highly specialized visualizations, it's still the right tool. But for most troubleshooting and cross-component visibility use cases? With this release, you no longer need a separate tool.

> **📊 VISUAL: Comparison Table**

| Aspect | Typical Approach (Grafana) | SUSE Observability |
|--------|---------------------------|-------------------|
| **Setup** | Configure datasources, manage plugins | Native, just works |
| **Context** | Charts are isolated | Widgets link to topology |
| **Troubleshooting** | Separate workflow | Integrated pin → dashboard |
| **Time Travel** | Manual time range selection | System-wide state preservation |
| **Maintenance** | Another tool to manage | Part of the platform |

**The real cost of "build it yourself":**

The typical DIY stack: Prometheus for metrics, Elasticsearch for logs, Jaeger for traces, and Grafana to tie it together. Each tool has its own data model, its own query language. Grafana can visualize all of them, but it can't correlate them.

SUSE Observability is different. Metrics, logs, traces, and topology live in one platform, correlated by default. When you build a dashboard, you're visualizing data that already understands how your components relate.

We focus on what matters most: cross-component visibility and faster troubleshooting. Five widget types, purpose-built for the job.

---

## Real-World Use Cases

### Use Case 1: The Technical Dashboard

You're responsible for the payment service. You need to know when it's struggling before customers complain.

**Your dashboard:**
- **Time Series:** Response times over the last hour
- **Stat:** Current request rate (big number, easy to spot)
- **Time Series with topk:** Top 5 pods by CPU usage
- **Gauge:** Memory saturation against limits

Every widget links back to its source component. See a spike? Click through to the pod, check its logs, trace a request. All without leaving the platform.

### Use Case 2: The Business Dashboard

Your VP wants to know if checkouts are healthy. They don't care about pods. They care about revenue.

**Your dashboard:**
- **Stat:** "1,247 successful checkouts in the last hour"
- **Time Series:** Checkout success rate over time
- **Markdown:** Links to technical dashboards for each service

> **📸 VISUAL: Business Dashboard**
> *Place `DashboardDemo5.png` here. Caption: "Business KPIs with one-click drill-down to technical details."*

When the success rate dips, your VP clicks the markdown link to the payment service dashboard. They see the technical view. They understand the impact. No Slack thread required.

---

## Get Started

**Dashboarding is available now in SUSE Observability.**

Ready to see topology-aware dashboards in action?

- **Explore the playground:** Check out our [public playground](https://observability.suse.com/#/welcome), no setup required
- **Run it on your cluster:** [Get started with SUSE Observability](https://www.suse.com/products/observability/)
- **Learn more:** The [dashboarding documentation](https://docs.stackstate.com/use/dashboards) covers everything from first widget to advanced variables
- **Already a customer?** Dashboarding is available now. Open SUSE Observability, click "Dashboards," and start building.

---

**Your metrics deserve more than scattered views. Give them a home connected to your architecture.**

---

## Visual Recommendations Appendix

*For the content/design team: recommended visual placements for this blog post.*

### Required Visuals

| Location | Type | Source | Notes |
|----------|------|--------|-------|
| After "Stop managing dashboards" | Hero Screenshot | `DashboardDemo1.png` | **Annotate** with arrows pointing to topology links. This is the most important visual and proves the differentiation. |
| After "Pin-to-Dashboard Workflow" | GIF or Strip | `DashboardDemo3.png` or new GIF | Show the pinning action in motion. If static, use 2-3 images showing the flow. |
| "Why Native Matters" section | Comparison Table | Inline markdown | Already included in draft. Style appropriately. |
| After "Business Dashboard" use case | Screenshot | `DashboardDemo5.png` | Shows markdown links and business-friendly layout. |

### Optional Enhancements

| Visual | Purpose | Source |
|--------|---------|--------|
| Architecture diagram | Show how dashboards connect to topology | New diagram (Mermaid or design tool) |
| Before/After comparison | "Old way" vs "SUSE way" | Side-by-side screenshots |
| Video embed | 60-second feature walkthrough | Demo recording |

### Image Annotation Guidelines

For the hero screenshot (`DashboardDemo1.png`):
1. Add numbered callouts (①②③) pointing to:
   - A widget's topology link icon
   - The variable selector
   - A time series with multiple components
2. Use SUSE brand colors for annotations
3. Keep annotations minimal. Let the UI speak.

### Available Images Reference

```
Blogs/Dashboarding/images/
├── DashboardDemo1.png  ← Hero (topology links)
├── DashboardDemo2.png  ← Widget configuration
├── DashboardDemo3.png  ← Pinning workflow
├── DashboardDemo4.png  ← Variables in action
├── DashboardDemo5.png  ← Business dashboard
├── DashboardDemo6.png  ← Time travel view
└── DashboardDemo7.png  ← Full dashboard overview
```

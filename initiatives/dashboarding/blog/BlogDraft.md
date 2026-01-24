# Stop Context Switching: Dashboards Connected to Your Kubernetes Architecture

It's 2 AM. Your phone buzzes with an alert: latency spike on the checkout service. You're already awake. Muscle memory kicks in.

Tab one: Grafana. You find the dashboard, but the spike is there, staring back at you. No context. Just a line going up.

Tab two: kubectl. You're hunting for the pod. Which namespace was it again?

Tab three: Your log aggregator. You paste in the pod name, adjust the time range. Wait, is this UTC or local time?

Tab four: Back to Grafana. You try to line up the timestamps manually. Was that memory spike at 2:03 or 2:04?

This is the "Alt-Tab tax" on troubleshooting. It's not just the context switching. It's that *you* become the integration layer. Each tool has its own time range, its own data format, its own view of the world. None of them talk to each other.

**The hardest part of debugging isn't finding the data. It's connecting it.**

---

## Dashboards Connected to Your Architecture

SUSE Observability Dashboarding isn't just another charting tool. It's topology-aware so every widget links directly to the components in your architecture. No datasource configuration, no plugin management, no separate login.

> **📸 VISUAL: Hero Screenshot**
> *Place `DashboardDemo1.png` here. Annotate with arrows pointing to topology links on widgets. Caption: "Each widget links directly to the component in your architecture. Click the chart, see the context."*

**Stop managing dashboards. Start using them.**

The difference is in the details. Every widget links back to its data source. That time series showing memory usage? Click on the link, and you're looking at the pod in your topology. Not a query builder, not a search box, but the actual component with its health state and related services.

---

## The Workflow: Build Context, Don't Just View It

Most dashboards are destinations. You go there to look at data. SUSE Observability dashboards are workflows. You build them as you investigate.

### The Pin-to-Dashboard Workflow

You're investigating a latency spike on the catalog service. While looking at the component, you notice memory usage correlating with the spike: a jump from 1.2GB to 1.8GB right when HTTP latency hit 340ms. Shift-click to drop a time marker at that moment. The marker appears across every widget, so you can instantly see what else was happening at 02:43. One click to pin the metric. Another click to add it to a dashboard. You keep investigating, pinning more metrics as you go.

> **📸 VISUAL: GIF or Strip Image**
> *Create a GIF showing the "Pin to Dashboard" action from a component view. Alternatively, use `DashboardDemo3.png` with caption: "Pin it. Build it. Fix it."*

By the time you've found the root cause, you've built a War Room. Not a room full of panicked engineers, but a shared view that captures the entire investigation. Tomorrow's post-mortem practically writes itself. The dashboard becomes a record of what you found, not a static display you hoped had the right charts.

### Time Travel is More Than a Time Range Selector

This is where SUSE Observability dashboards fundamentally differ from Grafana.

When your VP asks "What happened at 2:47 AM?", you don't scrub timelines hoping to line things up. You freeze the entire system (topology, health states, metrics) at that exact moment. Time Travel isn't just a time range picker. It's state preservation.

- View your dashboard at any historical point, with the topology state from that moment
- Share the exact instant with colleagues: "Look at 2:47 AM when the spike happened"
- Everyone sees the same context, the same health states, the same component relationships

No Slack thread asking "Are you looking at UTC or local time?" No manual correlation. The system preserves what your infrastructure looked like at any point in history.

---

## One Platform, No Assembly Required

Grafana is excellent at visualization. If you need 50 widget types or highly specialized visualizations, it's still the right tool for that job.

But for troubleshooting and cross-component visibility? You no longer need a separate tool.

> **📊 VISUAL: Comparison Table**

| Aspect | Typical Approach (Grafana) | SUSE Observability |
|--------|---------------------------|-------------------|
| **Setup** | Configure datasources, manage plugins | Built-in, just works |
| **Context** | Charts are isolated | Widgets link to topology |
| **Troubleshooting** | Separate workflow | Integrated pin → dashboard |
| **Time Travel** | Manual time range selection | System-wide state preservation |
| **Maintenance** | Another tool to manage | Part of the platform |

**The real cost of "build it yourself":**

The typical DIY stack: Prometheus for metrics, Elasticsearch for logs, Jaeger for traces, and Grafana to tie it together. Each tool has its own data model, its own query language. Grafana can visualize all of them, but it can't correlate them.

SUSE Observability is different. Metrics, logs, traces, and topology live in one platform, correlated by default. When you build a dashboard, you're visualizing data that's already connected to your component relationships.

Five widget types (Time Series, Bar Chart, Stat, Gauge, and Markdown), purpose-built for the job. Full PromQL support with auto-complete. Variables for dynamic filtering. Every widget automatically linked to its source component.

---

## Real-World Use Cases

### Use Case 1: The Technical Dashboard

You're the engineer responsible for the payment service. The one that processes every transaction and touches half the microservices in your stack. When payment latency creeps up, customers abandon carts. When it goes down, revenue stops.

You need a single view that answers: "Is payment healthy right now?" Without opening five tabs.

In SUSE Observability, you create a new dashboard and start adding widgets manually. Request rate and response times are straightforward—add a Stat widget, add a Time Series widget, write your PromQL queries. But for CPU usage, you don't want a chart with 47 lines for every pod in the namespace. You want the top offenders.

So you add a Time Series widget and write a query using `topk()`:

```promql
topk(5, sum by(pod_name)(rate(container_cpu_usage{namespace="${namespace}"}[5m])))
```

This gives you the top 5 pods by CPU usage—the ones actually worth watching. The chart stays readable, and when one of those pods starts climbing, you'll see it immediately.

Your finished dashboard:
- **Stat:** 847 requests/second, current throughput at a glance
- **Time Series:** Response times over the last hour, with threshold lines at 200ms and 500ms
- **Time Series:** Top 5 pods by CPU usage (the query above)
- **Gauge:** Memory at 73% of limit (orange means watch it, red means act)

You use a `${namespace}` variable, so the same dashboard works across dev, staging, and production. Each widget links back to the actual pod in your topology—so when you see a spike, one click takes you to the component, its logs, and its traces. No context switching required.

### Use Case 2: The Business Dashboard

Your VP keeps asking: "Are checkouts healthy?" They don't care about pods or namespaces. They care about revenue.

So you build them a dashboard, not in a separate BI tool, but right in SUSE Observability where the data already lives. You pull checkout metrics from the order service, payment success rates from the payment gateway, and latency from the inventory check. Because SUSE Observability already understands how these services connect, you're not wiring up datasources or writing complex joins. You're just selecting the metrics that matter to the business.

The result:
- **Stat:** "1,247 successful checkouts in the last hour" (the number they actually care about)
- **Time Series:** Checkout success rate over time (currently 99.2%)
- **Gauge:** Payment gateway latency at 89ms, well under the 200ms threshold
- **Markdown:** Links to technical dashboards for cart, payment, and inventory services

> **📸 VISUAL: Business Dashboard**
> *Place `DashboardDemo5.png` here. Caption: "Business KPIs with one-click drill-down to technical details."*

Now when the success rate dips, your VP doesn't ping you on Slack. They click the markdown link to the payment service dashboard, see the technical view, and understand the impact. Same platform, different lens.

### Use Case 3: The Incident War Room

It's 2:43 AM. Alerts fire on the catalog service. You open SUSE Observability, navigate to the component, and see memory climbing fast.

Here's where the workflow changes everything: instead of copying metrics to a notepad or screenshotting Grafana, you click "Pin to Dashboard" and select "New Dashboard." You name it "Catalog Incident 2026-01-15" and keep investigating.

You check HTTP latency on the same pod—there's a 340ms spike correlating with the memory climb. Pin it. You pull up the error rate. Pin it. Each pin takes one click. Within three minutes, you've built a War Room view:

- **Time Series:** Memory spike on catalog-service-7d4f8b, jumped from 1.2GB to 1.8GB at 02:43
- **Time Series:** HTTP latency on the same pod, 340ms spike correlating with memory
- **Stat:** Error rate hit 2.3% during the incident window
- **Markdown:** "Root cause: OOM pressure from uncached product queries. Fix deployed 02:58."

Shift-click on the memory spike to drop a time marker—it appears across every widget, so you can visually confirm the correlation. Share the dashboard URL with your colleague. They see exactly what you see, at exactly the same moment in time.

The dashboard isn't just a view. It's your incident record: shareable, time-travel-enabled, and permanently linked to the components involved. Tomorrow's post-mortem writes itself.

---

## Get Started

**Dashboarding is available now in SUSE Observability.**

→ **[Explore dashboards on the playground](https://www.suse.com/products/rancher/observability/)** to see topology-aware dashboards in action, no setup required

→ **[Read the documentation](https://docs.stackstate.com/use/dashboards)** to build your first dashboard in 5 minutes

Already a customer? Open SUSE Observability, click "Dashboards," and start building.

---

**Your engineers deserve more than scattered views. Give them dashboards connected to your architecture.**

---

## Visual Recommendations Appendix

*For the content/design team: recommended visual placements for this blog post.*

### Required Visuals

| Location | Type | Source | Notes |
|----------|------|--------|-------|
| After "Stop managing dashboards" | Hero Screenshot | `DashboardDemo1.png` | **Annotate** with arrows pointing to topology links. This is the most important visual and proves the differentiation. |
| After "Pin-to-Dashboard Workflow" | GIF or Strip | `DashboardDemo3.png` or new GIF | Show the pinning action in motion. If static, use 2-3 images showing the flow. |
| "One Platform, No Assembly Required" section | Comparison Table | Inline markdown | Already included in draft. Style appropriately. |
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

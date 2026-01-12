# Gemini Deep Research Prompt: Observability Dashboarding Blog Competitor Analysis

## Research Objective

I'm writing a blog post announcing a new Enterprise Dashboarding feature for SUSE Observability (a Kubernetes observability platform). Before writing, I need comprehensive research on how leading observability vendors structure and write their feature announcement blogs.

**Goal:** Analyze 15-20 blog posts from observability vendors to identify patterns, best practices, and a recommended content framework for my blog.

---

## Vendors to Research

### Tier 1: Enterprise Observability Vendors (2-3 blogs each)

**1. Grafana Labs** (https://grafana.com/blog/)
- Most relevant comparison since users are familiar with Grafana dashboards
- Search for: dashboard features, visualization announcements, panel updates, Grafana version releases
- Prioritize posts from last 18 months about new features

**2. Datadog** (https://www.datadoghq.com/blog/)
- Market leader with excellent content marketing
- Search for: dashboard announcements, new features, visualization capabilities
- Note their visual storytelling and structure

**3. New Relic** (https://newrelic.com/blog)
- Enterprise observability positioning
- Search for: dashboard features, observability announcements, platform updates
- Note enterprise messaging patterns

**4. Dynatrace** (https://www.dynatrace.com/news/blog/)
- AI-driven observability, enterprise focus
- Search for: dashboard capabilities, platform announcements, visualization features
- Note AI/automation messaging

### Tier 2: Kubernetes-Focused / Startups (1-2 blogs each)

**5. Honeycomb** (https://www.honeycomb.io/blog)
- Modern observability, opinionated voice
- Search for: observability features, debugging, visualization
- Note developer-centric tone and contrarian positioning

**6. Groundcover** (https://www.groundcover.com/blog)
- eBPF-based, cloud-native, Kubernetes-focused
- Search for: Kubernetes monitoring, dashboards, observability features
- Note startup energy and technical differentiation

**7. Komodor** (https://komodor.com/blog/)
- Kubernetes troubleshooting focus
- Search for: troubleshooting workflows, Kubernetes monitoring, dashboards
- Note workflow-oriented content

### Tier 3: Direct Competitor (2-3 blogs)

**8. Red Hat** (https://www.redhat.com/en/blog - filter for OpenShift/observability)
- SUSE's direct enterprise competitor
- Search for: OpenShift observability, monitoring, dashboards
- Note enterprise positioning and open-source messaging
- Identify how they position against competitors

---

## What to Analyze for Each Blog Post

For each blog post you find, document:

### Basic Information
- Full URL
- Exact headline/title
- Publication date
- Estimated word count
- Blog type (feature announcement, tutorial, thought leadership, roundup)

### Structure Analysis
1. **Opening hook technique** - How do they capture attention in the first 100 words?
2. **Problem framing** - Do they establish pain points before presenting the solution?
3. **Feature presentation** - Benefits-first or features-first approach?
4. **Social proof** - Customer quotes, statistics, adoption metrics?
5. **CTA type** - Free trial, documentation, demo request, contact sales?

### Content Characteristics
- Technical depth (light/medium/deep)
- Code examples included? (queries, YAML, etc.)
- Visual types used (screenshots, GIFs, diagrams, videos, comparison tables)

### Headline Analysis
- What formula does the headline follow?
- Is it benefit-focused, action-oriented, or news-style?

### Tone & Voice
- Professional/authoritative vs. conversational/opinionated
- Enterprise-focused vs. developer/practitioner-focused

### Strengths & Weaknesses
- What makes this post effective?
- What could be improved?

### Applicable Learnings
- What specific techniques should I adopt for my blog?

---

## Specific Questions to Answer

### Pattern Analysis
1. What percentage of posts use problem-before-solution structure?
2. What are the most common headline formulas?
3. What's the typical word count range?
4. How many screenshots/visuals do top posts include?
5. Do they include code/query examples?
6. Where do they place CTAs (end only, or throughout)?

### Enterprise vs. Startup Differences
1. How does tone differ between enterprise vendors (Datadog, Dynatrace) and startups (Honeycomb, Groundcover)?
2. What technical depth do different audiences expect?
3. How do CTAs differ (demo request vs. free trial)?

### Red Hat Specific
1. How does Red Hat position their observability features?
2. What open-source messaging do they use?
3. Do they reference competitors directly or indirectly?
4. What are their dashboarding capabilities vs. SUSE's differentiators?

### Differentiation Opportunities
Based on your research, identify gaps or opportunities where SUSE Observability could differentiate:
- Native dashboarding (vs. Grafana dependency)
- Topology integration (dashboards linked to component views)
- Time-travel capability (view dashboard at historical point)
- Unified troubleshooting workflow (pin metrics → build dashboard during incident)

---

## Deliverable Format

Please structure your research report as follows:

### Section 1: Enterprise Vendor Analysis
For each vendor (Grafana, Datadog, New Relic, Dynatrace):
- 2-3 blog post analyses with full details
- Summary of vendor's content patterns
- Key takeaways for my blog

### Section 2: Kubernetes-Focused / Startup Analysis
For each vendor (Honeycomb, Groundcover, Komodor):
- 1-2 blog post analyses
- Tone and voice differences vs. enterprise vendors
- Unique patterns worth adopting

### Section 3: Red Hat Competitor Analysis
- 2-3 blog post analyses
- Enterprise positioning patterns
- Open-source messaging analysis
- Differentiation opportunities for SUSE

### Section 4: Synthesis and Recommendations

**4.1 Complete Blog Post Analysis Table**
| # | Vendor | Blog Title | URL | Type | Word Count | Key Takeaways |

**4.2 Pattern Frequency Analysis**
- Structural patterns (with percentages)
- Visual usage patterns
- Headline formula frequency
- CTA patterns

**4.3 Recommended Content Framework**
Based on strongest patterns, provide:
- Recommended headline formulas
- Recommended structure (section by section)
- Word count target
- Visual recommendations
- Technical depth guidance
- Tone recommendations

**4.4 Checklist for Blog Draft**
A verification checklist I can use when writing my blog.

---

## Context About My Blog

**Product:** SUSE Observability Enterprise Dashboarding
- Native dashboarding built into the observability platform
- 5 widget types: Time Series, Bar Chart, Stat, Gauge, Markdown
- Variables system for dynamic dashboards
- Integration with troubleshooting workflow (pin metrics → add to dashboard)
- Topology integration (widgets link back to components)
- Time-travel capability

**Target Audience:**
- Platform Engineers, SREs, DevOps practitioners
- Comfortable with PromQL, Kubernetes, observability concepts
- Many currently use Grafana + Prometheus

**Primary Pain Points to Address:**
1. Cross-component visibility gap (metrics tied to individual components, need unified view)
2. Troubleshooting friction (context-switching between tools during incidents)

**Key Differentiators:**
- Topology integration (unique to SUSE)
- Troubleshooting workflow integration
- Time-travel capability
- No separate Grafana instance needed

**Positioning:**
- Replace Grafana for most use cases
- Only very advanced visualization needs require Grafana
- Reduce tool sprawl

---

## Search Tips

When searching vendor blogs, try these queries:
- "[vendor] blog dashboard"
- "[vendor] blog new feature announcement"
- "[vendor] blog visualization"
- "[vendor] blog introducing"
- "[vendor] blog Kubernetes monitoring"

Focus on posts from **January 2024 - January 2026** for relevance.

---

## Final Notes

- Prioritize feature announcement posts similar to what I'm writing
- Include at least one "high-engagement" post per vendor if identifiable
- Note publication dates to ensure relevance
- Be specific with URLs so I can reference the original posts
- Focus on actionable patterns I can apply, not just descriptions

Thank you for conducting this research thoroughly. The output will directly inform the structure and content of my blog post.

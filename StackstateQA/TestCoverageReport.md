# SUSE Observability - Test Coverage & Quality Report

**Last Updated:** December 2025  
**Status:** Living Document - Work in Progress  
**Owner:** QA Team (Daniel, Raju, Yash)

---

## Executive Summary

This document provides visibility into our testing infrastructure, coverage metrics, and execution times across the SUSE Observability product suite. It serves as a single source of truth for stakeholders needing to understand our quality assurance posture.

**Current Challenge:** We are in the early stages of integrating test results with QASE. Test results from many pipelines are currently surfaced only as grouped pass/fail in GitLab, limiting detailed visibility.

---

## 1. Test Infrastructure Overview

### 1.1 Projects Under Test

| Project | Pipeline Active | Unit Tests | Integration Tests | E2E Tests |
|---------|----------------|------------|-------------------|-----------|
| SUSE Observability Agent | ✅ | ✅ | ✅ | ✅ (Beest) |
| SUSE Observability Backend Platform | ✅ | ✅ | ? | ? |
| SUSE Observability UI | ✅ | ✅ | - | ✅ (Playwright) |
| SUSE Observability Rancher Extension | ✅ | ✅ | - | ✅ |
| SUSE Observability CLI | ✅ | ✅ | - | Planned |
| StackGraph | ✅ | ✅ | ? | Planned |
| Helm Chart | ✅ | Linting | - | - |


### 1.2 Deployment & Test Triggers

| Trigger | Environment | What Runs |
|---------|-------------|-----------|
| Merge to `master` | Development (master.dev.stackstate.io) | Linting, Unit Tests, Deployment |
| Nightly Schedule | Preprod (nightly-champagne.preprod.stackstate.io) | Full validation + Integration tests |
| Weekly Schedule | Preprod | Rancher Extension + ARM Agent tests |
| Pre-Release | Preprod | Manual testing (~8 hours) |

---

## 2. Code Coverage Metrics

### 2.1 Line Coverage by Project

| Project | Coverage | Target | Gap | Notes |
|---------|----------|--------|-----|-------|
| SUSE Observability CLI | 90.2% | 85% | ✅ +5.2% | Exceeds target |
| SUSE Observability Agent | 79.8% | 80% | ⚠️ -0.2% | Near target |
| SUSE Observability UI | 74.56% | 80% | 🔴 -5.4% | Needs attention |
| Rancher Extension | 24.5% | 60% | 🔴 -35.5% | Significant gap |
| Backend Platform | ? | 80% | ❓ | Needs measurement |
| StackGraph | ? | 80% | ❓ | Needs measurement |

**Action Items:**
- [ ] Establish coverage measurement for Backend Platform
- [ ] Establish coverage measurement for StackGraph
- [ ] Define realistic targets per project based on codebase characteristics


### 2.2 Functional Coverage

**Currently Tested Functionality:**
- Monitors
- Metrics
- Components View & List
- Events
- Topology
- Rancher Integration
- RBAC
- Agent (x86 & ARM)
- CLI

**Known Gaps / Planned Expansion:**
- [ ] Dashboard validation (Playwright)
- [ ] Metrics query validation
- [ ] Topology scenarios
- [ ] Agent telemetry manipulation tests
- [ ] Downstream cluster (Rancher)
- [ ] StackGraph scenarios (viability TBD)

---

## 3. Test Execution Times

### 3.1 Current Execution Times

| Test Suite | Duration | Frequency | Notes |
|------------|----------|-----------|-------|
| Beest (x86) | ~50 min | Daily | Core E2E scenarios |
| Rancher Integration | ~40 min | Weekly | Install + integration |
| Manual Release Testing | ~8 hours | Per release | Exploration + validation |
| Unit Tests (per MR) | ? | Per commit | Needs measurement |
| Playwright UI Tests | ? | ? | Needs measurement |

**Note:** QASE does not capture infrastructure setup time, so reported durations may underrepresent actual wall-clock time.


### 3.2 Pipeline Execution Summary

| Pipeline | Avg Duration | Success Rate | Last 30 Days |
|----------|--------------|--------------|--------------|
| Agent | ? | ? | ? |
| Backend Platform | ? | ? | ? |
| UI | ? | ? | ? |
| Rancher Extension | ? | ? | ? |
| CLI | ? | ? | ? |

**Action Items:**
- [ ] Extract pipeline metrics from GitLab for each project
- [ ] Establish baseline success rates
- [ ] Identify flaky tests contributing to failures

---

## 4. Test Management & Reporting (QASE Integration)

### 4.1 Current QASE Integration Status

| Test Suite | QASE Status | Notes |
|------------|-------------|-------|
| Beest K8s Scenario | ✅ Fully Integrated | |
| Beest Rancher Scenario | ✅ Fully Integrated | |
| UI Inspection | 🔄 In Progress | Small adjustments needed |
| CLI | ❌ Not Integrated | Planned |
| Unit Tests | ❌ Not Integrated | Evaluate feasibility |

### 4.2 Reporting Gaps

**Current State:**
- Most pipeline results surface only as grouped pass/fail in GitLab
- Limited visibility into individual test results without QASE integration
- No centralized dashboard for cross-project test health


**Desired State:**
- All test suites reporting to QASE
- Centralized visibility across all projects
- Trend analysis for coverage and execution times
- Flaky test identification and tracking

---

## 5. Test Types Breakdown

### 5.1 Test Pyramid

```
                    ┌─────────┐
                    │  E2E    │  Beest, Playwright, Rancher
                    │ (slow)  │  
                ┌───┴─────────┴───┐
                │  Integration    │  API tests, Component integration
                │   (medium)      │  
            ┌───┴─────────────────┴───┐
            │      Unit Tests         │  Per-project, fast feedback
            │        (fast)           │  
            └─────────────────────────┘
```

### 5.2 Test Type Inventory

| Type | Framework/Tool | Projects | Count | Integrated w/ QASE |
|------|---------------|----------|-------|-------------------|
| Unit | Jest, ScalaTest, Go test | All | ? | No |
| Integration | ? | Backend, Agent | ? | No |
| E2E - API | Beest | Agent, Backend | ? | Yes |
| E2E - UI | Playwright | UI | ? | In Progress |
| E2E - Rancher | Beest | Extension | ? | Yes |
| Manual | Exploratory | All | N/A | Partial |

---

## 6. Risks & Concerns

| Risk | Impact | Mitigation |
|------|--------|------------|
| Limited visibility into test results | Can't answer stakeholder questions | Accelerate QASE integration |
| Unknown coverage for Backend/StackGraph | Blind spots in critical components | Establish measurement |
| Manual testing bottleneck (8hrs/release) | Release velocity | Increase automation |
| Flaky tests not tracked | False confidence / alert fatigue | Implement flaky test tracking |
| QASE timing inaccuracy | Misleading metrics | Document actual vs reported times |


---

## 7. Roadmap & Action Items

### Short Term (Next 2 Sprints)
- [ ] Complete UI Inspection QASE integration
- [ ] Measure and document Backend Platform coverage
- [ ] Measure and document StackGraph coverage
- [ ] Extract GitLab pipeline metrics (duration, success rate)

### Medium Term (Next Quarter)
- [ ] Integrate CLI tests with QASE
- [ ] Expand Playwright scenarios (dashboards, metrics queries)
- [ ] Implement flaky test tracking
- [ ] Create cross-project test health dashboard

### Long Term
- [ ] Reduce manual release testing time through automation
- [ ] Achieve 80%+ coverage on all core projects
- [ ] Full QASE integration across all test types

---

## 8. How to Use This Document

**For Engineering Managers:**
- Section 2 (Coverage) and Section 6 (Risks) provide executive-level visibility
- Use Section 7 (Roadmap) to track QA improvement initiatives

**For QA Team:**
- Update metrics weekly/monthly as data becomes available
- Use Action Items as a backlog for improvement work
- Add new test suites to Section 5 as they're created

**For Developers:**
- Section 1 shows what tests run and when
- Section 3 helps understand pipeline timing expectations

---

## Appendix A: Data Collection Checklist

To fill in the gaps in this report, we need:

- [ ] GitLab API queries for pipeline duration/success rates
- [ ] Coverage reports from CI for Backend Platform
- [ ] Coverage reports from CI for StackGraph
- [ ] Test count per project/type
- [ ] QASE export of test run history

---

## Appendix B: Glossary

| Term | Definition |
|------|------------|
| Beest | E2E test framework for SUSE Observability |
| QASE | Test management platform for tracking test cases and results |
| Preprod | Pre-production environment for validation before release |
| Flaky Test | Test that passes/fails inconsistently without code changes |

---

*This is a living document. Please update as new information becomes available.*

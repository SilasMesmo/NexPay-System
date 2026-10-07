# NexPay — SLI, SLO and Error Budget

## 1. Purpose

This document defines the initial Service Level Indicators (SLIs), Service Level Objectives (SLOs) and error-budget model for the NexPay platform.

The values defined here are laboratory objectives and will be validated through measurement.

---

## 2. Service Level Indicators

The initial platform SLIs are:

### Availability

Measures the proportion of valid requests that are successfully processed.

Conceptually:

```text
Successful Valid Requests
-------------------------
Total Valid Requests
```

---

### Latency

Measures the time required to process requests.

Primary latency indicators:

* p50
* p90
* p95
* p99

The primary laboratory objective will use p95 latency.

---

### Error Rate

Measures the proportion of requests resulting in defined application failures.

```text
Failed Requests
---------------
Total Requests
```

---

### Throughput

Measures the amount of traffic processed by the platform.

Primary unit:

```text
requests/second
```

---

## 3. Service Level Objectives

### Availability

```text
SLO: 99.95%
```

### API Latency

```text
SLO: p95 < 200 ms
```

### Error Rate

Initial target:

```text
< 0.1%
```

The exact measurement methodology will be defined when the application and observability layers are implemented.

---

## 4. Traffic Objectives

The platform will be tested against:

| Scenario |        Target |
| -------- | ------------: |
| Normal   |   2,000 req/s |
| Peak     |  20,000 req/s |
| Extreme  | 50,000+ req/s |

Performance results will be recorded rather than assumed.

---

## 5. Error Budget

For an availability SLO of 99.95%, the theoretical error budget is:

```text
100% - 99.95% = 0.05%
```

The error budget represents the amount of unavailability that can occur while remaining within the defined SLO.

The budget should be treated as a reliability signal rather than as a target for failure.

---

## 6. SLO Measurement

SLO compliance will be evaluated using measured application telemetry.

The laboratory will distinguish between:

```text
Infrastructure Health
```

and:

```text
Service Health
```

For example, healthy Kubernetes nodes do not necessarily imply that the payment API is successfully processing requests.

---

## 7. Alerting

Alerts should eventually be based on service behavior rather than only infrastructure utilization.

Examples:

* elevated error rate
* elevated latency
* SLO burn
* queue backlog
* database failures
* unavailable application replicas
* abnormal traffic

---

## 8. SLO Validation

SLOs will be validated through controlled experiments including:

* normal load
* peak load
* application failure
* pod failure
* node failure
* dependency degradation
* deployment failure
* selected Availability Zone failure

The observed results will be recorded.

---

## 9. Observed vs Target

The laboratory will maintain a distinction between:

```text
Target
```

and:

```text
Observed
```

Example:

```text
Target p95:       < 200 ms
Observed p95:       143 ms
```

The observed value represents experimental evidence from the current implementation.

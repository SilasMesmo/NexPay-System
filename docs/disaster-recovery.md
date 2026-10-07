# NexPay — Disaster Recovery

## 1. Purpose

This document defines the disaster-recovery objectives, scenarios, recovery strategy and validation methodology for the NexPay platform.

---

## 2. Recovery Objectives

### Recovery Point Objective

```text
RPO ≤ 5 minutes
```

The maximum acceptable data-loss window for critical data is five minutes under the defined disaster scenario.

### Recovery Time Objective

```text
RTO ≤ 30 minutes
```

The target maximum recovery time for the critical payment platform is thirty minutes under the defined regional disaster scenario.

---

## 3. Disaster Scenarios

The laboratory will distinguish between different classes of failure.

### Application Failure

Examples:

* application crash
* bad deployment
* container failure

Expected response:

* restart
* rescheduling
* rollback
* automated recovery

---

### Node Failure

Examples:

* EC2 instance failure
* node termination

Expected response:

* pod rescheduling
* replacement capacity
* workload recovery

---

### Availability Zone Failure

A complete Availability Zone is considered unavailable.

The architecture should attempt to maintain service through capacity distributed across other Availability Zones.

---

### Regional Failure

The primary AWS region is considered unavailable.

This scenario requires recovery in a secondary region.

---

## 4. Recovery Strategy

The DR architecture will use a combination of:

* backups
* snapshots
* replicated data where applicable
* reproducible infrastructure
* application manifests
* container images
* configuration
* recovery procedures

The exact implementation will be defined during the DR phase.

---

## 5. Recovery Sequence

A conceptual regional recovery sequence is:

```text
Regional Failure
       |
       v
Failure Detection
       |
       v
Recovery Decision
       |
       v
Infrastructure Recovery
       |
       v
Data Recovery
       |
       v
Application Recovery
       |
       v
Traffic Restoration
       |
       v
Validation
```

---

## 6. Recovery Validation

The DR process must be tested rather than assumed.

Each exercise should record:

```text
Start Time
Detection Time
Recovery Start
Application Available
Data Available
Traffic Restored
Final Recovery Time
```

---

## 7. RTO Measurement

Example:

```text
Target RTO: 30 minutes

Observed:
Failure:       14:00
Detection:     14:03
Recovery:      14:05
Service Up:    14:21

Observed RTO: 21 minutes
```

The observed value becomes evidence about the actual recovery capability of the implementation.

---

## 8. RPO Measurement

Example:

```text
Target RPO: 5 minutes

Failure:
14:00

Latest recoverable data:
13:57

Observed RPO:
3 minutes
```

---

## 9. DR Test Scenarios

The laboratory should eventually execute:

1. Backup restoration
2. Database recovery
3. Application recovery
4. Infrastructure recreation
5. Regional recovery
6. Traffic restoration
7. End-to-end transaction validation

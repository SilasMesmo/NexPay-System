# NexPay — Platform Requirements

## 1. Purpose

This document defines the functional, non-functional, operational, security and resilience requirements for the NexPay payment platform.

These requirements represent the target conditions for the laboratory. They are hypotheses and engineering objectives for the simulation, not claims that a particular AWS architecture will automatically satisfy them.

---

## 2. Business Context

NexPay is a fictional digital payments platform that provides payment processing capabilities to e-commerce applications.

The platform exposes a payment API through which clients can submit payment transactions.

A typical transaction may involve:

1. Authentication
2. Request validation
3. Fraud evaluation
4. Account or limit verification
5. Payment processing
6. State persistence
7. Event publication
8. Downstream notification
9. Response to the client
10. End-to-end transaction traceability

The platform must remain operational during normal traffic, traffic spikes and controlled infrastructure failures.

---

## 3. Traffic Requirements

The laboratory will use the following traffic profiles:

| Profile      |          Target Traffic |
| ------------ | ----------------------: |
| Normal       |   2,000 requests/second |
| Peak         |  20,000 requests/second |
| Extreme Test | 50,000+ requests/second |

These values define the scenarios that the platform should be tested against.

They do not imply that the initial implementation must immediately sustain these loads in a production-like environment.

---

## 4. Availability Requirement

### Target

**Availability SLO: 99.95%**

Availability will represent the ability of the NexPay API to accept and correctly process valid requests.

Availability will be measured through application-level telemetry rather than infrastructure health alone.

---

## 5. Performance Requirements

### API Latency

**Target: p95 < 200 ms**

The latency objective applies to the defined payment API workload under the applicable test conditions.

Additional latency percentiles may be monitored, including:

* p50
* p90
* p95
* p99

---

## 6. Resilience Requirements

The platform should be designed and tested against infrastructure and application failures including:

* Kubernetes pod failure
* Kubernetes node failure
* sudden traffic increase
* application deployment failure
* service dependency failure
* database degradation
* queue backlog
* availability-zone failure
* credential or configuration failure

The objective is not to guarantee that failures never occur.

The objective is to establish predictable detection, recovery and degradation behavior.

---

## 7. Disaster Recovery Requirements

### Recovery Point Objective

**RPO ≤ 5 minutes**

The platform should be capable of recovering critical data with a maximum acceptable data-loss window of five minutes under the defined disaster-recovery scenario.

### Recovery Time Objective

**RTO ≤ 30 minutes**

The platform should target restoration of the critical payment platform within thirty minutes after a defined regional disaster scenario.

Actual RPO and RTO will be measured during disaster-recovery exercises.

---

## 8. Security Requirements

The platform must follow security principles including:

* least privilege
* workload identity
* encryption at rest
* encryption in transit where applicable
* centralized audit logging
* controlled administrative access
* secrets management
* network segmentation
* restricted public exposure
* vulnerability detection
* container image scanning
* infrastructure and application auditing

Secrets must not be hardcoded into source code or container images.

---

## 9. Audit Requirements

The platform must provide sufficient auditability to determine:

* who performed administrative actions
* what infrastructure changes occurred
* when changes occurred
* which application version was deployed
* which infrastructure configuration was active
* relevant security events
* relevant authentication and authorization events

---

## 10. Observability Requirements

The platform must provide visibility into:

### Metrics

* request rate
* error rate
* latency
* resource utilization
* Kubernetes health
* database health
* queue depth
* autoscaling behavior

### Logs

* application logs
* infrastructure logs
* security-related logs
* audit logs

### Traces

Distributed traces should allow investigation of a transaction across relevant services and dependencies.

---

## 11. Deployment Requirements

Application deployments should support:

* automated validation
* automated testing
* security scanning
* controlled promotion
* rollback
* progressive delivery where applicable
* deployment traceability

Production changes should be auditable.

---

## 12. Cost Requirements

The laboratory must remain financially controlled.

Cost must be considered during architecture decisions, including:

* compute
* Kubernetes
* database
* networking
* NAT
* observability
* storage
* data transfer

The laboratory should avoid unnecessary always-on resources when they do not contribute to the learning objective.

---

## 13. Architecture Constraints

The laboratory should prioritize:

1. Architectural correctness
2. Operations
3. Security
4. Reliability
5. Cost awareness
6. Automation

Technologies should not be introduced merely for the purpose of increasing the number of tools in the stack.

Every major component should have a documented engineering justification.

---

## 14. Success Criteria

The laboratory will be considered successful when the platform can demonstrate, through controlled experiments and evidence:

* deployment of the NexPay application
* observable application behavior
* controlled scaling
* recovery from selected failures
* controlled application releases
* security controls
* infrastructure reproducibility
* disaster-recovery procedures
* measured RPO/RTO
* documented architectural decisions
* documented operational procedures

---

## 15. Requirement Philosophy

The laboratory follows the principle:

> Requirements define what the platform must achieve. Architecture defines how those requirements will be satisfied. Technology is selected to implement that architecture.

The laboratory will therefore avoid selecting technologies before understanding the problem they are intended to solve.

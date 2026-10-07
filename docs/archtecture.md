# NexPay — Architecture

## 1. Purpose

This document describes the high-level architecture of the NexPay payment platform and explains how the architecture is intended to satisfy the requirements defined in `requirements.md`.

The architecture will be implemented incrementally and validated through controlled experiments.

---

## 2. Architectural Principles

The NexPay platform follows these principles:

### Reliability

Critical workloads should be distributed across multiple Availability Zones where practical.

### Stateless Application Design

Application services should minimize local state so that workloads can be replicated and rescheduled without requiring persistent local storage.

### Least Privilege

Applications, operators and infrastructure components should receive only the permissions required to perform their responsibilities.

### Automation

Operational tasks that can be reliably automated should be automated.

### Observability

The platform should expose sufficient metrics, logs and traces to understand system behavior.

### Controlled Failure

The platform should be deliberately tested against failures to validate resilience assumptions.

### Cost Awareness

Architectural decisions should consider both reliability and operational cost.

### Reproducibility

Infrastructure and application configuration should eventually be reproducible through Infrastructure as Code.

---

## 3. Logical Architecture

The initial logical architecture is:

```text
                         INTERNET
                             |
                             v
                     +---------------+
                     |     EDGE      |
                     | WAF / Routing |
                     +-------+-------+
                             |
                             v
                     +---------------+
                     | Load Balancer |
                     +-------+-------+
                             |
                             v
              +-------------------------------+
              |        APPLICATION PLATFORM   |
              |                               |
              |  +---------+  +-----------+  |
              |  | Payments|  |   Fraud   |  |
              |  +---------+  +-----------+  |
              |                               |
              |  +-----------+ +-------------+|
              |  | Accounts  | |Notifications||
              |  +-----------+ +-------------+|
              +---------------+---------------+
                              |
               +--------------+--------------+
               |              |              |
               v              v              v
           Database         Cache         Messaging
               |              |              |
               v              v              v
             State         Temporary       Events
```

---

## 4. Infrastructure Architecture

The application platform will run on AWS infrastructure designed around multiple Availability Zones.

Conceptually:

```text
                         AWS REGION
                              |
                    +---------+---------+
                    |                   |
                  AZ-A                 AZ-B
                    |                   |
              Application         Application
                Capacity             Capacity
                    |                   |
                    +---------+---------+
                              |
                         Data Layer
```

A third Availability Zone may be introduced where it provides meaningful reliability or learning value without creating unnecessary laboratory cost.

---

## 5. Application Layer

The application layer will contain multiple services representing the NexPay business domain.

Initial services:

* Payments
* Fraud
* Accounts
* Notifications

Services should expose:

* health checks
* readiness checks
* liveness checks
* metrics
* logs
* distributed tracing

The application layer should remain as stateless as practical.

---

## 6. Data Layer

The platform will contain stateful components for:

* transactional data
* caching
* asynchronous messaging
* event processing

The data layer will be treated separately from the stateless application layer because state introduces different availability, backup, recovery and scaling considerations.

---

## 7. Synchronous and Asynchronous Processing

Not every operation needs to remain synchronous.

The architecture will distinguish between:

### Synchronous operations

Used when the client requires an immediate response.

```text
Client
  |
  v
Payment API
  |
  v
Validation
  |
  v
Payment Processing
  |
  v
Response
```

### Asynchronous operations

Used when immediate completion is unnecessary or when decoupling improves resilience.

```text
Payment
   |
   v
Event
   |
   v
Queue
   |
   +----> Fraud
   |
   +----> Notification
   |
   +----> Analytics
```

This separation allows selected downstream failures to be isolated from the critical request path.

---

## 8. Availability Strategy

Availability will be addressed through multiple mechanisms:

* multi-AZ deployment
* workload replication
* health checks
* automated rescheduling
* autoscaling
* controlled deployment strategies
* dependency isolation
* backup and recovery
* disaster recovery procedures

These mechanisms are hypotheses to be validated through experiments rather than assumptions of guaranteed availability.

---

## 9. Scaling Strategy

The platform will support multiple levels of scaling.

### Application Scaling

Application replicas can increase based on workload demand.

```text
Traffic
   |
   v
HPA
   |
   v
More Pods
```

### Infrastructure Scaling

When existing compute capacity is insufficient:

```text
Pending Pods
     |
     v
Node Provisioning
     |
     v
Additional Capacity
```

The laboratory will later evaluate dynamic node provisioning and different capacity types.

---

## 10. Security Architecture

Security will be implemented across multiple layers:

```text
Internet
   |
   v
Edge Protection
   |
   v
Network Controls
   |
   v
Identity
   |
   v
Application
   |
   v
Data
```

Security controls will include:

* IAM
* workload identity
* network segmentation
* security groups
* secrets management
* encryption
* audit logging
* vulnerability scanning
* container security
* admission policies

---

## 11. Observability Architecture

The platform will implement three primary observability signals:

```text
             OBSERVABILITY
                  |
       +----------+----------+
       |          |          |
      Logs      Metrics     Traces
       |          |          |
   CloudWatch  Prometheus  OpenTelemetry
       |          |          |
       +----------+----------+
                  |
               Dashboards
```

Observability will be used not only for monitoring but also for troubleshooting, SLO measurement and incident analysis.

---

## 12. Disaster Recovery Architecture

The primary deployment will operate in a designated AWS region.

A secondary region will be introduced during the disaster-recovery phase.

Conceptually:

```text
              PRIMARY REGION
                    |
             Production Stack
                    |
          Replication / Backup
                    |
                    v
                DR REGION
                    |
              Recovery Stack
```

The final DR architecture will be selected after defining the recovery requirements and evaluating cost and complexity.

---

## 13. Deployment Architecture

Application delivery will eventually follow:

```text
Developer
    |
    v
Source Repository
    |
    v
CI Pipeline
    |
    +--> Tests
    +--> Security Scanning
    +--> Build
    +--> Image
    |
    v
Container Registry
    |
    v
Deployment Configuration
    |
    v
GitOps
    |
    v
Kubernetes
```

Automation through Infrastructure as Code and GitOps will be introduced progressively after the underlying architecture has been understood and validated.

---

## 14. Architectural Evolution

The architecture will be implemented in stages:

1. Foundation
2. Networking
3. Identity and security
4. Observability
5. Container platform
6. Kubernetes platform
7. Application
8. Stateful services
9. Messaging
10. CI/CD
11. GitOps
12. Reliability
13. Security and supply chain
14. Chaos engineering
15. Disaster recovery
16. Infrastructure as Code
17. FinOps and hardening

Each stage should introduce a meaningful capability and provide an opportunity for validation.

##

# NexPay Payments Service

## Responsibility

The Payments Service is responsible for receiving payment requests, validating them, persisting payment state in PostgreSQL and publishing payment lifecycle events.

The service does not treat Redis as the source of truth.

PostgreSQL is the source of truth for payment state.

---

## API

### Create Payment

```text
POST /payments
```

Request:

```json
{
  "customer_id": "cus-123",
  "merchant_id": "merchant-456",
  "amount": 150.00,
  "currency": "BRL",
  "idempotency_key": "idem-789"
}
```

Response:

```json
{
  "payment_id": "pay-001",
  "status": "completed",
  "customer_id": "cus-123",
  "merchant_id": "merchant-456",
  "amount": 150.00,
  "currency": "BRL"
}
```

---

## Payment Lifecycle

The initial lifecycle is:

```text
received
   |
   v
validated
   |
   v
processing
   |
   v
completed
```

A failed transaction may become:

```text
failed
```

The payment state stored in PostgreSQL is authoritative.

---

## Idempotency

Each payment request contains an `idempotency_key`.

The service must guarantee that retrying the same request does not create multiple payments.

Conceptually:

```text
Request 1
   |
   v
idempotency_key = idem-789
   |
   v
Payment created

Request 2
   |
   v
same idempotency_key
   |
   v
existing payment returned
```

This prevents duplicate financial operations when clients retry requests or when network failures occur.

---

## Event Publishing

After the payment transaction is successfully committed in PostgreSQL, the service publishes:

```text
PaymentCompleted
```

The event contains:

```json
{
  "event_id": "evt-001",
  "event_type": "PaymentCompleted",
  "payment_id": "pay-001",
  "customer_id": "cus-123",
  "merchant_id": "merchant-456",
  "amount": 150.00,
  "currency": "BRL"
}
```

The event is published to the NexPay payment events SNS topic.

```text
PostgreSQL
    |
    | COMMIT
    v
PaymentCompleted
    |
    v
SNS
    |
    +----> Fraud
    +----> Notification
    +----> Analytics
```

---

## Health Endpoints

### Liveness

```text
GET /health
```

Indicates that the application process is running.

### Readiness

```text
GET /ready
```

Indicates that the application is ready to receive traffic.

Readiness may verify required dependencies such as PostgreSQL.

Redis should not make the entire service unavailable simply because the cache is temporarily unavailable.

---

## Data Ownership

```text
PostgreSQL
    |
    +-- payment state
    +-- transaction records
    +-- idempotency records

Redis
    |
    +-- cache
    +-- temporary data

SNS/SQS
    |
    +-- asynchronous events
```

Redis and messaging must not become the source of truth for payment state.

---

## Initial Architecture

```text
Client
  |
  v
Payments API
  |
  +----> PostgreSQL
  |
  +----> Redis
  |
  +----> SNS
           |
           +----> Fraud
           +----> Notification
           +----> Analytics
```

The service will eventually expose metrics, structured logs and distributed traces for operational observability.

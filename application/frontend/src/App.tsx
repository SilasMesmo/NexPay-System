import { type FormEvent, useState } from "react";
import "./App.css";

type PaymentResponse = {
payment_id: string;
status: string;
customer_id: string;
merchant_id: string;
amount: number | string;
currency: string;
};

type IconProps = {
size?: number;
};

function LogoMark({ size = 42 }: IconProps) {
return (
<svg width={size} height={size} viewBox="0 0 48 48" fill="none" aria-hidden="true" >
<path d="M7 36.5L16.5 10H24L17 31L29 10H38L19 36.5H7Z" fill="currentColor" />
<path d="M30 10H41L34 36.5H23L30 10Z" fill="currentColor" opacity="0.55" />
</svg>
);
}

function CardIcon({ size = 24 }: IconProps) {
return (
<svg width={size} height={size} viewBox="0 0 24 24" fill="none">
<rect x="3" y="5" width="18" height="14" rx="3" stroke="currentColor" strokeWidth="1.8" />
<path d="M3 9H21" stroke="currentColor" strokeWidth="1.8" />
<path d="M7 14H11" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
</svg>
);
}

function CheckIcon({ size = 24 }: IconProps) {
return (
<svg width={size} height={size} viewBox="0 0 24 24" fill="none">
<circle cx="12" cy="12" r="9" stroke="currentColor" strokeWidth="1.8" />
<path d="M8 12.5L10.5 15L16 9.5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" />
</svg>
);
}

function HomeIcon({ size = 22 }: IconProps) {
return (
<svg width={size} height={size} viewBox="0 0 24 24" fill="none">
<path d="M4 11.5L12 5L20 11.5V19H4V11.5Z" stroke="currentColor" strokeWidth="1.8" strokeLinejoin="round" />
<path d="M9 19V14H15V19" stroke="currentColor" strokeWidth="1.8" />
</svg>
);
}

function TransactionsIcon({ size = 22 }: IconProps) {
return (
<svg width={size} height={size} viewBox="0 0 24 24" fill="none">
<rect x="5" y="3.5" width="14" height="17" rx="2" stroke="currentColor" strokeWidth="1.8" />
<path d="M8.5 8H15.5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
<path d="M8.5 12H15.5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
<path d="M8.5 16H13" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
</svg>
);
}

function ReportsIcon({ size = 22 }: IconProps) {
return (
<svg width={size} height={size} viewBox="0 0 24 24" fill="none">
<path d="M5 19V11" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
<path d="M12 19V6" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
<path d="M19 19V3" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
</svg>
);
}

function SettingsIcon({ size = 22 }: IconProps) {
return (
<svg width={size} height={size} viewBox="0 0 24 24" fill="none">
<circle cx="12" cy="12" r="3" stroke="currentColor" strokeWidth="1.8" />
<path d="M19 13.5V10.5L17.2 9.9C17 9.3 16.7 8.8 16.3 8.3L17 6.6L14.4 5L13.2 6.3C12.4 6.2 11.7 6.2 10.9 6.3L9.6 5L7 6.6L7.7 8.3C7.3 8.8 7 9.3 6.8 9.9L5 10.5V13.5L6.8 14.1C7 14.7 7.3 15.2 7.7 15.7L7 17.4L9.6 19L10.8 17.7C11.6 17.8 12.3 17.8 13.1 17.7L14.4 19L17 17.4L16.3 15.7L17.2 14.1L19 13.5Z" stroke="currentColor" strokeWidth="1.2" strokeLinejoin="round" />
</svg>
);
}

function UserIcon({ size = 20 }: IconProps) {
return (
<svg width={size} height={size} viewBox="0 0 24 24" fill="none">
<circle cx="12" cy="8" r="3" stroke="currentColor" strokeWidth="1.8" />
<path d="M5.5 20C5.5 16.7 8.4 14.5 12 14.5C15.6 14.5 18.5 16.7 18.5 20" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
</svg>
);
}

function App() {
const [customerId, setCustomerId] = useState("");
const [merchantId, setMerchantId] = useState("");
const [amount, setAmount] = useState("");
const [currency, setCurrency] = useState("BRL");
const [idempotencyKey, setIdempotencyKey] = useState("");

const [payment, setPayment] = useState<PaymentResponse | null>(null);
const [loading, setLoading] = useState(false);
const [error, setError] = useState("");

const API_URL =
import.meta.env.VITE_API_URL ?? "http://localhost:8000";

async function handleSubmit(event: FormEvent<HTMLFormElement>) {
event.preventDefault();

setLoading(true);
setError("");
setPayment(null);

try {
  const response = await fetch(`${API_URL}/payments`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      customer_id: customerId,
      merchant_id: merchantId,
      amount: Number(amount),
      currency,
      idempotency_key: idempotencyKey,
    }),
  });

  if (!response.ok) {
    const errorBody = await response.json().catch(() => null);

    throw new Error(
      errorBody?.detail ?? `API returned HTTP ${response.status}`,
    );
  }

  const data: PaymentResponse = await response.json();

  setPayment(data);
} catch (err) {
  setError(
    err instanceof Error
      ? err.message
      : "Unable to process payment",
  );
} finally {
  setLoading(false);
}

}

return (
<div className="app-shell">
<aside className="sidebar">
<div className="brand">
<div className="brand-mark">
<LogoMark size={42} />
</div>

      <span className="brand-name">
        Nex<span>Pay</span>
      </span>
    </div>

    <nav className="sidebar-nav">
      <a className="nav-item active" href="#">
        <HomeIcon />
        <span>Payments</span>
      </a>

      <a className="nav-item" href="#">
        <TransactionsIcon />
        <span>Transactions</span>
      </a>

      <a className="nav-item" href="#">
        <ReportsIcon />
        <span>Reports</span>
      </a>

      <a className="nav-item" href="#">
        <SettingsIcon />
        <span>Settings</span>
      </a>
    </nav>

    <div className="sidebar-footer">
      <div className="online-dot" />

      <div>
        <strong>NexPay Platform</strong>
        <span>v1.0.0</span>
      </div>
    </div>
  </aside>

  <main className="main-content">
    <header className="topbar">
      <div className="system-status">
        <span className="status-dot" />
        <span>System Online</span>
      </div>

      <div className="user-avatar">
        <UserIcon />
      </div>
    </header>

    <section className="content">
      <div className="hero">
        <div>
          <h1>Payment Dashboard</h1>

          <p>
            Process payments, monitor transactions and keep your
            business moving.
          </p>
        </div>

        <div className="hero-tagline">
          <strong>Fast. Secure. Global.</strong>
          <span />
        </div>
      </div>

      <div className="dashboard-grid">
        <section className="card payment-card">
          <div className="card-heading">
            <div className="heading-icon">
              <CardIcon />
            </div>

            <div>
              <h2>Create Payment</h2>

              <p>
                Submit a payment transaction to the NexPay platform.
              </p>
            </div>
          </div>

          <form
            onSubmit={handleSubmit}
            className="payment-form"
          >
            <label>
              Customer ID

              <input
                value={customerId}
                onChange={(event) =>
                  setCustomerId(event.target.value)
                }
                placeholder="cus-123456"
                required
              />
            </label>

            <label>
              Merchant ID

              <input
                value={merchantId}
                onChange={(event) =>
                  setMerchantId(event.target.value)
                }
                placeholder="merchant-789012"
                required
              />
            </label>

            <div className="input-row">
              <label>
                Amount

                <input
                  type="number"
                  min="0.01"
                  step="0.01"
                  value={amount}
                  onChange={(event) =>
                    setAmount(event.target.value)
                  }
                  placeholder="150.00"
                  required
                />
              </label>

              <label>
                Currency

                <select
                  value={currency}
                  onChange={(event) =>
                    setCurrency(event.target.value)
                  }
                >
                  <option value="BRL">BRL</option>
                  <option value="USD">USD</option>
                  <option value="EUR">EUR</option>
                </select>
              </label>
            </div>

            <label>
              Idempotency Key

              <input
                value={idempotencyKey}
                onChange={(event) =>
                  setIdempotencyKey(event.target.value)
                }
                placeholder="idem-abc123"
                required
              />
            </label>

            <button
              className="submit-button"
              type="submit"
              disabled={loading}
            >
              <span>
                {loading ? "Processing..." : "Process Payment"}
              </span>

              <span className="button-arrow">→</span>
            </button>
          </form>

          {error && (
            <div className="error-box">
              <strong>Request failed</strong>

              <span>{error}</span>
            </div>
          )}
        </section>

        <section className="card result-card">
          <div className="card-heading">
            <div className="heading-icon">
              <CheckIcon />
            </div>

            <div>
              <h2>Payment Result</h2>

              <p>
                The response from the payment processing will
                appear here.
              </p>
            </div>
          </div>

          {!payment && !error && (
            <div className="empty-state">
              <div className="empty-icon">
                <CardIcon size={42} />
              </div>

              <h3>No payment processed yet.</h3>

              <p>
                Fill in the form on the left and click
                <br />
                "Process Payment" to see the result.
              </p>
            </div>
          )}

          {payment && (
            <div className="result-content">
              <div className="result-row">
                <span>Payment ID</span>
                <strong>{payment.payment_id}</strong>
              </div>

              <div className="result-row">
                <span>Status</span>
                <strong className="status-value">
                  {payment.status}
                </strong>
              </div>

              <div className="result-row">
                <span>Customer</span>
                <strong>{payment.customer_id}</strong>
              </div>

              <div className="result-row">
                <span>Merchant</span>
                <strong>{payment.merchant_id}</strong>
              </div>

              <div className="result-row">
                <span>Amount</span>

                <strong>
                  {payment.currency}{" "}
                  {Number(payment.amount).toFixed(2)}
                </strong>
              </div>
            </div>
          )}
        </section>
      </div>
    </section>

    <footer className="footer">
      <div className="footer-brand">
        <div className="footer-logo">
          <LogoMark size={28} />
        </div>

        <strong>NexPay</strong>
      </div>

      <span>
        Powering the next generation of payments.
      </span>
    </footer>
  </main>
</div>

);
}

export default App;
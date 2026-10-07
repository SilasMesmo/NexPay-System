from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from nexpay_payments.api.payments import router as payments_router
from nexpay_payments.config import settings

app = FastAPI(
    title="NexPay Payments Service",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://127.0.0.1:5173",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(payments_router)


@app.get("/health")
def health() -> dict[str, str]:
    return {
        "status": "ok",
        "service": settings.app_name,
    }


@app.get("/ready")
def ready() -> dict[str, str]:
    return {
        "status": "ready",
        "service": settings.app_name,
    }
from typing import Annotated
from uuid import uuid4

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from nexpay_payments.db import get_db
from nexpay_payments.models import Payment
from nexpay_payments.schemas import PaymentCreate, PaymentResponse

router = APIRouter(prefix="/payments", tags=["payments"])

@router.post("", response_model=PaymentResponse)
def create_payment(
    payload: PaymentCreate,
    db: Annotated[Session, Depends(get_db)],
) -> PaymentResponse:
    
    currency = payload.currency.upper()

    existing_payment = db.scalar(
        select(Payment).where(
            Payment.idempotency_key == payload.idempotency_key
        )
    )

    if existing_payment:
        if (
            existing_payment.customer_id != payload.customer_id
            or existing_payment.merchant_id != payload.merchant_id
            or existing_payment.amount != payload.amount
            or existing_payment.currency != currency
        ):
            raise HTTPException(
                status_code=409,
                detail="Idempotency key was already used with different payment data",
            )

        return PaymentResponse.model_validate(existing_payment)

    payment = Payment(
        payment_id=str(uuid4()),
        customer_id=payload.customer_id,
        merchant_id=payload.merchant_id,
        amount=payload.amount,
        currency=currency,
        status="completed",
        idempotency_key=payload.idempotency_key,
    )

    db.add(payment)
    db.commit()
    db.refresh(payment)

    return PaymentResponse.model_validate(payment)
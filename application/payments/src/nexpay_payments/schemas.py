from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class PaymentCreate(BaseModel):
    customer_id: str
    merchant_id: str
    amount: Decimal = Field(gt=0)
    currency: str = Field(min_length=3, max_length=3)
    idempotency_key: str


class PaymentResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    payment_id: str
    status: str
    customer_id: str
    merchant_id: str
    amount: Decimal
    currency: str
from decimal import Decimal

from sqlalchemy import Numeric, String
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


class Base(DeclarativeBase):
    pass


class Payment(Base):
    __tablename__ = "payments"

    payment_id: Mapped[str] = mapped_column(
        String(36),
        primary_key=True,
    )

    customer_id: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
    )

    merchant_id: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
    )

    amount: Mapped[Decimal] = mapped_column(
        Numeric(18, 2),
        nullable=False,
    )

    currency: Mapped[str] = mapped_column(
        String(3),
        nullable=False,
    )

    status: Mapped[str] = mapped_column(
        String(30),
        nullable=False,
    )

    idempotency_key: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
        unique=True,
        index=True,
    )
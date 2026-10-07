import os

from pydantic import BaseModel


class Settings(BaseModel):
    app_name: str = "nexpay-payments"
    environment: str = os.getenv("ENVIRONMENT", "dev")
    database_url: str = os.getenv(
        "DATABASE_URL",
        "postgresql+psycopg://nexpay:nexpay@localhost:5432/nexpay",
    )


settings = Settings()
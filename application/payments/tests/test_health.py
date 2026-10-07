from fastapi.testclient import TestClient

from nexpay_payments.main import app

client = TestClient(app)


def test_health() -> None:
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_ready() -> None:
    response = client.get("/ready")

    assert response.status_code == 200
    assert response.json()["status"] == "ready"
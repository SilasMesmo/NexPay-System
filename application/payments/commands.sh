python3 -m venv .venv

source .venv/bin/activate

python -m pip install --upgrade pip
python -m pip install -e ".[dev]"

pytest

python -m uvicorn nexpay_payments.main:app --reload

# Docker
docker build -t nexpay-payments:local .

docker run --rm \
  --name nexpay-payments-local \
  -p 8001:8000 \
  nexpay-payments:local

# Front
docker build -t nexpay-frontend:local .

docker run --rm \
  --name nexpay-frontend-local \
  -p 8080:80 \
  nexpay-frontend:local
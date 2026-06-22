FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y gcc libpq-dev netcat-openbsd curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m appuser
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

CMD ["gunicorn", "notesy.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "1"]

HEALTHCHECK CMD curl -f http://localhost:8000 || exit 1

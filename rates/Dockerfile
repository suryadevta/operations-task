FROM python:3.10-slim as builder

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc

COPY rates/requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt


FROM python:3.10-slim

WORKDIR /app

RUN pip install -U gunicorn
RUN apt update && apt install -y postgresql-client
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .
COPY /rates/entrypoint.sh .
RUN chmod +x entrypoint.sh
COPY db/rates.sql /app/
COPY rates/*.py /app/

RUN pip install --no-cache /wheels/*

ENTRYPOINT ["./entrypoint.sh"]
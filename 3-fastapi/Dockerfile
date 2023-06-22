ARG AWS_ACCOUNT_ID
ARG AWS_REGION=${AWS_REGION:-"ap-northeast-1"}
ARG TRAINER_VERSION=${TRAINER_VERSION:-"latest"}
FROM ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/container4ml-jupyter:${TRAINER_VERSION} AS trainer

# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.9-slim
ENV APP_HOME=/app
ENV MODEL_NAME=${MODEL_NAME:-"A"}

# Install production dependencies.
RUN apt update && apt install -y --no-install-recommends \
    build-essential \
 && apt clean \
 && rm -rf /var/lib/apt/lists/* \
 && pip install -U pip && pip install --no-cache-dir poetry
COPY pyproject.toml poetry.lock ./
RUN poetry export --without-hashes -f requirements.txt -o requirements.txt \
 && pip install -r requirements.txt --no-cache-dir

# via multi-stage build: Get model binary from trainer
WORKDIR /models
COPY --from=trainer /app/ua_classifier.bin .

# Copy local code to the container image.
WORKDIR ${APP_HOME}
COPY main.py .

EXPOSE 80

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
CMD ["gunicorn", "main:app", "--bind=0.0.0.0:80", "--workers=1", "--threads=8", "--timeout=0", "--worker-class=uvicorn.workers.UvicornWorker"]

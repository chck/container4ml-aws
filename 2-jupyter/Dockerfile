# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.9-slim
ENV APP_HOME /app

# Install production dependencies.
RUN apt update && apt install -y --no-install-recommends \
    build-essential curl unzip \
 && apt clean \
 && rm -rf /var/lib/apt/lists/* \
 && pip install -U pip && pip install --no-cache-dir poetry
COPY pyproject.toml poetry.lock ./
RUN poetry export --without-hashes -f requirements.txt -o requirements.txt \
 && pip install -r requirements.txt --no-cache-dir

WORKDIR ${APP_HOME}
# Tips: Wildcard can build image w/ or w/o model binary.
COPY *.bin .
EXPOSE 8888

CMD ["jupyter", "lab", "--allow-root", "--ip=0.0.0.0", "--no-browser", "--ServerApp.allow_origin=*", "--ServerApp.token=", "--ServerApp.password="]

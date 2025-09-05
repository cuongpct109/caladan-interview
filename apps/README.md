# Latency App

This directory contains the source code for the Latency App, a Flask-based application that measures network latency to a target host.

## Features

- Measures latency to a configurable target host.
- Exposes results via the `/metrics` API endpoint.
- Can be run locally or in Docker.

## Usage

### Local

```sh
pip install -r requirements.txt
python main.py
```

### Docker

```sh
docker build -t latency-app .
docker run -e TARGET_HOST=<ip-server-2> -p 5000:5000 latency-app
```

### API

- `GET /metrics`  
  Returns: `{ "latency_ms": <ms>, "status": "ok" }`

## Configuration

- Set the environment variable `TARGET_HOST` to specify the target IP or hostname.

---
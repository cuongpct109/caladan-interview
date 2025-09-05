from flask import Flask, jsonify
import threading
import time
import os
from ping3 import ping

app = Flask(__name__)

# Target host to measure latency
TARGET_HOST = os.getenv("TARGET_HOST", "127.0.0.1")  # default = 127.0.0.1
# Interval between latency checks (seconds)
INTERVAL = 5

# Store the latest latency result
latency_ms = None

def measure_latency():
    global latency_ms
    while True:
        try:
            # ping3 returns latency in seconds, or None if unreachable
            latency = ping(TARGET_HOST, timeout=2)
            latency_ms = latency * 1000 if latency is not None else None
        except Exception:
            latency_ms = None
        time.sleep(INTERVAL)

# API endpoint to expose latency
@app.route("/metrics")
def metrics():
    if latency_ms is None:
        return jsonify({"latency_ms": None, "status": "unreachable"}), 503
    return jsonify({"latency_ms": latency_ms, "status": "ok"}), 200

if __name__ == "__main__":
    # Start background thread for latency measurement
    thread = threading.Thread(target=measure_latency, daemon=True)
    thread.start()

    # Start Flask app
    app.run(host="0.0.0.0", port=5000)

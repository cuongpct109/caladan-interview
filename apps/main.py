from flask import Flask, jsonify
import subprocess
import threading
import time
import os

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
            # Use ping with 1 packet, return response time
            result = subprocess.run(
                ["ping", "-c", "1", TARGET_HOST],
                capture_output=True,
                text=True
            )
            if result.returncode == 0:
                # Parse response time from output: time=xx ms
                for line in result.stdout.splitlines():
                    if "time=" in line:
                        latency_ms = float(line.split("time=")[1].split()[0])
            else:
                latency_ms = None
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
    
    # Run Flask server
    app.run(host="0.0.0.0", port=5000)

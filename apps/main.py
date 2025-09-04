from flask import Flask, jsonify
import subprocess
import threading
import time

app = Flask(__name__)

# Host cần đo latency
TARGET_HOST = "SECOND_SERVER_IP_OR_HOSTNAME"
# Khoảng thời gian đo latency (giây)
INTERVAL = 5

# Lưu kết quả ping gần nhất
latency_ms = None

def measure_latency():
    global latency_ms
    while True:
        try:
            # Dùng ping 1 gói, trả về thời gian
            result = subprocess.run(
                ["ping", "-c", "1", TARGET_HOST],
                capture_output=True,
                text=True
            )
            if result.returncode == 0:
                # parse thời gian từ output: time=xx ms
                for line in result.stdout.splitlines():
                    if "time=" in line:
                        latency_ms = float(line.split("time=")[1].split()[0])
            else:
                latency_ms = None
        except Exception:
            latency_ms = None
        time.sleep(INTERVAL)

# API để expose latency
@app.route("/metrics")
def metrics():
    if latency_ms is None:
        return jsonify({"latency_ms": None, "status": "unreachable"}), 503
    return jsonify({"latency_ms": latency_ms, "status": "ok"}), 200

if __name__ == "__main__":
    # Start thread đo latency
    thread = threading.Thread(target=measure_latency, daemon=True)
    thread.start()
    
    # Run Flask server
    app.run(host="0.0.0.0", port=5000)

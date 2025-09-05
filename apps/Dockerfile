# --------------------------
# 1. Builder stage
# --------------------------
FROM python:3.11-slim AS builder

# Set working directory
WORKDIR /app

# Create virtual environment
RUN python -m venv /opt/venv

# Ensure venv is used
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# --------------------------
# 2. Runner stage
# --------------------------
FROM python:3.11-slim AS runner

# Set working directory
WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv

# Ensure venv is used
ENV PATH="/opt/venv/bin:$PATH"

# ✅ Default value for TARGET_HOST (can be overridden at runtime)
ENV TARGET_HOST=127.0.0.1

# Copy only the application code
COPY . .

# Expose port 5000
EXPOSE 5000

# Run the app
CMD ["python", "main.py"]

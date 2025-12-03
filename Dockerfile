FROM python:3.12-slim AS builder

# 1. Install build dependencies (compilers and headers)
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libjpeg-dev \
    zlib1g-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# 2. Compile from source
# --no-binary :all: forces downloading source tarballs and compiling them,
# ensuring we don't use pre-built binary wheels.
RUN pip wheel --no-cache-dir --no-binary :all: --wheel-dir=/build/wheels \
    pydyf==0.12.1 \
    tinycss2==1.5.1 \
    weasyprint==67.0 \
    aiohttp==3.13.2

# ---------------------------------------------------------------------------

FROM python:3.12-slim

# 3. Install runtime dependencies (libraries and fonts)
RUN apt-get update && apt-get install -y \
    libcairo2 \
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
    libgdk-pixbuf2.0-0 \
    libffi-dev \
    libjpeg-dev \
    zlib1g-dev \
    fonts-liberation \
    fonts-liberation2 \
    fonts-linuxlibertine \
    fonts-freefont-ttf \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 4. Copy compiled wheels from builder stage
COPY --from=builder /build/wheels /wheels

# 5. Install the compiled wheels
RUN pip install --no-cache-dir --no-index --find-links=/wheels \
    weasyprint \
    aiohttp

COPY server.py .

EXPOSE 8080

CMD ["python3", "server.py"]

FROM python:3.12-slim

# Install WeasyPrint dependencies and fonts
RUN apt-get update && apt-get install -y \
    libcairo2 \
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
    libgdk-pixbuf-xlib-2.0-0 \
    libffi-dev \
    libjpeg-dev \
    zlib1g-dev \
    fonts-liberation \
    fonts-liberation2 \
    fonts-linuxlibertine \
    fonts-freefont-ttf \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python packages
RUN pip install --no-cache-dir weasyprint==67.0 aiohttp==3.13.2

# Copy application code
COPY server.py .

EXPOSE 8080

CMD ["python3", "server.py"]

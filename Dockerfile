# Use official Python image as base
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies (including Java for Elasticsearch)
RUN apt-get update && apt-get install -y \
    default-jre \
    curl \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for running Elasticsearch (FIXED)
RUN groupadd -r elasticsearch && \
    useradd -r -g elasticsearch elasticsearch && \
    mkdir -p /opt/elasticsearch && \
    mkdir -p /var/log/elasticsearch && \
    mkdir -p /opt/elasticsearch/logs && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch /var/log/elasticsearch

# Install Elasticsearch
RUN wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.13-linux-x86_64.tar.gz && \
    tar -xzf elasticsearch-7.17.13-linux-x86_64.tar.gz -C /opt/elasticsearch --strip-components=1 && \
    rm elasticsearch-7.17.13-linux-x86_64.tar.gz && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch

# Copy requirements first (for better caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Configure Elasticsearch for container environment with correct paths
RUN echo "http.host: 0.0.0.0" >> /opt/elasticsearch/config/elasticsearch.yml && \
    echo "transport.host: 127.0.0.1" >> /opt/elasticsearch/config/elasticsearch.yml && \
    echo "discovery.type: single-node" >> /opt/elasticsearch/config/elasticsearch.yml && \
    echo "path.logs: /opt/elasticsearch/logs" >> /opt/elasticsearch/config/elasticsearch.yml && \
    echo "path.data: /opt/elasticsearch/data" >> /opt/elasticsearch/config/elasticsearch.yml && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch/config/elasticsearch.yml

# Fix Flask app to bind to all interfaces
# RUN grep -l "app.run" /app/*.py | xargs -r sed -i 's/app.run(/app.run( /g'

# Expose Flask port
EXPOSE 4113

# Create a startup script to run both Elasticsearch and Flask
RUN echo '#!/bin/bash\n\
# Ensure log directory exists and has proper permissions\n\
mkdir -p /opt/elasticsearch/logs\n\
mkdir -p /opt/elasticsearch/data\n\
chown -R elasticsearch:elasticsearch /opt/elasticsearch\n\
\n\
# Start Elasticsearch as the elasticsearch user\n\
su elasticsearch -c "/opt/elasticsearch/bin/elasticsearch -d"\n\
\n\
# Wait for Elasticsearch to become available\n\
echo "Waiting for Elasticsearch to start..."\n\
for i in {1..60}; do\n\
  if curl -s http://localhost:9200 > /dev/null; then\n\
    echo "Elasticsearch is up!"\n\
    python reset_elasticsearch.py\n\
    python app.py\n\
    exit 0\n\
  fi\n\
  echo "Still waiting... ($i/60)"\n\
  sleep 2\n\
done\n\
\n\
echo "Elasticsearch failed to start within timeout."\n\
if [ -f /opt/elasticsearch/logs/elasticsearch.log ]; then\n\
  echo "Last 20 lines of Elasticsearch log:"\n\
  tail -n 20 /opt/elasticsearch/logs/elasticsearch.log\n\
fi\n\
exit 1\n' > /app/start.sh \
    && chmod +x /app/start.sh

# Set entry point
ENTRYPOINT ["/app/start.sh"]
FROM n8nio/n8n:latest

# Switch to node user (Render runs as node)
USER node

# Set working dir for custom nodes
WORKDIR /home/node

# Install SerpApi community node into n8n’s custom nodes directory
RUN mkdir -p /home/node/.n8n/nodes \
    && cd /home/node/.n8n/nodes \
    && npm init -y \
    && npm install n8n-nodes-serpapi

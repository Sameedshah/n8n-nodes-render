# Start from official n8n image
FROM n8nio/n8n:latest

# Install SerpApi Community Node globally
RUN npm install -g n8n-nodes-serpapi

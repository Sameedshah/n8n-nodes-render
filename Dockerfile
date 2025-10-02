# 1. Base Image: Start with the official n8n Docker image
FROM n8nio/n8n:latest

# 2. Set Working Directory
WORKDIR /usr/local/lib/node_modules/n8n

# 3. Define the custom nodes to install
# We create a temporary package.json listing only the SerpApi node.
RUN echo '{ "dependencies": { "n8n-nodes-serpapi": "latest" } }' > package.json

# 4. Install the custom nodes
# The --prefix . command installs them directly into n8n's module path.
RUN npm install --prefix . --no-package-lock

# 5. Clean up the temporary file (Good practice)
RUN rm package.json
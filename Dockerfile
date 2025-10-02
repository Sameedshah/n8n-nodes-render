# 1. Base Image
FROM n8nio/n8n:latest

# --- TEMPORARILY SWITCH TO ROOT USER FOR SYSTEM PACKAGE INSTALLATION ---
# This is necessary to run 'apk update' and 'apk add'
USER root

# 2. Install Build Essentials
RUN apk update && apk add --no-cache build-base python3

# 3. Clean up the build dependencies (optional, but saves image size)
# We remove the build tools immediately after installation
RUN apk del build-base python3

# --- SWITCH BACK TO THE LOW-PRIVILEGE USER USED BY N8N ---
USER node

# 4. Set a USER-WRITABLE Working Directory
# We switch to /home/node, where the 'node' user has write permissions.
WORKDIR /home/node

# 5. Define the custom nodes to install
# We create package.json in the writable /home/node directory.
RUN echo '{ "dependencies": { "n8n-nodes-serpapi": "latest" } }' > package.json

# 6. Install the custom nodes
# CRITICAL: We tell npm to install the nodes GLOBALLY (-g) so n8n can find them.
# Global installs are usually placed in a location like /usr/local/lib/node_modules,
# which n8n's environment knows how to check.
RUN npm install -g --prefix /usr/local --no-package-lock

# 7. Clean up the temporary file
RUN rm package.json 

# The original n8n image will handle the final entrypoint and user setup.

# 1. Base Image
FROM n8nio/n8n:latest

# --- TEMPORARILY SWITCH TO ROOT USER FOR SYSTEM PACKAGE INSTALLATION ---
USER root

# 2. Install Build Essentials
# This installs build tools needed for some npm packages to compile correctly.
RUN apk update && apk add --no-cache build-base python3

# --- SWITCH BACK TO THE LOW-PRIVILEGE USER USED BY N8N ---
USER node

# 3. Set Working Directory (Ensure we're in the right spot for npm)
WORKDIR /usr/local/lib/node_modules/n8n

# 4. Define the custom nodes to install
RUN echo '{ "dependencies": { "n8n-nodes-serpapi": "latest" } }' > package.json

# 5. Install the custom nodes
RUN npm install --prefix . --no-package-lock

# 6. Clean up the temporary file (Good practice)
# We don't need to remove build-base packages here, as the base image already has a good cleanup method
RUN rm package.json 

# The original n8n image will handle the final entrypoint and user setup.

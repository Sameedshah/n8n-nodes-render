# 1. Base Image
FROM n8nio/n8n:latest

# --- SWITCH TO ROOT USER FOR SYSTEM AND PACKAGE INSTALLATION ---
USER root

# 2. Install Build Essentials (Required by many npm packages)
RUN apk update && apk add --no-cache build-base python3

# 3. Clean up the build dependencies (Good practice to keep the image small)
RUN apk del build-base python3

# 4. Set the n8n Application Directory as the Working Directory
# This is where n8n expects custom nodes to be installed locally.
WORKDIR /usr/local/lib/node_modules/n8n

# 5. Define the custom nodes to install
# We create package.json in the n8n directory (which we can do as root).
RUN echo '{ "dependencies": { "n8n-nodes-serpapi": "latest" } }' > package.json

# 6. Install the custom nodes
# We run npm install without the -g flag, installing the node LOCALLY
# to the n8n application folder, which is the most stable method.
RUN npm install --no-package-lock

# 7. Clean up the temporary file
RUN rm package.json 

# 8. Restore the Correct Permissions
# Ensure the node_modules folder has the correct ownership for the 'node' user
RUN chown -R node:node node_modules

# 9. Switch back to the low-privilege 'node' user for security
USER node

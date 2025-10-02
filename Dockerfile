# 1. Base Image
FROM n8nio/n8n:latest

# --- SWITCH TO ROOT USER FOR SYSTEM AND FILE CREATION ---
USER root

# 2. Install Build Essentials
# Ensures all necessary compilation tools are present
RUN apk update && apk add --no-cache build-base python3

# 3. Clean up the build dependencies
RUN apk del build-base python3

# 4. Set the Custom Nodes Directory
WORKDIR /usr/local/lib/node_modules/n8n/custom

# 5. Define the custom nodes to install
RUN echo '{ "dependencies": { "n8n-nodes-serpapi": "latest" } }' > package.json

# 6. Install the custom node
RUN npm install --no-package-lock

# 7. Clean up the temporary file
RUN rm package.json 

# 8. <--- CRITICAL FIX: SET OWNERSHIP AND PERMISSIONS --->
# Ensures the 'node' user (UID 1000) has full read/write access to the installed node files.
RUN chown -R 1000:1000 /usr/local/lib/node_modules/n8n/custom

# 9. Switch back to the low-privilege 'node' user for security
USER node

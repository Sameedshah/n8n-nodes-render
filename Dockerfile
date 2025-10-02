# 1. Base Image
FROM n8nio/n8n:latest

# --- SWITCH TO ROOT USER FOR SYSTEM AND FILE CREATION ---
USER root

# 2. Install Build Essentials
RUN apk update && apk add --no-cache build-base python3

# 3. Clean up the build dependencies
RUN apk del build-base python3

# 4. Set the Custom Nodes Directory
# Create the /custom directory where n8n looks for custom nodes
WORKDIR /usr/local/lib/node_modules/n8n/custom

# 5. Define the custom nodes to install in the 'custom' folder
# This package.json only contains the external node.
RUN echo '{ "dependencies": { "n8n-nodes-serpapi": "latest" } }' > package.json

# 6. Install the custom node
# Run npm install inside the isolated 'custom' folder.
# This prevents the old npm version from touching n8n's core workspace dependencies.
RUN npm install --no-package-lock

# 7. Clean up the temporary file
RUN rm package.json 

# 8. Set Ownership and Permissions
# Ensure the 'custom' folder and its contents are owned by the 'node' user
RUN chown -R node:node /usr/local/lib/node_modules/n8n/custom

# 9. Switch back to the low-privilege 'node' user for security
USER node

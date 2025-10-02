# 1. Base Image
FROM n8nio/n8n:latest

# 2. Install Build Essentials
# This command updates the package list and installs general build tools (like gcc, g++)
# which often resolve "exit status 1" during npm install.
RUN apk update && apk add --no-cache build-base python3

# 3. Set Working Directory
WORKDIR /usr/local/lib/node_modules/n8n

# 4. Define the custom nodes to install
RUN echo '{ "dependencies": { "n8n-nodes-serpapi": "latest" } }' > package.json

# 5. Install the custom nodes
# We use --no-package-lock for simpler builds
RUN npm install --prefix . --no-package-lock

# 6. Clean up the temporary file and build packages (optional, but saves space)
RUN rm package.json \
    && apk del build-base python3

# The rest of the original image settings remain in place.

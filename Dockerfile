# Fixed Dockerfile for Render / Railway / any Docker host
# Node image + Bun installed with npm (works everywhere; avoids "bun: not found" / exit code 127)
FROM node:20-bookworm-slim
WORKDIR /app

# Chromium is used by the Cloudflare bypass (src/services/cfBypass.js looks for /usr/bin/chromium)
RUN apt-get update \
 && apt-get install -y --no-install-recommends chromium ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Install Bun, and show its version so the build log proves it worked
RUN npm install -g bun && bun --version

# Install packages
COPY package.json ./
RUN bun install --production

# Copy the whole project (index.js AND the src folder)
COPY . .

ENV NODE_ENV=production
EXPOSE 3000
# Render gives the port in the PORT variable; index.js reads it
CMD ["bun", "index.js"]

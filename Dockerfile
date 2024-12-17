# Step 1: Use a lightweight Node.js image as the base
FROM node:23-alpine3.20 AS builder
# Set the working directory
WORKDIR /app
# Enable corepack and prepare pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate
# Copy package.json and pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./
# Install dependencies
RUN pnpm install --frozen-lockfile --prod
# Copy the app source code
COPY src ./src

# Use a lightweight runtime image
FROM node:23-alpine3.20 

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 4000

CMD ["node", "src/server.js"]
# ============================================
# Stage 1: Builder — install dependencies
# ============================================
FROM node:18-alpine AS builder

# Set working directory inside container
WORKDIR /app

# Copy package.json FIRST (Docker layer caching trick!)
# If package.json doesn't change, npm install is cached!
COPY backend/package*.json ./

# Install ONLY production dependencies (no dev tools)
RUN npm install --production

# ============================================
# Stage 2: Runner — final lightweight image
# ============================================
FROM node:18-alpine AS runner

# Set working directory
WORKDIR /app

# Set environment to production
ENV NODE_ENV=production
ENV PORT=3000

# Copy installed node_modules from builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy all project files
COPY . .

# Create non-root user for security (best practice!)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose the port
EXPOSE 3000

# Health Check — Docker will auto-check every 30 seconds
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

# Start the app
CMD ["node", "backend/server.js"]

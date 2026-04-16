# Build stage: React frontend
FROM node:22-alpine AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm ci

COPY frontend/ .
RUN npm run build

# Runtime stage
FROM node:22-alpine AS runner

RUN apk add --no-cache nginx

WORKDIR /app

# Install backend production dependencies
COPY backend/package*.json ./backend/
RUN cd backend && npm ci --omit=dev

# Copy backend source
COPY backend/ ./backend/

# Copy built frontend to nginx web root
COPY --from=frontend-builder /app/frontend/build /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 3000

# Start Node backend on 3001, then nginx in the foreground on 3000
CMD ["/bin/sh", "-c", "node backend/src/index.js & exec nginx -g 'daemon off;'"]

# Development stage
FROM golang:1.25-alpine AS development
RUN apk add --no-cache git ca-certificates bash gcc musl-dev
WORKDIR /app

# Create tmp directory for air
RUN mkdir -p /app/tmp

COPY go.mod go.sum ./
RUN go mod download

# Install air for hot reload in development
RUN go install github.com/air-verse/air@latest

# Configure git to treat /app as safe directory
RUN git config --global --add safe.directory /app

EXPOSE 8080
CMD ["air", "-c", ".air.toml"]

# Builder stage for production
FROM golang:1.25-alpine AS builder
RUN apk add --no-cache git ca-certificates bash
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -v -o /app/main -ldflags="-w -s"
RUN ls -la /app/main

# Production stage
FROM alpine:latest AS production
RUN apk --no-cache add ca-certificates bash tzdata
RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser
WORKDIR /app
COPY --from=builder /app/main /app/main
RUN ls -la /app/
RUN chmod +x /app/main
RUN chown -R appuser:appuser /app
USER appuser
EXPOSE 8080
CMD ["/app/main"]
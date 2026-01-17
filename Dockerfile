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
FROM golang:1.25-alpine AS prod
RUN apk add --no-cache git ca-certificates bash gcc musl-dev
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

EXPOSE 8080
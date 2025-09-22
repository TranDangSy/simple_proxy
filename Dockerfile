# Build stage
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-X 'main.Version=v1.0.0' -w -s" -a -installsuffix cgo -o simple-proxy main.go

# Final stage
FROM alpine:latest

# Install ca-certificates for HTTPS requests
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the binary from builder stage
COPY --from=builder /app/simple-proxy .

# Copy license
COPY LICENSE .

# Expose default port
EXPOSE 8888

# Run the binary
ENTRYPOINT ["./simple-proxy"]
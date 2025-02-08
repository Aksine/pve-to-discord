# Build stage
FROM golang:alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o pvetodiscord

# Final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates && \
    mkdir /app && \
    mkdir /app/logs
WORKDIR /app
COPY --from=builder /app/pvetodiscord .
EXPOSE 80

CMD ["./pvetodiscord"]
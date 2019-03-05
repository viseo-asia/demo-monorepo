# Build
FROM golang:1.11 as builder

COPY src /opt/app/src

WORKDIR /opt/app

RUN go get -u github.com/gin-gonic/gin && \
    go build -ldflags "-linkmode external -extldflags -static" src/app.go


# Production
FROM alpine

COPY --from=builder /opt/app/app /app

ENTRYPOINT ["/app"]
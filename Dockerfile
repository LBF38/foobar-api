FROM golang:1-alpine AS builder

RUN apk --no-cache --no-progress add git make \
    && rm -rf /var/cache/apk/*

WORKDIR /go/whoami

# Download go modules
COPY go.mod .
COPY go.sum .
RUN GO111MODULE=on GOPROXY=https://proxy.golang.org go mod download

COPY . .

RUN make build

FROM scratch

COPY --from=builder /go/whoami/whoami .

ENTRYPOINT [ "/whoami" ]
EXPOSE 80

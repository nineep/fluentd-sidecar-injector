FROM golang:1.20 as builder

ENV CGO_ENABLED="0" \
    GOOS="linux" \
    GOARCH="amd64" \
    GOPROXY=https://goproxy.cn

WORKDIR /go/src/github.com/h3poteto/fluentd-sidecar-injector

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN set -ex && \
    make build

FROM gcr.lank8s.cn/distroless/static:nonroot
WORKDIR /
COPY --from=builder /go/src/github.com/h3poteto/fluentd-sidecar-injector/fluentd-sidecar-injector .
USER nonroot:nonroot

CMD ["/fluentd-sidecar-injector"]

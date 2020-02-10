FROM golang:1.13-alpine AS build

ENV CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64 \
  GO111MODULE=on \
  VERSION=v2.7.5

RUN apk add -U make git

WORKDIR /go/src/github.com/segmentio/chamber

RUN git clone --branch $VERSION https://www.github.com/segmentio/chamber.git . \
  && go build -mod=vendor -ldflags='-X "main.Version=$(VERSION)"' -o /bin/chamber

FROM alpine:3.10

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

COPY --from=build /bin/chamber /chamber

ENTRYPOINT ["/chamber"]

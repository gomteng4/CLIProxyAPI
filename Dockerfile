FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

ARG VERSION=dev
ARG COMMIT=none
ARG BUILD_DATE=unknown

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w -X 'main.Version=${VERSION}' -X 'main.Commit=${COMMIT}' -X 'main.BuildDate=${BUILD_DATE}'" -o ./CLIProxyAPI ./cmd/server/

FROM alpine:3.22.0

RUN apk add --no-cache tzdata

RUN mkdir /CLIProxyAPI

COPY --from=builder ./app/CLIProxyAPI /CLIProxyAPI/CLIProxyAPI

COPY config.example.yaml /CLIProxyAPI/config.example.yaml
RUN echo aG9zdDogIiIKcG9ydDogODMxNwoKcmVtb3RlLW1hbmFnZW1lbnQ6CiAgYWxsb3ctcmVtb3RlOiB0cnVlCiAgc2VjcmV0LWtleTogIiIKICBkaXNhYmxlLWNvbnRyb2wtcGFuZWw6IGZhbHNlCgphdXRoLWRpcjogIi9DTElQcm94eUFQSS8uY2xpLXByb3h5LWFwaSIKCmFwaS1rZXlzOgogIC0gImNsaXByb3h5LXNlY3JldC1waXBlbGluZS0yMDI2IgoKZGVidWc6IGZhbHNlCmxvZ2dpbmctdG8tZmlsZTogZmFsc2UK | base64 -d > /CLIProxyAPI/config.yaml

WORKDIR /CLIProxyAPI

EXPOSE 8317

ENV TZ=Asia/Shanghai

RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime && echo "${TZ}" > /etc/timezone

CMD ["./CLIProxyAPI"]

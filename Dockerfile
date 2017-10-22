FROM celrenheit/golang-rocksdb:1.9.1 AS build
LABEL Salim Alami <celrenheit+github@gmail.com>

EXPOSE 8080

WORKDIR $GOPATH/src/github.com/celrenheit/sandglass

COPY . ./

RUN cp -r demo /demo

RUN go build -a -tags netgo --ldflags '-extldflags "-static"' -o /usr/bin/sandglass ./cmd/sandglass/main.go && \
    chmod a+x /usr/bin/sandglass

FROM alpine:3.6

LABEL Salim Alami <celrenheit+github@gmail.com>

WORKDIR /demo
COPY --from=build /demo .
COPY --from=build /usr/bin/sandglass /usr/bin/sandglass

ENTRYPOINT ["/usr/bin/sandglass"]

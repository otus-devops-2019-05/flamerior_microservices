FROM golang:1.11.5 as builder

COPY trickster /go/src/github.com/Comcast/trickster
WORKDIR /go/src/github.com/Comcast/trickster

RUN GOOS=linux CGO_ENABLED=0 make build


FROM alpine:3.9

COPY --from=builder /go/src/github.com/Comcast/trickster/trickster /usr/local/bin/trickster
COPY trickster.conf /etc/trickster/trickster.conf
RUN chown nobody /usr/local/bin/trickster
RUN chmod +x /usr/local/bin/trickster

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

EXPOSE 9089 8082
USER nobody
ENTRYPOINT ["trickster"]

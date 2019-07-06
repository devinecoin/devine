# Build Geth in a stock Go builder container
FROM golang:1.12-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /devine
RUN cd /devine && make devine

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /devine/build/bin/geth /usr/local/bin/

EXPOSE 9988 9989 30303 30303/udp
ENTRYPOINT ["geth"]

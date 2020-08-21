# builder
FROM golang:1.15 as builder

ENV BURROW_VERSION 1.3.4

RUN wget "https://github.com/linkedin/Burrow/archive/v${BURROW_VERSION}.tar.gz" \
    && tar -xzf v${BURROW_VERSION}.tar.gz \
    && cd ./Burrow-${BURROW_VERSION}/ \
    && go mod tidy \
    && go build -o /tmp/burrow .


# runner
FROM centos:7

LABEL maintainer="kazono"

COPY --from=builder /tmp/burrow /opt
COPY config/* /etc/burrow/

WORKDIR /opt

COPY ./entrypoint.sh ./entrypoint.sh
RUN mkdir -p /var/log/Burrow/ && chmod +x ./entrypoint.sh

EXPOSE 8000
ENTRYPOINT ["./entrypoint.sh"]

# Dockerfile for cpuminer
# usage: docker run creack/cpuminer --url xxxx --user xxxx --pass xxxx
# example: docker run creack/cpuminer --url stratum+tcp://ltc.pool.com:80 --user creack.worker1 --pass abcdef

FROM debian:stretch AS base
LABEL maintainer="ecliptik@gmail.com"

WORKDIR /cpuminer
ENTRYPOINT ["./minerd"]

RUN apt update && \
    apt install -y libcurl4-openssl-dev

FROM base AS build

RUN apt update && \
    apt install -y automake git make build-essential

RUN git clone https://github.com/pooler/cpuminer

WORKDIR /cpuminer/cpuminer

RUN ./autogen.sh
RUN ./configure CFLAGS="-O3"
RUN make -j

FROM base AS run

COPY --from=build /cpuminer/cpuminer/minerd /cpuminer/

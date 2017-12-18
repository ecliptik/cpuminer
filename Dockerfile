# Dockerfile for cpuminer
# usage: docker run creack/cpuminer --url xxxx --user xxxx --pass xxxx
# example: docker run creack/cpuminer --url stratum+tcp://ltc.pool.com:80 --user creack.worker1 --pass abcdef

FROM debian:stretch AS base
LABEL maintainer="ecliptik@gmail.com"

WORKDIR /cpuminer
ENTRYPOINT ["./minerd"]

#Install required packages for build and run
RUN apt update && \
    apt install -y libcurl4-openssl-dev

#Build image
FROM base AS build

#Install required packages for build
RUN apt update && \
    apt install -y automake make build-essential

#Copy source code
COPY . /cpuminer/

#Compile binary
RUN ./autogen.sh && \
    ./configure CFLAGS="-O3"
RUN make -j

#Run image
FROM base AS run

#Copy compiled binary to WORKDIR for runtime
COPY --from=build /cpuminer/minerd /cpuminer/

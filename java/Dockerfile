FROM debian:bookworm-slim

MAINTAINER Ampflower

RUN apt-get -y update && apt-get install -y @OPENJDK@ libjemalloc2 curl openssl git tar sqlite3 tzdata iproute2 libstdc++6\
    && apt-get -y clean && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /usr/lib/jvm/java*/docs /usr/lib/jvm/java*/man &&\
    useradd -md /home/container container

USER container
ENV USER=container HOME=/home/container LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]

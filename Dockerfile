FROM debian:stretch-slim

RUN apt update && \
    mkdir -p /usr/share/man/man1 && \
    apt install -y --no-install-recommends make git openjdk-8-jdk-headless ant ant-contrib libjline2-java libjarjar-java libnative-platform-java && \
    update-java-alternatives --set java-1.8.0-openjdk-amd64 && \
    rm /etc/java-8-openjdk/accessibility.properties && \
    rm -rf /var/lib/apt/lists/*;

WORKDIR /kotlin

CMD /usr/bin/make

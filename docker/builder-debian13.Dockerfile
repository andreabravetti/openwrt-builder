# https://hub.docker.com/_/debian
FROM amd64/debian:trixie-slim

# OpenWrt Debian prerequisite
RUN apt update
RUN apt dist-upgrade -y
RUN apt install -y build-essential clang flex \
        bison g++ gawk gcc-multilib g++-multilib \
        gettext git libncurses5-dev libssl-dev \
        python3-setuptools rsync swig unzip \
        zlib1g-dev file wget sudo
RUN apt clean

COPY scripts/runas /etc/sudoers.d/runas
COPY scripts/build.sh /build.sh
COPY scripts/run.sh /run.sh

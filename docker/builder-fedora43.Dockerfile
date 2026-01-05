# https://hub.docker.com/_/fedora
FROM amd64/fedora:43

# OpenWrt Debian prerequisite
RUN dnf --setopt=install_weak_deps=False install -y --skip-broken \
        bash-completion bzip2 file gcc gcc-c++ git-core make \
        ncurses-devel patch rsync tar unzip wget which diffutils \
        python3 python3-setuptools perl-base perl-Data-Dumper \
        perl-File-Compare perl-File-Copy perl-FindBin perl-IPC-Cmd \
        perl-JSON-PP perl-lib perl-Thread-Queue perl-Time-Piece
RUN dnf clean all

RUN mkdir -p /root/scripts

COPY scripts/build.sh /root/scripts/build.sh

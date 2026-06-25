FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive
ENV container=docker

RUN apt-get update && apt-get install -y \
    systemd \
    systemd-sysv \
    dbus \
    procps \
    tcpdump \
    redis-tools \
    && rm -rf /var/lib/apt/lists/*

# Remove systemd units that don't make sense in a container
RUN find /lib/systemd/system/sysinit.target.wants/ -mindepth 1 ! -name 'systemd-tmpfiles-setup.service' -delete \
    && rm -f \
    /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/*

STOPSIGNAL SIGRTMIN+3

COPY install.sh /install.sh
COPY post_install.sh /post_install.sh
# COPY etcd.service /lib/systemd/system/etcd.service
COPY apisix.service /lib/systemd/system/apisix.service
RUN chmod +x /install.sh && /install.sh || exit 1
RUN chmod o+w /usr/local/apisix/logs
RUN chmod +x /post_install.sh
VOLUME ["/sys/fs/cgroup"]

CMD ["/lib/systemd/systemd"]

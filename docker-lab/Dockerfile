FROM ubuntu:xenial
ENV DEBIAN_FRONTEND=noninteractive DISPLAY=:1 HOME=/home/student
RUN apt-get update && apt-get install -y --no-install-recommends \
    ns2 nam xgraph gawk tcl tk xvfb x11vnc novnc websockify \
    fluxbox xterm xfonts-base x11-utils supervisor ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash student
# Built locally from Ubuntu's NAM 1.15 source with the Debian #820101 fix.
# See Dockerfile.nam for a reproducible source rebuild.
COPY bin/nam /usr/local/bin/nam
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfonts-75dpi xfonts-100dpi feh && rm -rf /var/lib/apt/lists/*
COPY supervisord.conf /etc/supervisor/conf.d/lab.conf
WORKDIR /work
EXPOSE 6080
CMD ["/usr/bin/supervisord", "-n"]

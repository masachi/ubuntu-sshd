FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y openssh-server

# jitsi
RUN apt update \
 && apt install -y \
    git \
    curl \
    gnupg \
    gcc \
    g++ \
    make \
 && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
 && apt install -y nodejs \
 && rm -rf /var/lib/apt/lists/* \
 && cd /data/ \
 && git clone https://github.com/jitsi/jitsi-meet.git

RUN mkdir /var/run/sshd

RUN echo 'root:96035204' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22 8080 4443 443 80 10000

CMD    ["/usr/sbin/sshd", "-D"]

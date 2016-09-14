FROM ubuntu:xenial
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
RUN apt update -q -y \
    && apt install -q -y libappindicator1 \
                         wget \
                         gconf-service \
                         libasound2 \
                         libgconf-2-4 \
                         libnspr4 \
                         libnss3 \
                         libpango1.0-0 \
                         libxss1 \
                         fonts-liberation \
                         libcurl3 \
                         xdg-utils \
                         mate-core \
                         mate-desktop-environment \
                         mate-notification-daemon \
                         firefox \
                         xrdp \
                         supervisor \
    && apt autoclean \
    && apt autoremove \
    && rm -rf /var/lib/apt/lists/* 

RUN sed -i.bak '/fi/a #xrdp multiple users configuration \n mate-session \n' /etc/xrdp/startwm.sh

RUN useradd -ms /bin/bash desktop && \
    sed -i '/TerminalServerUsers/d' /etc/xrdp/sesman.ini && \
    sed -i '/TerminalServerAdmins/d' /etc/xrdp/sesman.ini && \
    xrdp-keygen xrdp auto && \
    echo "desktop:desktop" | chpasswd

ADD xrdp.conf /etc/supervisor/conf.d/xrdp.conf

EXPOSE 3389
CMD ["/usr/bin/supervisord", "-n"]


FROM debian:stretch-slim

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="CrazyMax" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="csgo-server-launcher" \
  org.label-schema.description="CSGO Server Launcher" \
  org.label-schema.version=$VERSION \
  org.label-schema.url="https://github.com/crazy-max/csgo-server-launcher" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/crazy-max/csgo-server-launcher" \
  org.label-schema.vendor="CrazyMax" \
  org.label-schema.schema-version="1.0"

RUN dpkg --add-architecture i386 \
  && apt-get update \
  && apt-get install -y \
    bash \
    binutils \
    curl \
    dnsutils \
    gdb \
    libc6-i386 \
    lib32stdc++6 \
    lib32gcc1 \
    lib32ncurses5 \
    lib32z1 \
    locales \
    net-tools \
    ssmtp \
    sudo \
    tar \
    wget \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8 \
  && cp -f /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf.or \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && find /var/log -type f | while read f; do echo -ne '' > $f; done;

ENV LANG="en_US.UTF-8" \
  CSGO_DOCKER="1" \
  DIR_STEAMCMD="/var/steamcmd" \
  DIR_ROOT="/var/steamcmd/games/csgo"

RUN groupadd -f -g 1000 steam \
  && useradd -o --shell /bin/bash -u 1000 -g 1000 -m steam \
  && echo "steam ALL=(ALL)NOPASSWD: ALL" >> etc/sudoers \
  && mkdir -p ${DIR_STEAMCMD} ${DIR_ROOT} \
  && curl -sSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -C ${DIR_STEAMCMD} -xvz \
  && chown -R steam. ${DIR_STEAMCMD}

COPY csgo-server-launcher.sh /usr/bin/csgo-server-launcher
COPY csgo-server-launcher.conf /etc/csgo-server-launcher/csgo-server-launcher.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh /usr/bin/csgo-server-launcher \
  && chown -R steam. /etc/csgo-server-launcher

USER steam

EXPOSE 27015 27015/udp
WORKDIR ${DIR_ROOT}
VOLUME [ "${DIR_ROOT}", "/home/steam/Steam" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "csgo-server-launcher", "start" ]

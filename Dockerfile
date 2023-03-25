# Docker image for ubuntu using the scratch template
ARG LICENSE="MIT"
ARG IMAGE_NAME="ubuntu"
ARG LANGUAGE="en_US.UTF-8"
ARG TIMEZONE="America/New_York"

ARG IMAGE_REPO="ubuntu"
ARG IMAGE_VERSION="kinetic"
ARG CONTAINER_VERSION="latest 22.10 kinetic"

ARG USER="root"
ARG DISTRO_VERSION="${IMAGE_VERSION}"
ARG BUILD_VERSION="${DISTRO_VERSION}"

FROM ${IMAGE_REPO}:${IMAGE_VERSION} AS build
ARG USER
ARG LICENSE
ARG LANGUAGE
ARG TIMEZONE
ARG IMAGE_NAME

ARG PACK_LIST="bash bash-completion git curl wget sudo unzip"

ENV ENV=~/.bashrc
ENV SHELL="/bin/sh"
ENV TZ="${TIMEZONE}"
ENV TIMEZONE="${TZ}"
ENV LANG="${LANGUAGE}"
ENV TERM="xterm-256color"
ENV HOSTNAME="ubuntu"
ENV container="docker"
ENV DEBIAN_FRONTEND="noninteractive"

USER ${USER}
WORKDIR /root

COPY ./rootfs/. /
COPY ./Dockerfile /root/Dockerfile

RUN set -ex ; \
  echo ""

RUN set -ex ; \
  echo "$LANG UTF-8" >"/etc/locale.gen" && apt-get update && apt-get install -yy locales ; \
  dpkg-reconfigure --frontend=noninteractive locales ; update-locale LANG=${LANG} ; \
  echo 'export DEBIAN_FRONTEND="'${DEBIAN_FRONTEND}'"' >"/etc/profile.d/apt.sh" && chmod 755 "/etc/profile.d/apt.sh" ; \
  apt update -yy && apt install -yy ${PACK_LIST}

RUN set -ex ; \
  touch "/etc/profile" "/root/.profile" ; \
  { [ -f "/etc/bash/bashrc" ] && cp -Rf "/etc/bash/bashrc" "/root/.bashrc" ; } || { [ -f "/etc/bashrc" ] && cp -Rf "/etc/bashrc" "/root/.bashrc" ; } || { [ -f "/etc/bash.bashrc" ] && cp -Rf "/etc/bash.bashrc" "/root/.bashrc" ; }; \
  grep -s -q 'alias quit' "/root/.bashrc" || printf '# Profile\n\n%s\n%s\n%s\n%s\n' '. /etc/profile' '. /root/.profile' "alias q='exit'" "alias quit='exit'" >>"/root/.bashrc" ; \
  sed -i 's|root:x:.*|root:x:0:0:root:/root:/bin/bash|g' "/etc/passwd" ; \
  update-alternatives --install /bin/sh sh /bin/bash 1

RUN set -ex ; \
  echo

RUN set -ex ; \
  echo 'Running cleanup' ; \
  echo ""

RUN rm -Rf "/config" "/data" ; \
  rm -rf /etc/systemd/system/*.wants/* ; \
  rm -rf /lib/systemd/system/systemd-update-utmp* ; \
  rm -rf /lib/systemd/system/anaconda.target.wants/*; \
  rm -rf /lib/systemd/system/local-fs.target.wants/* ; \
  rm -rf /lib/systemd/system/multi-user.target.wants/* ; \
  rm -rf /lib/systemd/system/sockets.target.wants/*udev* ; \
  rm -rf /lib/systemd/system/sockets.target.wants/*initctl* ; \
  rm -Rf /usr/share/doc/* /usr/share/info/* /tmp/* /var/tmp/* /var/cache/*/* ; \
  if [ -d "/lib/systemd/system/sysinit.target.wants" ]; then cd "/lib/systemd/system/sysinit.target.wants" && rm -f $(ls | grep -v systemd-tmpfiles-setup) ; fi

RUN echo "Init done"

FROM scratch
ARG USER
ARG LICENSE
ARG LANGUAGE
ARG TIMEZONE
ARG IMAGE_NAME

USER ${USER}
WORKDIR /root

LABEL maintainer="CasjaysDev <docker-admin@casjaysdev.com>"
LABEL org.opencontainers.image.vendor="CasjaysDev"
LABEL org.opencontainers.image.authors="CasjaysDev"
LABEL org.opencontainers.image.vcs-type="Git"
LABEL org.opencontainers.image.name="${IMAGE_NAME}"
LABEL org.opencontainers.image.base.name="${IMAGE_NAME}"
LABEL org.opencontainers.image.license="${LICENSE}"
LABEL org.opencontainers.image.vcs-ref="${BUILD_VERSION}"
LABEL org.opencontainers.image.build-date="${BUILD_DATE}"
LABEL org.opencontainers.image.version="${BUILD_VERSION}"
LABEL org.opencontainers.image.schema-version="${BUILD_VERSION}"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/casjaysdevdocker/${IMAGE_NAME}"
LABEL org.opencontainers.image.vcs-url="https://github.com/casjaysdevdocker/${IMAGE_NAME}"
LABEL org.opencontainers.image.url.source="https://github.com/casjaysdevdocker/${IMAGE_NAME}"
LABEL org.opencontainers.image.documentation="https://hub.docker.com/r/casjaysdevdocker/${IMAGE_NAME}"
LABEL org.opencontainers.image.description="Containerized version of ${IMAGE_NAME}"
LABEL com.github.containers.toolbox="false"

ENV ENV=~/.bashrc
ENV SHELL="/bin/bash"
ENV TZ="${TIMEZONE}"
ENV TIMEZONE="${TZ}"
ENV container="docker"
ENV LANG="${LANGUAGE}"
ENV TERM="xterm-256color"
ENV CONTAINER_NAME="${IMAGE_NAME}"
ENV HOSTNAME="${IMAGE_NAME}"
ENV USER="${USER}"

COPY --from=build /. /

VOLUME [ "/config","/data" ]

EXPOSE ${ENV_PORTS}

CMD [ "bin/bash" ]
HEALTHCHECK --start-period=1m --interval=2m --timeout=3s CMD [ "true" ]

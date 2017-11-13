FROM openjdk:8u121-alpine

MAINTAINER stpork from Mordor team

ENV RUN_USER=daemon \
RUN_GROUP=daemon \
BITBUCKET_HOME=/var/atlassian/application-data/bitbucket \
BITBUCKET_INSTALL=/opt/atlassian/bitbucket

RUN apk update -qq \
&& update-ca-certificates \
&& apk add ca-certificates wget curl git openssh bash procps openssl perl ttf-dejavu tini \
&& rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/* \
&& VER=5.5.0 \
&& URL=https://downloads.atlassian.com/software/stash/downloads/atlassian-bitbucket-${VER}.tar.gz \
&& mkdir -p ${BITBUCKET_INSTALL} \
&& curl -fsSL ${URL} | tar -xz --strip-components=1 -C "$BITBUCKET_INSTALL" \
&& chown -R ${RUN_USER}:${RUN_GROUP} ${BITBUCKET_INSTALL}/

COPY entrypoint.sh /entrypoint.sh

EXPOSE 7990
EXPOSE 7999

VOLUME ["${BITBUCKET_HOME}"]
VOLUME ["${BITBUCKET_HOME}/shared"]

WORKDIR $BITBUCKET_HOME

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/sbin/tini", "--"]

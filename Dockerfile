FROM openjdk:8-jdk-alpine

MAINTAINER stpork from Mordor team

ENV BITBUCKET_VERSION=5.7.1 \
BITBUCKET_HOME=/var/atlassian/application-data/bitbucket \
BITBUCKET_INSTALL=/opt/atlassian/bitbucket \
RUN_USER=daemon \
RUN_GROUP=daemon 

ENV HOME=$BITBUCKET_HOME

RUN set -x \
&& apk update -qq \
&& update-ca-certificates \
&& apk add --no-cache ca-certificates curl git git-daemon openssh bash procps openssl perl ttf-dejavu tini nano \
&& rm -rf /var/cache/apk/* /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/* \
&& mkdir -p ${BITBUCKET_INSTALL} \
&& curl -fsSL \
"https://downloads.atlassian.com/software/stash/downloads/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz" \
| tar -xz --strip-components=1 -C "$BITBUCKET_INSTALL" \
&& chown -R ${RUN_USER}:${RUN_GROUP} ${BITBUCKET_INSTALL}/

COPY entrypoint.sh /entrypoint.sh

EXPOSE 7990
EXPOSE 7999

VOLUME ["${BITBUCKET_HOME}"]
VOLUME ["${BITBUCKET_HOME}/shared"]

WORKDIR $BITBUCKET_HOME

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/sbin/tini", "--"]

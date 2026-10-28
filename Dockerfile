# Dated, reviewed maintenance derivative. Refresh pins and revalidate for each rebuild.
FROM lscr.io/linuxserver/swag@sha256:705de71e24e98f3a2907664d6ae37a83d85001748abedf0d10904b928f191029
LABEL org.opencontainers.image.title="RTHO hardened SWAG" \
      org.opencontainers.image.version="5.8.0-ls495-20261028-r1" \
      org.opencontainers.image.base.name="lscr.io/linuxserver/swag@sha256:705de71e24e98f3a2907664d6ae37a83d85001748abedf0d10904b928f191029" \
      rtho.security.revision="20261028-r1"
COPY alpine-packages.lock /usr/local/share/rtho-swag/alpine-packages.lock
COPY module-policy.sh /usr/local/lib/rtho-swag/module-policy.sh
RUN sed -i 's|http://|https://|g' /etc/apk/repositories \
 && xargs apk add --no-cache --upgrade < /usr/local/share/rtho-swag/alpine-packages.lock \
 && chmod 0555 /usr/local/lib/rtho-swag/module-policy.sh \
 && /usr/local/lib/rtho-swag/module-policy.sh \
 && apk info -vv | grep -q '^nginx-1.30.6-r0 - ' \
 && apk info -vv | grep -q '^nginx-mod-http-naxsi-1.30.6-r0 - '

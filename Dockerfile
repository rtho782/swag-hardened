# Dated, reviewed maintenance derivative. Refresh pins and revalidate for each rebuild.
FROM lscr.io/linuxserver/swag@sha256:c9128fa608b31698327375406402d426258ff7bcd57871f119341e20761eb828
LABEL org.opencontainers.image.title="RTHO hardened SWAG" \
      org.opencontainers.image.source="https://github.com/rtho782/swag-hardened" \
      org.opencontainers.image.version="5.9.0-ls496-20261030-r1" \
      org.opencontainers.image.base.name="lscr.io/linuxserver/swag@sha256:c9128fa608b31698327375406402d426258ff7bcd57871f119341e20761eb828" \
      rtho.security.revision="20261030-r1"
COPY alpine-packages.lock /usr/local/share/rtho-swag/alpine-packages.lock
COPY module-policy.sh /usr/local/lib/rtho-swag/module-policy.sh
RUN sed -i 's|http://|https://|g' /etc/apk/repositories \
 && xargs apk add --no-cache --upgrade < /usr/local/share/rtho-swag/alpine-packages.lock \
 && chmod 0555 /usr/local/lib/rtho-swag/module-policy.sh \
 && /usr/local/lib/rtho-swag/module-policy.sh \
 && apk info -vv | grep -q '^nginx-1.30.6-r0 - ' \
 && apk info -vv | grep -q '^nginx-mod-http-naxsi-1.30.6-r0 - '

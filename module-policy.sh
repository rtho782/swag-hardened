#!/bin/sh
set -eu
test "$(id -u)" = 0
mkdir -p /etc/nginx/modules-disabled
for f in /etc/nginx/modules/*.conf; do
    test -e "$f" || continue
    case "${f##*/}" in
        10_devel_kit.conf|10_http_naxsi.conf|20_http_set_misc.conf) ;;
        *) mv -f "$f" /etc/nginx/modules-disabled/ ;;
    esac
done
test -f /etc/nginx/modules/10_devel_kit.conf
test -f /etc/nginx/modules/10_http_naxsi.conf
test -f /etc/nginx/modules/20_http_set_misc.conf
grep -q 'ndk_http_module.so' /etc/nginx/modules/10_devel_kit.conf
grep -q 'ngx_http_naxsi_module.so' /etc/nginx/modules/10_http_naxsi.conf
grep -q 'ngx_http_set_misc_module.so' /etc/nginx/modules/20_http_set_misc.conf
test "$(find /etc/nginx/modules -maxdepth 1 -type f -name '*.conf' | wc -l | tr -d ' ')" = 3
echo 'SWAG security: only NAXSI, NDK and set-misc dynamic modules enabled'

# SWAG reduced-module image

A small, reproducible derivative of [LinuxServer.io SWAG](https://github.com/linuxserver/docker-swag): a pinned official base, pinned Alpine security packages, and an explicit three-module NGINX profile.

Image: `ghcr.io/rtho782/swag-hardened:5.9.0-ls496-20261030-r1` (Linux amd64).

## What changes

- Alpine 3.24.3, Python 3.14.10, curl 8.23.0 and Brotli 1.2.1 security packages are pinned in `alpine-packages.lock`.
- The Alpine-signed NAXSI package matches NGINX 1.30.6 exactly.
- Only NAXSI, NDK and set-misc are dynamically loaded. Sixteen unused module loads are disabled; their packages remain installed for upstream compatibility.
- The upstream NGINX binary, SWAG entrypoint and certificate tooling are retained.
- Official SWAG 5.9.0-ls496 supplies Certbot, ACME and the Cloudflare DNS plugin 5.9.0. The derivative retains curl/libcurl 8.23.0, newer than this official base's 8.22.0.

The module profile supports the operator configuration against which it was tested. It intentionally excludes Perl, XSLT, image filters, Brotli, WebDAV, mail, stream, RTMP, Redis and other optional features. Review configuration compatibility before using it with another deployment.

## Scope

This repository contains **no deployment configuration, proxy routes, private addresses, certificates, accounts or credentials**. You must supply and maintain your own `/config` and authentication/WAF rules. Installing NAXSI does not automatically enable request inspection. The image alone does not configure Authentik, disable PHP-FPM, enforce host firewall rules or restrict Docker ports. Those are deployment policies, separate from this image.

It is an independent derivative, with no claim of endorsement or security certification. An unused module being loaded does not establish a remotely exploitable vulnerability; reducing loaded code complements security updates and sound configuration.

## Why NAXSI is included

[NAXSI](https://github.com/wargio/naxsi) means NGINX Anti XSS & SQL Injection. It is a third-party NGINX web application firewall module. With an operator-supplied policy, it examines request content, including supported request bodies, and rejects requests whose scores exceed configured thresholds. Authentication decides who may enter; a WAF can still reject a malicious request from an authenticated client or protect an intentionally public application.

This image packages the matching Alpine-signed module. **It does not supply or enable a universal WAF policy.** Operators must configure inspection, body limits, thresholds and narrow exceptions, then test normal application and API traffic. Multipart/binary/large-body handling needs particular care. A WAF does not guarantee that every exploit is detected or replace application updates.

Official SWAG does not currently package NAXSI. Our inference, **not a confirmed LinuxServer explanation**, is that generic reverse-proxy users run very different applications: useful blocking policies require application-specific tuning, introduce false positives, and add module compatibility and support work. Keeping that optional is understandable. The maintained NAXSI fork documents this tuning requirement; the original repository was archived.

## Build and verify

```sh
docker build --pull=false -t swag-hardened:review .
docker run --rm --network none --entrypoint /bin/sh swag-hardened:review -c \
  '/usr/local/lib/rtho-swag/module-policy.sh && /lsiopy/bin/python -m pip check && certbot --version'
```

The digest and package versions are dated baselines. A later rebuild can fail if the package repository has retired a pinned version; refresh pins deliberately instead of removing the guards. Use a new version tag for changed sources. Test an isolated copy of your configuration, authorization, WAF request bodies, native APIs, shared/mobile paths and recovery access before deploying. Keep the previous image and a consistent configuration backup for rollback.

`module-policy.sh` is applied during build. Operators whose startup hooks install packages should also invoke `/usr/local/lib/rtho-swag/module-policy.sh` after package installation and before NGINX starts, to keep the allowlist enforced.

## Publishing

The publishing workflow builds and checks the image, then pushes a versioned tag and `latest` to GHCR using the repository's ephemeral `GITHUB_TOKEN`. It has no access to a home server, private configuration or deployment credentials. Existing version tags are not overwritten. Publishing does not deploy the image anywhere.

The public workflow publishes reviewed source on a version-tag push or manual dispatch. It is separate from any operator's private updater. An operator may apply approved-line patches automatically with isolated testing, consistent backups, checked rollback and explicit review of new release lines. No private updater configuration or credentials belong in this repository. See [CHANGELOG.md](CHANGELOG.md) for published baselines.

## Maintenance

Routine security updates can be built from the same approved release lines. Alpine release changes, NGINX series/ABI changes and major SWAG changes require compatibility review, including the three-module package filenames. Read upstream release notes and security advisories; do not interpret an image tag or an advisory scan as a guarantee against unknown vulnerabilities.

## License and upstream

The build additions are GPL-3.0-only. Base-image software retains its original licenses and notices. Upstream sources: [SWAG](https://github.com/linuxserver/docker-swag), [Alpine packages/aports](https://gitlab.alpinelinux.org/alpine/aports), [NGINX](https://nginx.org), [NAXSI](https://github.com/wargio/naxsi). The public Dockerfile and package lock identify the corresponding base and packages.

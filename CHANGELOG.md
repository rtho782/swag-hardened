# Reviewed image baselines

## 5.9.0-ls496-20261030-r1

- Rebase to official SWAG 5.9.0-ls496, pinned by manifest digest.
- Certbot, ACME and Cloudflare plugin advance from 5.8.0 to 5.9.0, with upstream Python dependency updates. Certbot fixes renewal-hook certificate-name reporting and account-deactivation confirmation; see its [release notes](https://github.com/certbot/certbot/releases/tag/v5.9.0).
- Retain curl/libcurl 8.23.0, Alpine 3.24.3, Python 3.14.10 and matching NGINX/NAXSI 1.30.6-r0 APK pins. The NGINX binary is unchanged from the preceding baseline.
- Retain the NAXSI/NDK/set-misc module allowlist. Bundled upstream startup scripts and proxy defaults are unchanged between the two official bases.
- Add artifact checks for installed package pins, NGINX/NAXSI ABI, required Certbot components and the module profile. Publishing fails closed when it cannot establish version-tag absence.
- Document NAXSI's role, deployment-policy requirements and the distinction between reviewed public publication and private deployment automation.

## 5.8.0-ls495-20261028-r1

- Initial official-SWAG derivative with pinned Alpine security package updates and matching signed NAXSI module.
- Reduce active dynamic modules to NAXSI, NDK and set-misc, retaining unused packages for vendor compatibility.
- Publish generic source and Linux amd64 image without deployment configuration or credentials.

# Public build repository

- Read README.md. This is a reduced-module derivative, not a turnkey perimeter configuration.
- Keep this tree free of live deployment configuration, hostnames/private addresses, certificates, tokens, passwords, cookies, private keys and Docker inspect/env dumps.
- Pin the official base digest and changed signed Alpine packages. Keep NGINX/NAXSI ABI versions matched and the three-module profile explicit.
- Use a new immutable version tag for changes. Preserve upstream attribution and license notices.
- Test package consistency and isolated deployment behavior before promoting an image. Publishing must never execute on or deploy to private infrastructure.

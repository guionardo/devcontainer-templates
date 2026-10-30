# PHP 5.1.6 template — experimental

This template is derived from `samples/Dockerfile.php516` without changing that reference file. The original source archives are downloaded at build time, so archive availability and integrity must be verified before declaring it production-ready.

## Debugging

Xdebug 2.0.0 uses DBGp on TCP port 9000. The VS Code `xdebug.php-debug` extension is configured as a listener in `.vscode/launch.json`. The extension's compatibility with Xdebug 2.0.0 is **not yet validated**. Because the editor attaches to the container, `host.docker.internal` may not point at the debug adapter; connection routing must be tested and adjusted. The included launch config is a starting point only.

## Validation checklist

- [ ] Build the template with Docker.
- [ ] Confirm `php -v` reports 5.1.6 and Xdebug 2.0.0.
- [ ] Confirm Apache serves a minimal PHP page.
- [ ] Confirm the VS Code debugger stops at a breakpoint.
- [ ] Confirm correct path mapping and document the working network topology.
- [ ] Verify and pin downloaded source archive checksums.

**Warning:** Debian Jessie and PHP 5.1.6 are unsupported. Use only in isolated local development environments with trusted inputs.

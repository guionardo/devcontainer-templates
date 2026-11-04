# ADR-003: a modern editor alongside legacy PHP

- Date: 2026-11-04
- Status: Accepted

## Context

The selected legacy PHP builds use Debian Jessie. Modern VS Code Server binaries require newer system libraries, including glibc 2.28 or later; successfully running PHP does not establish that the editor can run in the same container.

See Microsoft's [Linux requirements](https://code.visualstudio.com/docs/remote/linux).

## Decision

For PHP 5.1.6 and PHP 5.4, connect VS Code to a Debian Bookworm `editor` service and run PHP/Apache in a separate `php` service. Mount the project at `/var/www/html` in both.

Run PHP Debug in the editor container and configure legacy Xdebug to connect to `editor:9000`. Do not explicitly publish the debugger port to the host. Use Compose service discovery and a consistent source path.

PHP 8.5 supports a direct editor/runtime connection, with Xdebug listening in the same container on port 9003.

## Consequences

- The editor can use modern libraries while PHP retains its historical ABI and dependencies.
- The legacy integrated terminal belongs to the editor and has no PHP interpreter. Run PHP through `docker compose exec php` from the host.
- Native PHP validation is disabled in the legacy editor to avoid validating legacy code with another interpreter.
- Both containers need the same workspace mount and the debug listener must accept the runtime connection.
- Application-specific HTTP, database, and extension requirements still need configuration.

## Download compatibility

Historical PHP and Xdebug archives are downloaded in a modern TLS-capable build stage. This avoids obsolete TLS negotiation in Jessie, but does not replace the remaining work to pin checksums and image digests.

## Validation

Manual tests of the published `0.1.0` templates confirmed breakpoints, variables, step-over, and HTTP continuation in all three runtimes. See the [report](../../examples/vscode-debug/RESULTS.md).

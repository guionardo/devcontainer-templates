# PHP 5.1.6

## Validation status

The published 0.1.0 baseline passed build, CLI, Xdebug loading, Apache, HTTP, and manual VS Code breakpoint/step-over tests on November 4, 2026 (Windows x64, Docker Desktop Linux amd64). Release 1.0.0 consolidates the English catalog and release automation; the historical GUI result is attributed to 0.1.0.

## Editor and runtime

VS Code connects to a Bookworm editor service; PHP runs in a separate Jessie linux/amd64 service. Both mount the project at /var/www/html. The editor has no PHP interpreter, and native PHP validation is disabled. Run PHP from the host with docker compose -f .devcontainer/compose.yaml exec php php -v.

## Debugging

Start Listen for Xdebug in Run and Debug. Request devcontainer-smoke.php. Xdebug 2 connects to editor:9000; no debugger port is explicitly published to the host.

## Extensions and limits

The baseline includes mbstring and Xdebug, along with the extensions enabled by the build. No MySQL driver is configured: PDO core does not provide pdo_mysql.

No database, production data, or automatic Composer installation is included. Jessie and PHP 5 are unsupported. Source downloads use a modern TLS-verified stage, but archive checksums and image digests still need to be pinned. Use only for isolated local maintenance.

# PHP 8.5

## Validation status

The published 0.1.0 baseline passed build, CLI, Xdebug loading, Apache, HTTP, and manual VS Code breakpoint/step-over tests on November 4, 2026 (Windows x64, Docker Desktop Linux amd64). Release 1.0.0 consolidates the English catalog and release automation; the historical GUI result is attributed to 0.1.0.

## Editor and runtime

VS Code connects directly to the PHP/Apache container. The integrated terminal uses the runtime interpreter.

## Debugging

Start Listen for Xdebug in Run and Debug. Request devcontainer-smoke.php?XDEBUG_TRIGGER=1. Xdebug 3 connects to 127.0.0.1:9003 inside the same container.

## Extensions and limits

Additional database extensions are not automatically installed.

No database, production data, or automatic Composer installation is included. Base image tags are not immutable digests; pin them if your project requires that guarantee.

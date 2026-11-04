# Minimal example: php-8.5

Runtime configuration was applied from OCI template ghcr.io/guionardo/devcontainer-templates/php-8.5:0.1.0 and manually tested on November 4, 2026. Code identifiers and annotations have since been translated; see the report for the historical identifier mapping.

Open this folder in VS Code and run **Dev Containers: Reopen in Container**. Set a breakpoint on index.php:7 with F9 and start **Listen for Xdebug** with F5.

Request the forwarded port 80 URL with /index.php?XDEBUG_TRIGGER=1. At the breakpoint, subtotal=50 and discount=5. After F10, total=45 at line 8. F5 completes the response.

See [full instructions](../README.md) and [recorded results](../RESULTS.md).

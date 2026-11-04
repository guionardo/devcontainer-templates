# Minimal example: php-5.1.6

Runtime configuration was applied from OCI template ghcr.io/guionardo/devcontainer-templates/php-5.1.6:0.1.0 and manually tested on November 4, 2026. Code identifiers and annotations have since been translated; see the report for the historical identifier mapping.

Copy .devcontainer/.env.example to .devcontainer/.env before opening the container. Change the Compose name and HTTP port if needed.

Open this folder in VS Code and run **Dev Containers: Reopen in Container**. Set a breakpoint on index.php:7 with F9 and start **Listen for Xdebug** with F5.

Request http://localhost:18051/index.php. At the breakpoint, subtotal=50 and discount=5. After F10, total=45 at line 8. F5 completes the response.

See [full instructions](../README.md) and [recorded results](../RESULTS.md).

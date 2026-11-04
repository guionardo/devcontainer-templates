# Architecture: a PHP Dev Container template catalog

## Scope

This repository distributes reusable development environment configuration. Application repositories own their source code, dependencies, migrations, and business regression tests. Minimal standalone examples are included only to validate execution and debugging.

## Runtime templates

| Template | Runtime | Editor |
| --- | --- | --- |
| `php-5.1.6` | PHP 5.1.6 and Apache CGI on Debian Jessie | Separate Bookworm service |
| `php-5.4` | PHP 5.4.45 and Apache module on Debian Jessie | Separate Bookworm service |
| `php-8.5` | Official PHP 8.5 Apache image | Same container as the runtime |

The legacy editor service hosts VS Code Server and PHP Debug. Both services mount the application at `/var/www/html`, so the debugger and PHP agree on source paths. Xdebug connects to `editor:9000` through the Compose network. The host only needs the HTTP port.

PHP 8.5 runs the editor and runtime in one compatible container; Xdebug connects to its local listener on port 9003. See [ADR-003](decisions/ADR-003-legacy-editor.md).

## Repository layout

- `src/`: independently packaged templates and their metadata.
- `scripts/`: shell installer and release version validator.
- `tests/`: configuration, installer, release validation, and HTTP smoke checks.
- `examples/vscode-debug/`: applied template snapshots and minimal PHP projects.
- `docs/`: architecture, distribution, decisions, and an article draft.
- `.github/workflows/`: validation and tag-triggered OCI publication.

Only `src/` is passed to the publishing action. Examples and article content are not added to the OCI packages.

## Build strategy

The legacy Dockerfiles compile PHP and compatible Xdebug versions with historical dependencies. A modern curl stage downloads source archives with certificate verification, avoiding the obsolete TLS client in Jessie. Debian packages still come from archived repositories.

The PHP 5.1.6 image uses CGI because its historical Apache module cannot be used with the selected Apache 2.4 setup. The PHP 5.4 image uses Apache's prefork MPM.

Source archive checksums and base image digests are not fully pinned. Existing successful builds include cached dependency layers; do not describe them as clean-room or fully reproducible builds.

## Validation boundaries

CI checks release rules, installer behavior, JSON, and Compose configuration. PHP image builds, HTTP execution, and VS Code breakpoint tests were also performed manually; see [results](../tests/RESULTS.md).

A working debugger in the minimal examples does not establish compatibility with a particular framework, database, dependency tree, or business workflow. PHP extensions and database topology remain application decisions.

## Distribution and versions

Templates follow the Dev Container Template metadata layout and are published to GHCR as OCI artifacts. A separate catalog metadata package supports discovery.

The specification permits per-template versions. This repository deliberately uses one coordinated version across all three templates, enforced by tags `vMAJOR.MINOR.PATCH`. See [distribution](distribution.md) for the release process.

## Constraints

Legacy runtimes are unsupported and intended for isolated local maintenance. Keep their dependency directories separate from modern projects, expose only needed ports, and avoid sharing production data or credentials through examples.

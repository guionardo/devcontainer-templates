# PHP Dev Container Templates

Reusable VS Code Dev Container templates for PHP 5.1.6, 5.4, and 8.5, with Apache, Xdebug, OCI distribution through GHCR, and working breakpoint examples.

| Template ID | Validated PHP | Xdebug | Editor connection | Default HTTP |
| --- | --- | --- | --- | --- |
| `php-5.1.6` | 5.1.6 | 2.0.0 | Modern editor container + legacy runtime | localhost:8051 |
| `php-5.4` | 5.4.45 | 2.4.1 | Modern editor container + legacy runtime | localhost:8054 |
| `php-8.5` | 8.5.12 | 3.5.3 | Directly to the PHP/Apache container | Port 80 forwarded by VS Code |

All three published `0.1.0` templates passed manual HTTP, breakpoint, variable inspection, step-over, and continue tests on Windows x64 with Docker Desktop Linux. See the [validation report](examples/vscode-debug/RESULTS.md).

**Current release:** `1.0.0` consolidates the English catalog, versioned OCI publication, package retention, and minimal examples. The historical manual GUI validation belongs to `0.1.0`; see the [changelog](CHANGELOG.md) and the publication workflow for release details.

## Quick start with the official CLI

Install Node.js/npm, Docker with Linux containers, VS Code, and the **Dev Containers** extension. From the root of an existing application:

```sh
npx @devcontainers/cli templates apply --workspace-folder . --template-id ghcr.io/guionardo/devcontainer-templates/php-5.4:1.0.0
```

Replace `php-5.4` with `php-5.1.6` or `php-8.5`. No catalog clone is needed. The version after `:` is the **template version**, not the PHP version.

Apply in a working branch and review existing configurations first. The official CLI does not provide the custom backup behavior described for our shell installer.

For either legacy template, create `.devcontainer/.env`:

```dotenv
COMPOSE_PROJECT_NAME=my-app-php54
PHP_HTTP_PORT=8054
```

Give each concurrent project a distinct Compose name and HTTP port. For PHP 5.1.6, use a suitable name and port 8051. PHP 8.5 does not require this file.

Open the application folder in VS Code and run **Dev Containers: Reopen in Container**. The first build can take several minutes, especially for legacy PHP.

## Install or update with the shell script

Run in **Git Bash, WSL, Linux, or macOS** with Git and curl installed:

```sh
curl -fsSL https://raw.githubusercontent.com/guionardo/devcontainer-templates/main/scripts/install.sh | sh -s -- --php 5.4 --smoke
```

Choose `--php 5.1`, `5.4`, or `8.5`. The current directory is the target project. In Windows, this command is for Git Bash/WSL, not PowerShell.

To download and inspect the script first:

```sh
curl -fsSL https://raw.githubusercontent.com/guionardo/devcontainer-templates/main/scripts/install.sh -o install-php-devcontainer.sh
sh install-php-devcontainer.sh --help
sh install-php-devcontainer.sh --php 5.4 --project ./my-app --smoke
```

Existing `.devcontainer` folders are rejected unless `--update` is supplied. Updates back up the existing configuration, replace known template files, preserve `.env` and custom files, and keep an existing `launch.json`. A new debug configuration is saved as `.devcontainer/launch.template.json` for manual merging. Reapply your changes to overwritten Dockerfiles and Dev Container JSON from the backup.

The shell installer downloads Git source. Its default `main` reference can differ from a published OCI release. Use a Git tag or full commit SHA with `--ref` when you need a fixed revision. See [installation and distribution](docs/distribution.md).

## Try the minimal projects

The [three complete examples](examples/vscode-debug/README.md) contain a minimal PHP calculation, applied Dev Container configuration, and debugger setup. Open one example folder per VS Code window.

For either legacy example, copy `.devcontainer/.env.example` to `.devcontainer/.env` before reopening in a container. Examples use ports **18051** and **18054**, leaving the template defaults available for other applications.

## Apply files manually

Clone this catalog in a separate folder:

```sh
git clone https://github.com/guionardo/devcontainer-templates.git
```

Copy the selected `src/php-*/.devcontainer/` folder into your application. Copy `.vscode/launch.json`, or merge its `configurations` entry into an existing file. Optionally copy `devcontainer-smoke.php`. Catalog metadata and `NOTES.md` do not need to be copied.

If your project already contains `.devcontainer` or a root `.devcontainer.json`, compare and integrate the configurations rather than replacing them blindly. Keep application code and dependency management in the application repository.

## Run and debug

The default Apache document root is `/var/www/html`, which mounts the application root. Adapt Apache for applications that use a `public/` directory or require rewrite rules.

For the legacy templates, browse to the configured HTTP port. For PHP 8.5, open port 80 in the VS Code **Ports** panel; its local forwarded port may differ from 80.

To debug:

1. Open **Run and Debug** and select **Listen for Xdebug**.
2. Start the listener with F5 and set a breakpoint in a PHP file.
3. Request the page. For PHP 8.5, append `?XDEBUG_TRIGGER=1`; legacy Xdebug starts the connection automatically.
4. Inspect local variables, use F10 to step over, and F5 to continue.

The legacy PHP service connects to `editor:9000`. PHP 8.5 connects to `127.0.0.1:9003` inside its own editor/runtime container. You do not need to publish debugger ports on the host. The supplied path mapping is `/var/www/html` to `${workspaceFolder}`.

### PHP commands

**PHP 8.5:** use the integrated terminal inside the Dev Container:

```sh
php -v
php -m
php -l /var/www/html/devcontainer-smoke.php
```

**PHP 5.1.6 and 5.4:** the integrated terminal belongs to the modern `editor` service, which does not contain PHP. From a host terminal at the application root:

```sh
docker compose -f .devcontainer/compose.yaml exec php php -v
docker compose -f .devcontainer/compose.yaml exec php php -m
docker compose -f .devcontainer/compose.yaml exec php php -l /var/www/html/devcontainer-smoke.php
```

See [ADR-003](docs/decisions/ADR-003-legacy-editor.md) for the reason behind the separate editor.

### Stop and rebuild

Use **Dev Containers: Reopen Folder Locally** to disconnect. The templates are configured to stop their container or Compose services. If needed, stop a legacy environment explicitly from the host:

```sh
docker compose -f .devcontainer/compose.yaml down
```

After changing a Dockerfile or configuration, run **Dev Containers: Rebuild Container**. Legacy server logs are available with:

```sh
docker compose -f .devcontainer/compose.yaml logs --tail=100 php
```

## Troubleshooting

| Symptom | What to check |
| --- | --- |
| Docker is unavailable | Start Docker and select Linux containers. |
| HTTP port is already used | Change `PHP_HTTP_PORT` and recreate the legacy environment. |
| Projects interfere with each other | Set a distinct `COMPOSE_PROJECT_NAME` and HTTP port per project. |
| `php` is missing in a legacy terminal | Run PHP in the `php` service through the host commands above. |
| Breakpoint is not reached | Check the listener, request trigger, path mapping, and selected debug configuration. |
| VS Code is in Restricted Mode | Review and trust the project manually to enable execution and debug. |
| Framework returns 404 | Check its public directory and required Apache configuration. |
| Database connection fails | Supply the database service/network and required PHP driver; these are application-specific. |

## Scope and limitations

This repository contains development templates, technical checks, and minimal debugger examples. It does not contain migrated application code, business regression tests, production databases, or automatic Composer installation.

PHP 5.1.6, PHP 5.4, and Debian Jessie are unsupported. Use the legacy environments for isolated local maintenance with trusted code. They are not production deployment templates.

PHP 5.1.6 has no MySQL driver enabled in the current build; PDO core alone does not provide MySQL support. PHP 5.4 includes `mysql`, `mysqli`, and `pdo_mysql`. Review each template's notes before applying it to an application.

Base images use tags and historical source archives still need pinned checksums. Passing tests does not establish fully reproducible builds.

## Package retention

GHCR retains the latest **three versions per package**, including catalog metadata, after a successful publication. Older exact-version URLs may become unavailable. Aliases pointing to one OCI manifest count as one version; Git history and examples remain available. See [retention and manual cleanup](docs/distribution.md#package-retention).

## Documentation

- [Changelog](CHANGELOG.md)
- [Documentation guide](docs/README.md)
- [Installation, OCI packages, and tag-based releases](docs/distribution.md)
- [Architecture and decisions](docs/architecture.md)
- [Validation results](tests/RESULTS.md)
- [Roadmap](docs/roadmap.md)
- [Draft article: debugging legacy PHP with modern VS Code](docs/articles/debugging-legacy-php-with-dev-containers.md)

Publishing a template OCI package distributes configuration files, not prebuilt PHP runtime images. The first use still builds the Dockerfiles locally.

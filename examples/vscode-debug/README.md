# Minimal PHP execution and debugger examples

These three projects exercise a small calculation compatible with PHP 5.1.6. Their runtime configurations were applied from the published OCI templates `0.1.0` and manually validated in VS Code.

| Folder | Validated PHP / Xdebug | HTTP request |
| --- | --- | --- |
| `php-5.1.6` | 5.1.6 / 2.0.0 | http://localhost:18051/index.php |
| `php-5.4` | 5.4.45 / 2.4.1 | http://localhost:18054/index.php |
| `php-8.5` | 8.5.12 / 3.5.3 | Forward port 80 in VS Code, then request `/index.php?XDEBUG_TRIGGER=1` |

The legacy example ports differ from template defaults to allow other applications to use 8051/8054.

## Prepare an example

Prerequisites: Git, Docker with Linux containers, VS Code, and the Dev Containers extension. Legacy runtime images target linux/amd64; other architectures depend on emulation. PHP does not need to be installed on the host.

In PowerShell:

```powershell
git clone https://github.com/guionardo/devcontainer-templates.git
cd devcontainer-templates/examples/vscode-debug/php-5.4
Copy-Item .devcontainer/.env.example .devcontainer/.env
code .
```

For PHP 5.1.6, choose `php-5.1.6` and copy its environment example. For PHP 8.5, choose `php-8.5`; no `.env` is required.

In Git Bash/Linux/macOS, use `cp .devcontainer/.env.example .devcontainer/.env` for either legacy example.

Review `COMPOSE_PROJECT_NAME` and `PHP_HTTP_PORT` before opening concurrent copies. Each needs a distinct project name and available HTTP port. Local `.env` files are ignored by Git.

## Repeat the breakpoint test

1. Open **one project folder**, not the parent containing all three, and run **Dev Containers: Reopen in Container**.
2. If VS Code opens in Restricted Mode, review the project and confirm trust manually.
3. Open `index.php` and set a breakpoint on **line 7** with F9.
4. Start **Listen for Xdebug** with F5. The container configuration installs PHP Debug automatically.
5. Request the URL from the table. PHP 8.5 needs `?XDEBUG_TRIGGER=1`.
6. In **Run and Debug → Variables → Locals**, inspect `$price = 12.5`, `$quantity = 4`, `$subtotal = 50`, and `$discount = 5`.
7. Press F10. Execution should move to line 8, with `$total = 45`.
8. Press F5 to continue. The HTTP response should include PHP and Xdebug versions followed by `Total: 45`.

An HTTP request waits while execution is paused. Do not interpret that wait as an application failure.

Debugging uses `editor:9000` in the legacy layouts and `127.0.0.1:9003` inside the PHP 8.5 container. The supplied files do not explicitly publish debugger ports on the host.

## Commands and shutdown

From a host terminal inside either legacy project:

```sh
docker compose -f .devcontainer/compose.yaml exec php php -v
docker compose -f .devcontainer/compose.yaml logs --tail=50 php
```

Disconnect with **Dev Containers: Reopen Folder Locally**. If necessary, stop legacy services explicitly:

```sh
docker compose -f .devcontainer/compose.yaml down
```

The PHP 8.5 configuration also stops its container when reopening locally.

## Snapshot and evidence policy

Runtime configuration remains a snapshot of the applied `0.1.0` packages. It does not automatically track changes in `src/` or new GHCR releases.

The English revision translates code identifiers, comments, and documentation. The calculation and breakpoint line numbers remain unchanged. Original GUI observations are recorded separately, with a mapping of historical identifiers in the [report](RESULTS.md); they are not claimed as a new GUI test of the translated source.

Examples stay outside `src/` and are not included in OCI package publication. To update a snapshot, apply a new package into a temporary directory and review the differences.

See [HTTP responses](http-results.json), [the report and evidence](RESULTS.md), and the [repository validation summary](../../tests/RESULTS.md).

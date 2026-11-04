# Manual validation of published templates

Date: November 4, 2026.

All three projects executed PHP through Apache and stopped at real breakpoints in VS Code.

| Project | OCI release | PHP | Xdebug | HTTP | Breakpoint | Step-over | Continue |
| --- | --- | --- | --- | --- | --- | --- | --- |
| php-5.1.6 | 0.1.0 | 5.1.6 | 2.0.0 | 200 | index.php:7 | total=45 at line 8 | Total: 45 |
| php-5.4 | 0.1.0 | 5.4.45 | 2.4.1 | 200 | index.php:7 | total=45 at line 8 | Total: 45 |
| php-8.5 | 0.1.0 | 8.5.12 | 3.5.3 | 200 | index.php:7 | total=45 at line 8 | Total: 45 |

## Test environment

- Windows x64 with Docker Desktop in Linux mode.
- VS Code 1.143.1, commit `e646868227c3e3a9e3f24277c8c7220be42c0be7`.
- Dev Containers extension 0.469.0; bundled official CLI 0.89.0, executed with Node.js 24.22.1.
- PHP Debug `xdebug.php-debug` 1.40.2, installed automatically in all three editor containers.
- Inputs: `ghcr.io/guionardo/devcontainer-templates/<template>:0.1.0`, downloaded from the registry and applied to the projects.

The test machine had no `npx` command on PATH, so the bundled official CLI was invoked through its JavaScript entry point. This validates OCI consumption through the official implementation, not a separate test of the npx launcher.

## Observed procedure

Each project was opened in its own VS Code window and reopened in a Dev Container. The user manually confirmed workspace trust. Legacy projects connected the editor to Bookworm and ran PHP in a separate service; PHP 8.5 hosted both roles in one container.

A breakpoint was set on line 7 with F9, the supplied listener was started with F5, and an HTTP request was sent. PHP 8.5 used `XDEBUG_TRIGGER=1`; the legacy requests needed no additional trigger.

All three showed **Paused on breakpoint**, with the calculation function at line 7 and its caller at line 14. Local variables showed price 12.5, quantity 4, subtotal 50, and discount 5.

F10 moved execution to line 8 and changed total to 45. F5 resumed execution and completed the HTTP response with the expected runtime versions and `Total: 45`.

No runtime-template correction was required. Only legacy Compose project names and HTTP ports were adjusted locally to isolate the test from existing services.

## English source and historical identifiers

The original test used Portuguese code identifiers. The maintained example now uses English identifiers; the algorithm and line numbers are unchanged.

| Original captured identifier | Current example |
| --- | --- |
| `calcularTotal` | `calculateTotal` |
| `preco` | `price` |
| `quantidade` | `quantity` |
| `desconto` | `discount` |
| `subtotal`, `total` | Unchanged |

Evidence files below translate UI labels to English but retain the captured identifiers. They describe the original session rather than asserting a second manual GUI validation after the rename. The original report and captures are preserved in [commit 1e1c054](https://github.com/guionardo/devcontainer-templates/tree/1e1c0545b01b0fcec1cfb7738eecbf0c2c00475d/examples/vscode-debug).

## Evidence

- [HTTP responses](http-results.json).
- [PHP 5.1.6 variables and call stack](php51-debug-evidence.txt).
- [PHP 5.4 variables and call stack](php54-debug-evidence.txt).
- [PHP 8.5 variables and call stack](php85-debug-evidence.txt).

The text was extracted from the accessibility view while paused at line 8 after F10. UI element indexes and widget IDs were removed. Screenshots were displayed during validation but are not stored in this repository.

## Repeatability and limits

Follow the [instructions](README.md) to repeat breakpoint, variable inspection, step-over, and continuation. Local environment files are not published; the example files provide generic Compose names and the same test HTTP ports.

This is a manual Windows x64/Docker Desktop Linux test of minimal applications. It does not establish database, framework, business-rule, other-platform, or other-architecture compatibility. CI checks configuration and installer behavior but does not operate the VS Code GUI.

# Validation results

Tests recorded on November 4, 2026, using Docker Desktop 4.97.0 / Engine 29.9.2, Linux amd64.

## Runtime and HTTP checks

| Template | PHP | Xdebug | Build / CLI / Apache / HTTP |
| --- | --- | --- | --- |
| php-5.1.6 | 5.1.6 | 2.0.0 | Passed |
| php-5.4 | 5.4.45 | 2.4.1 | Passed |
| php-8.5 | 8.5.12 | 3.5.3 | Passed |

The smoke check lists modules, validates the example's syntax and Apache configuration, and confirms an HTTP response with PHP and Xdebug versions. The build tests used some cached Debian dependency layers; PHP and Xdebug sources were downloaded and compiled during the original validation.

Source checksums, fully pinned image digests, clean dependency installation, and application database requirements remain outside the completed verification.

## Installer checks

Tested on Git Bash/Windows and in a temporary Linux container:

- Installation for all three runtime selections.
- Refusal to overwrite without `--update`.
- Backup creation and preservation of code, `.env`, `launch.json`, and custom files.
- Paths containing spaces and rejection of invalid inputs.
- Symbolic-link refusal on Linux. The local Git Bash environment emulated `ln -s` with a copy, so this scenario was explicitly skipped there.
- Download by a fixed Git SHA and recording of the selected revision.

A published `curl | sh` invocation was also tested against a fixed commit.

## VS Code breakpoints

Published OCI templates `0.1.0` were downloaded into three minimal projects and opened in VS Code 1.143.1. PHP Debug 1.40.2 was installed automatically.

All three projects paused at `index.php:7`, displayed subtotal 50 and discount 5, stepped to line 8 with total 45, and completed their HTTP response after continuing.

See [examples and instructions](../examples/vscode-debug/README.md) and the [detailed report](../examples/vscode-debug/RESULTS.md). The GUI verification was manual; CI does not repeat it.

The English revision updates example identifiers and messages without changing the calculation or breakpoint line numbers. Historical debug captures retain their original identifiers, with an explicit mapping in the report.

## Automated checks

The validation workflow checks installer behavior, release rules, JSON, and Compose configurations for templates and examples. It does not claim to build runtime images or operate the VS Code GUI.

The consolidated English release uses template version `1.0.0`; the recorded manual GUI validation remains attributed to `0.1.0`.

## English revision checks

The translated release validator passed all four test cases. The translated installer passed its Linux container checks, including backup preservation and symbolic-link refusal. Each translated `index.php` passed syntax validation and executed in its matching PHP runtime, returning `Total: 45`.

All 18 Markdown files were reviewed, local link targets and code fences were checked, and all 16 JSON files parsed successfully. These checks do not replace a new manual GUI test of the translated example identifiers.

## Retention policy checks

Eight automated checks cover three-version retention, alias counting, untagged metadata, latest preservation, invalid metadata, dry-run behavior, scoped deletion IDs, read-failure handling, and organization endpoints. These tests use simulated API responses; the manual workflow provides a live preview of the actual packages and permissions.

# Changelog

## 1.0.0 — 2026-11-04

Consolidates the reusable PHP development environment catalog:

- PHP 5.1.6, PHP 5.4.45, and PHP 8.5 templates with Apache and compatible Xdebug versions.
- Modern editor services for legacy runtimes and a direct editor connection for PHP 8.5.
- Official OCI installation through the Dev Container CLI and a shell installer with backup support.
- Coordinated version tags, validation before publication, and retention of three versions per GHCR package.
- English documentation, architecture decisions, minimal debugging projects, and a draft technical article.

All three template metadata versions are 1.0.0. No new manual GUI test is implied by this version change: the recorded breakpoint, stepping, and HTTP validation belongs to the 0.1.0 baseline. The translated examples were also syntax-checked and executed in all three runtimes, returning Total: 45.

## 0.1.0 — initial published baseline

The three OCI templates were downloaded and manually validated on November 4, 2026. See [the detailed report](examples/vscode-debug/RESULTS.md) for exact runtime versions, tooling, and test boundaries.

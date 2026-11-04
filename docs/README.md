# Documentation guide

Start with the [repository README](../README.md) to choose a runtime and apply a template.

| Document | Purpose |
| --- | --- |
| [Architecture](architecture.md) | Repository scope, runtime layout, and dependency boundaries |
| [Distribution](distribution.md) | Official CLI, shell installer, GHCR packages, and releases |
| [Roadmap](roadmap.md) | Completed work and remaining validation |
| [ADR-001](decisions/ADR-001-three-php-runtimes.md) | Separate runtime templates |
| [ADR-002](decisions/ADR-002-legacy-regression-testing.md) | Ownership of business regression tests |
| [ADR-003](decisions/ADR-003-legacy-editor.md) | Modern editor with a legacy PHP runtime |
| [Validation summary](../tests/RESULTS.md) | Builds, installer checks, and manual debugger verification |
| [Minimal examples](../examples/vscode-debug/README.md) | Repeat the HTTP and breakpoint tests |
| [Manual test report](../examples/vscode-debug/RESULTS.md) | Exact environment, observations, and evidence |
| [Draft blog article](articles/debugging-legacy-php-with-dev-containers.md) | A standalone account of the design and lessons learned |

## Versions and evidence

The catalog milestone is `1.0.0`; all three template metadata files use that version. The earlier OCI release `0.1.0` was manually tested on November 4, 2026. See the [changelog](../CHANGELOG.md) for the consolidated release.

The example runtime configuration comes from `0.1.0`. Example identifiers and annotations have since been translated; the report maps the current English identifiers to the names in the original debugger captures. Historical observations are not presented as a new manual debugger run.

The article is a draft for later editorial review and blog publication. It is not automatically published by a release workflow.

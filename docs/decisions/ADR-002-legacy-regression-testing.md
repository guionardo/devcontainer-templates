# ADR-002: ownership of regression tests

- Date: 2026-10-30
- Status: Accepted; repository scope clarified

## Context

PHP 5.1.6 and PHP 5.4 runtimes can provide reference behavior during application modernization. This repository is an environment template catalog, not an application migration repository.

## Decision

Application repositories own functional tests, business fixtures, and comparisons of business results.

This catalog contains technical environment checks: builds, runtime versions, extensions, HTTP execution, editor integration, and debugging. Minimal standalone PHP examples are allowed for smoke and breakpoint tests.

## Consequences

- Templates remain independent of application code and business data.
- Each application chooses its migration and regression strategy.
- Catalog validation establishes development environment behavior, not application correctness.
- Recorded debugger demonstrations must state their environment and test boundaries.

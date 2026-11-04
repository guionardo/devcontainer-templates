# ADR-001: three independent PHP runtimes

- Date: 2026-10-30
- Status: Accepted

## Context

Legacy applications use PHP 5.1.6 and PHP 5.4 while modernization work targets PHP 8.5. Developers need to maintain and inspect existing behavior during migration.

## Decision

Provide three independent Dev Container templates, each with runtime-specific configuration and dependencies.

## Consequences

- Historical environments can retain their required PHP behavior.
- Developers can run equivalent diagnostic scenarios in separate runtimes.
- Dependency directories and runtime state must not be shared across incompatible versions.
- Maintaining unsupported compilers, libraries, and source archives adds work.
- Legacy environments require isolation and are intended for local development.

## Follow-up decisions

This decision did not originally select HTTP servers, databases, extensions, or workspace mounts. The implemented Apache/editor layout is described in [architecture](../architecture.md) and [ADR-003](ADR-003-legacy-editor.md). Database requirements remain application-specific.

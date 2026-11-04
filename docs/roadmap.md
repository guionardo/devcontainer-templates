# Roadmap

## Completed

- [x] Define three independent PHP runtime templates.
- [x] Keep application migration and business regression tests outside the catalog.
- [x] Record architecture decisions.
- [x] Implement PHP 5.1.6, PHP 5.4, and PHP 8.5 templates.
- [x] Configure compatible Xdebug versions and VS Code listeners.
- [x] Separate modern editors from legacy runtimes.
- [x] Validate runtime builds, CLI versions, Apache, and HTTP execution.
- [x] Publish the first versioned OCI packages to GHCR.
- [x] Support the official CLI and a shell installer with backups.
- [x] Automate configuration and installer validation in CI.
- [x] Publish OCI templates from version tags with metadata checks.
- [x] Validate breakpoints, local variables, F10, and continuation in VS Code.
- [x] Add minimal projects, repeatable instructions, and recorded results.
- [x] Translate maintained content to English and review documentation.
- [x] Prepare a draft article based on the implementation and tests.

## Next

- [ ] Release the English source update as OCI version `0.1.1`.
- [ ] Pin historical source checksums and base image digests.
- [ ] Validate dependency installation without cached build layers.
- [ ] Automate PHP image builds and HTTP smoke checks in CI.
- [ ] Evaluate automation for debugger protocol tests; keep GUI checks clearly identified.
- [ ] Validate additional host platforms and architectures.
- [ ] Consider prebuilt runtime images to reduce initial setup time.
- [ ] Review the draft article and publish it to the maintainer's blog.

Additional framework, database, and application-specific extension requirements belong to each application. General business migration suites remain out of scope.

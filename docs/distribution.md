# Installation and distribution

There are two supported installation paths: the official Dev Container CLI consumes OCI packages, while the shell installer applies files from Git source. Both produce local configuration that VS Code can open.

## Official CLI and GHCR packages

Install Node.js/npm and choose **one** command from the root of an existing project.

PHP 5.1.6:

```sh
npx @devcontainers/cli templates apply --workspace-folder . --template-id ghcr.io/guionardo/devcontainer-templates/php-5.1.6:1.0.0
```

PHP 5.4:

```sh
npx @devcontainers/cli templates apply --workspace-folder . --template-id ghcr.io/guionardo/devcontainer-templates/php-5.4:1.0.0
```

PHP 8.5:

```sh
npx @devcontainers/cli templates apply --workspace-folder . --template-id ghcr.io/guionardo/devcontainer-templates/php-8.5:1.0.0
```

These commands work in PowerShell, Git Bash, WSL, Linux, and macOS when Node.js/npm is available. To target another directory, use `--workspace-folder "C:\dev\my-app"`, for example.

The suffix `:1.0.0` selects a template release, not a PHP or CLI version. The commands select the consolidated `1.0.0` release. The recorded manual GUI validation used the earlier `0.1.0` baseline; current package availability is shown by the publication workflow.

Apply in a working branch and inspect existing files first. The official CLI does not guarantee the backup and preservation behavior of our custom shell installer. For a customized environment, apply a new OCI release in a temporary directory and merge the changes.

For legacy templates, create `.devcontainer/.env` with a unique `COMPOSE_PROJECT_NAME` and suitable `PHP_HTTP_PORT`. The official CLI copies template files but does not generate project-specific values as the shell installer does.

After applying, run **Dev Containers: Reopen in Container** in VS Code. Use **Dev Containers: Rebuild Container** after updating an existing environment. Applying files alone does not start containers or install application dependencies.

## Shell installer

Requires Git, curl for downloading, and POSIX tools. Run in **Git Bash, WSL, Linux, or macOS**. These shell commands are not PowerShell syntax.

From the application root:

```sh
curl -fsSL https://raw.githubusercontent.com/guionardo/devcontainer-templates/main/scripts/install.sh | sh -s -- --php 5.4 --smoke
```

Choose `--php 5.1`, `5.4`, or `8.5`. To target another directory:

```sh
curl -fsSL https://raw.githubusercontent.com/guionardo/devcontainer-templates/main/scripts/install.sh | sh -s -- --php 8.5 --project "/c/dev/my application"
```

To inspect the script before execution:

```sh
curl -fsSL https://raw.githubusercontent.com/guionardo/devcontainer-templates/main/scripts/install.sh -o install-php-devcontainer.sh
sh install-php-devcontainer.sh --help
sh install-php-devcontainer.sh --php 5.4 --project ./my-app --smoke
```

The installer copies configuration and optionally the smoke example. It does not invoke Docker, Composer, PHP application code, or database migrations.

### Existing projects and updates

An existing `.devcontainer` folder is rejected by default. To update:

```sh
sh install-php-devcontainer.sh --php 5.4 --project ./my-app --update
```

The update creates a `.devcontainer-backup.XXXXXX` directory before replacing known files. It updates `devcontainer.json`, `Dockerfile`, and `compose.yaml` when supplied by the selected template.

It preserves `.env`, custom files, application code, and an existing `launch.json`. The new debug configuration is saved as `.devcontainer/launch.template.json`; manually merge its `configurations` array.

Reapply your custom changes to files replaced by the update. The script does not merge JSON/JSONC or remove obsolete files when switching runtimes. An old Compose file can remain after switching to PHP 8.5, but its new Dev Container configuration does not reference that file.

Keep backups outside version control, particularly when local configuration contains credentials. Existing symbolic links at managed destination paths and a root `.devcontainer.json` require manual integration.

Legacy installations get a unique Compose project name when `.env` does not exist. Default HTTP ports are 8051 and 8054. Configure different ports for concurrent projects; existing `.env` values are preserved.

### Fixed revisions and offline source

`--ref` accepts a Git branch, tag, or full commit SHA. By default it uses `main`, which may contain unreleased source. For a fixed install, download the script from a full commit SHA or existing release tag and pass the same reference with `--ref`.

For example, this existing commit contains the source baseline used before the English update:

```sh
curl -fsSL https://raw.githubusercontent.com/guionardo/devcontainer-templates/40899ef915b00f47493140ec21049b90f2a94777/scripts/install.sh | sh -s -- --php 5.4 --ref 40899ef915b00f47493140ec21049b90f2a94777
```

A published OCI version does not prove that a Git tag of the same name exists. Check the repository's tags before using a tag reference. Git `v1.0.0` and OCI `:1.0.0` are distinct identifiers.

For a locally cloned catalog:

```sh
sh /c/dev/devcontainer-templates/scripts/install.sh --php 5.4 --source /c/dev/devcontainer-templates --project /c/dev/my-app
```

The installer records template, reference, and resolved commit in `.devcontainer/template-source.txt`. With local `--source`, the revision is recorded as `local`.

## What is published

A template has `devcontainer-template.json` metadata and `.devcontainer/devcontainer.json`, plus any required configuration files. The publishing workflow packages only `src/`.

The collection produces four GHCR packages:

| Package | Purpose |
| --- | --- |
| `devcontainer-templates/php-5.1.6` | PHP 5.1.6 template |
| `devcontainer-templates/php-5.4` | PHP 5.4 template |
| `devcontainer-templates/php-8.5` | PHP 8.5 template |
| `devcontainer-templates` | Collection metadata for template discovery |

The fourth package is expected and does not represent another PHP runtime. This follows the [official starter's publication model](https://github.com/devcontainers/template-starter#publishing).

Set the template and catalog metadata packages to **Public** for anonymous public downloads. A public Git repository does not automatically make its packages public. Check [package visibility settings](https://docs.github.com/en/packages/learn-github-packages/configuring-a-packages-access-control-and-visibility).

The OCI artifacts distribute configurations, not prebuilt runtime images. The first use still compiles the Dockerfiles. Publishing runtime images would be a separate feature.

## Release from a Git tag

The [publication workflow](../.github/workflows/publish-templates.yaml) runs when a `vMAJOR.MINOR.PATCH` tag is pushed. An ordinary `main` push runs applicable checks but does not publish packages.

Although the standard supports independent template versions, this repository uses **one version across all three templates**. A `v1.0.0` tag requires `"version": "1.0.0"` in all three metadata files.

The `v1.0.0` tag consolidates the current catalog. For a later release, choose a new version, update all three metadata files, and substitute that version in the commands below:

1. Review changes and ensure all three metadata versions are `1.0.0`.
2. Commit and push to `main`; wait for validation to pass.
3. Tag the intended commit and push that tag explicitly:

```sh
git switch main
git pull --ff-only origin main
node scripts/validate-release.cjs v1.0.0
git tag -a v1.0.0 -m "Release Dev Container Templates 1.0.0"
git push origin v1.0.0
```

4. Follow **Publish Dev Container Templates** under GitHub Actions.
5. Verify package versions and visibility, then apply each new package in a temporary project before recommending it to users.

The workflow requires a stable version tag whose commit is in `main` history. It checks metadata versions, release-validator tests, installer behavior, JSON, and Compose before publication. It does not run PHP builds or GUI debugger tests.

Publication uses the automatic `GITHUB_TOKEN` with `packages: write`; no personal token is stored in the repository. Automatic creation of additional repository tags is disabled.

For another release, increment all three metadata files and use a new tag. Do not move published tags or reuse versions for different content; the publishing tool may skip an existing package version.

For a retry after infrastructure or permission failures, rerun the original jobs or dispatch the workflow against the same tag with authenticated GitHub CLI:

```sh
gh workflow run publish-templates.yaml --ref v1.0.0 --repo guionardo/devcontainer-templates
```

A manual run against `main` is rejected. If a fix changes template contents, create a new release instead.

## Package retention

After a successful publication, the workflow retains **three package versions per package**, including the collection metadata package. The four package names remain; this policy limits their stored versions.

Versions are OCI manifests, not individual tags. Aliases such as `latest`, `1`, `1.0`, and `1.0.0` can refer to one manifest and count as a single version. The policy selects the newest manifests by creation time, includes untagged metadata versions, and always preserves the manifest carrying `latest` within the three-version limit. If `latest` was moved to an older manifest, that manifest takes one of the three retained slots.

Older versions are deleted with all tags pointing to them. Their exact-version installation URLs can stop working. Git tags, commits, and the versioned examples are not deleted, so historical source remains available. Installation examples in this documentation may refer to an older validation baseline; select a retained OCI version when installing from GHCR.

The cleanup job runs only after publication succeeds. It inventories all four packages before any deletion and fails without deleting if a package cannot be read or its version metadata is invalid. It does not roll back an already published release if cleanup later fails.

To inspect or apply the policy separately, open **Actions → Clean up old GHCR package versions → Run workflow**, choose `main`, and leave `dry_run` enabled for a preview. Disable it to apply deletion. Publication and manual cleanup share one concurrency group to prevent overlapping operations.

The workflow uses `actions/github-script@v8` on Node.js 24. Its `GITHUB_TOKEN` needs package admin access, in addition to workflow `packages: write`. Packages published by this repository's workflow normally grant that access; for older packages, check **Package settings → Manage Actions access** and assign this repository the Admin role if needed. GitHub can restrict deletion of heavily downloaded public versions; a cleanup failure is reported rather than silently claiming the policy was applied.

Reference: [GitHub package deletion and permissions](https://docs.github.com/en/packages/learn-github-packages/deleting-and-restoring-a-package).

## VS Code discovery

VS Code uses the resulting local files. No custom extension is required to consume the templates through the CLI.

Publishing a Git repository or GHCR package does not automatically place a collection in the public VS Code template picker. The official starter describes registration in the shared collection index. Use the CLI identifiers documented here for an explicit installation path.

## References

- [Dev Container Template specification](https://containers.dev/implementors/templates/)
- [Official CLI: applying templates](https://github.com/devcontainers/cli/blob/main/docs/templates/apply.md)
- [Template authoring starter](https://github.com/devcontainers/template-starter)
- [Publishing action](https://github.com/devcontainers/action)
- [Distribution specification](https://github.com/devcontainers/spec/blob/main/docs/specs/devcontainer-templates-distribution.md)

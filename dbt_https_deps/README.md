# dbt_https_deps

A Meltano project that resolves a **dbt package dependency over HTTPS using an
embedded credential**. It exists to exercise — and regression-guard — the code
path that broke under **MEL-403**, where the platform GitHub `extraHeader` was
injected into pipeline/dbt stages and overrode the per-repo token a dbt
`packages.yml` clone relies on, causing `Repository not found`.

## What it does

The `dbt-https-deps` pipeline (a Meltano schedule) runs a single task,
`dbt-postgres:deps`, i.e. `dbt deps`. dbt then clones the git package declared in
[`transform/packages.yml`](transform/packages.yml):

```
https://oauth2:${DBT_ENV_SECRET_GIT_TOKEN}@github.com/Matatika/sit-dbt-private-package.git
```

`dbt deps` does not connect to the warehouse, so no target database is needed —
the run isolates the credentialed clone. The plugin sets `skip_pre_invoke: true`
to keep `dbt deps` from attempting a warehouse connection first.

> **Note on the inline plugin definition.** The `dbt-postgres` utility is fully
> self-described in `meltano.yml` (`executable`, `namespace`, `pip_url`,
> `settings`, `commands`) rather than referenced by name + variant alone. The
> platform's workspace deploy (`DataComponentLoader`) only creates a data
> component for a plugin that is self-described or already installed; a bare
> `name`/`variant` reference is skipped, and the pipeline then fails validation
> with "Data component 'dbt-postgres' does not exist for the workspace default
> environment". Keep the definition self-described.

## Fixture you must provide

1. **A private dbt package repo.** Replace `Matatika/sit-dbt-private-package` in
   `transform/packages.yml` with a real **private** repo that:
   - is a valid dbt package (contains its own `dbt_project.yml`), and
   - is readable by `DBT_ENV_SECRET_GIT_TOKEN` but **not** by the platform
     GitHub App installation.

   The "not readable by the platform App" part is what makes this a genuine
   regression guard: under the bug, the platform `extraHeader` overrides the
   token and GitHub returns 404 for the private repo.

2. **A token.** `DBT_ENV_SECRET_GIT_TOKEN` must be present in the pipeline's run
   environment with read access to that package repo. (The `DBT_ENV_SECRET_`
   prefix makes dbt mask it in logs.)

## How it's run

The project is cloned into a workspace by the meltano-sit `RunnerITCase` via the
runner config `src/test/resources/runners/transforms/dbt-https-private-package.yml`.
See that file and the meltano-sit README for environment variables and the
`SIT_RUNNER_FILTER` switch.

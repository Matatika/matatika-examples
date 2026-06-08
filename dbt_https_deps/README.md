# dbt_https_deps

A Meltano project used by the meltano-sit `RunnerITCase` to verify the **MEL-403**
fix: when the workspace SSH deploy key is surfaced to a pipeline/dbt task, an
**HTTPS** git clone still authenticates with its own embedded credentials and is
**not** overridden by a platform-injected `http.https://github.com/.extraHeader`
(the override was the regression).

## What it does

The `dbt-https-deps` pipeline (an unscheduled Meltano job) runs `dbt-postgres:deps`,
i.e. `dbt deps`. dbt clones the git package in
[`transform/packages.yml`](transform/packages.yml) over HTTPS using **arbitrary,
intentionally-invalid** credentials:

```
https://sit-user:sit-not-a-real-token@github.com/Matatika/sit-dbt-https-marker.git
```

GitHub rejects those credentials with `Authentication failed`. That rejection is
the assertion: it proves the embedded credentials were the ones actually sent. If
the platform had overwritten the HTTPS auth with its own token (the MEL-403 bug),
the clone would not fail this way (it would succeed or return "Repository not
found"). The SIT therefore expects the job to **error** and asserts the log
contains `Authentication failed` (see
`meltano-sit/src/test/resources/runners/transforms/...`).

## No secrets required

This fixture needs **no real token and no real private repo** — the credentials
are deliberately fake and the clone is meant to fail. The only credential involved
is the workspace SSH key, which the SIT already provides (`GITHUB_SSH_PRIVATE_KEY`)
by cloning the workspace over `git@github.com:...`; that is what surfaces the SSH
key to the task, reproducing the MEL-403 scenario.

## Notes

- `dbt-postgres` is fully self-described inline (executable, namespace, pip_url,
  settings, commands) — the platform only creates a data component for a
  self-described or installed plugin, otherwise the pipeline fails to deploy.
- `project_dir`/`profiles_dir` are setting `value` defaults (not `config:`
  overrides) so Meltano expands `$MELTANO_PROJECT_ROOT`.
- `skip_pre_invoke: true` keeps `dbt deps` from opening a warehouse connection.
- The pipeline is an unscheduled job (no `schedules:` entry); the platform
  validates a pipeline schedule as a 6-field cron, which `@once` is not.

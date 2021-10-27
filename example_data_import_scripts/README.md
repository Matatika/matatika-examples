# Custom Data Import Scripts

You can supply custom bash scripts to a [data import](https://www.matatika.com/docs/glossary#data-import), by selecting "Advanced" under the `Section 2 - Clean, transform and organise` options when setting up or editing a [data import](https://www.matatika.com/docs/glossary#data-import).

---

## Script Examples

In these examples we are using our tap-spotify data source, and target-postgres which is our default data store.

The settings for the data source are supplied by you, and the default data stores settings are pre set in your workspace.

---

```bash
meltano install
meltano elt tap-spotify target-postgres
```

- Install the meltano plugins
- Run the elt

---


```bash
meltano install
meltano elt tap-spotify target-postgres
meltano invoke dbt run
meltano invoke dbt test
```

- Install the meltano plugins
- Run the elt
- Run the dbt transforms
- Run the dbt tests

---

```bash
meltano invoke
meltano elt tap-spotify target-postgres --transform=skip --job_id=$TARGET_POSTGRES_SCHEMA

# do not exit on failure
set +e
meltano invoke dbt test
if [ $? -eq 1 ]; then
    set -e
    # if a project is discarded or model changed, we attempt a full-refresh
    meltano invoke dbt run --full-refresh
    # fail now if there are test errors
    meltano invoke dbt test
fi
```

- Install the meltano plugins
- Run the elt, saving the job and maintaining state
- Run the dbt tests, not failing on error
- If there was an error, turn fail on error back on (`set -e`). Otherwise data import run is complete.
- If there was an error, run the dbt transforms with full refresh
- If there was an error, run the dbt tests again. If it fails again this time, the data import will report the error.

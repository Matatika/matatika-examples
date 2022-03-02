# Custom Data Import Scripts

Under `Section 2 - Clean, transform and organise` in your [data import](https://www.matatika.com/docs/glossary#data-import) edit screen there are two options. `Default Actions` and `Advanced`.

`Default Actions` runs your data import with this [default-actions.sh](default-actions.sh) script.
`Advanced` lets you supply your own pipeline script. If you choose this you are responsible for everything; installing, action ordering and so on.

There is a thrid way to provide a custom data import script, which is to put an `elt.sh` file under `orchestrate/tap-name/`, where `tap-name` is your tap's name, in your workspace's repository. By default there are some data sources that have to use these custom `elt.sh` scripts, and they get added to your workspace when the `analyze-bundle` for the datasource is installed.

If you provide an `elt.sh` file under `orchestrate/tap-name/`, this will become the default actions for any data import that uses that `tap-name` datasource.

Examples of this `elt.sh` script: [analyze-solarvista](https://github.com/Matatika/analyze-solarvista/blob/master/bundle/orchestrate/tap-solarvista/elt.sh), [analyze-googleads](https://github.com/Matatika/analyze-googleads/blob/master/bundle/orchestrate/tap-googleads/elt.sh)

You can also just call a custom elt.sh script in the `Advanced` custom data import script if you wish.

---

## Script Examples

In these examples we are using our `tap-spotify` [data source](https://www.matatika.com/docs/glossary#data-store), and `target-postgres` which is our default [data store](https://www.matatika.com/docs/glossary#data-source). We will also be using the custom data import script on the data import directly, under `Advanced`.

The settings for the data source are supplied by you, and the default data stores settings are pre set in your [workspace](https://www.matatika.com/docs/glossary#workspace).

---

```bash
meltano install
meltano elt tap-spotify target-postgres
```

- Install all meltano plugins
- Run the elt

---


```bash
meltano install
meltano elt tap-spotify target-postgres
meltano invoke dbt run
meltano invoke dbt test
```

- Install all meltano plugins
- Run the elt
- Run the dbt transforms
- Run the dbt tests

---

```bash
meltano install
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

- Install all meltano plugins
- Run the elt, saving the job and maintaining state
- Run the dbt tests, not failing on error
- If there was an error, turn fail on error back on (`set -e`). Otherwise data import run is complete.
- If there was an error, run the dbt transforms with full refresh
- If there was an error, run the dbt tests again. If it fails again this time, the data import will report the error.

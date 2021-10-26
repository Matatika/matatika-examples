# Custom Data Source Discovery Format

You can add

Examples of custom [data source](https://www.matatika.com/docs/glossary#data-source) discovery files.

More examples in the readmes of these repositories:
- [analyze-tap-spotify](https://github.com/Matatika/analyze-spotify)
- [analyze-tap-aws-cost-explorer](https://github.com/Matatika/analyze-aws-cost-explorer)

---

# Basic Data Source Example

You can add just a custom [data source](https://www.matatika.com/docs/glossary#data-import).

```yaml
extractors:
  - name: tap-spotify
    pip_url: git+https://github.com/Matatika/tap-spotify.git
    capabilities:
      - state
      - discover
      - catalog
    settings:
      - name: client_id
        kind: password
      - name: client_secret
        kind: password
      - name: refresh_token
        kind: password
```

---

## Data Source and Related Plugins Example

You can add multiple plugins at once.

```yaml
extractors:
  - name: tap-spotify
    pip_url: git+https://github.com/Matatika/tap-spotify.git
    capabilities:
      - state
      - discover
      - catalog
    settings:
      - name: client_id
        kind: password
      - name: client_secret
        kind: password
      - name: refresh_token
        kind: password
transforms:
  - name: dbt-tap-spotify
    namespace: tap_spotify
    pip_url: https://github.com/Matatika/dbt-tap-solarvista.git
    vars:
      schema: "{{ env_var('DBT_SOURCE_SCHEMA') }}"
files:
  - name: analyze-spotify
    namespace: tap_spotify
    update:
      analyze/datasets/tap-spotify: true
    pip_url: git+https://github.com/Matatika/analyze-spotify.git
```

---

## Multiple Data Sources

You can even add multiple [data sources](https://www.matatika.com/docs/glossary#data-source) at once.

```yaml
extractors:
  - name: tap-spotify
    pip_url: git+https://github.com/Matatika/tap-spotify.git
    capabilities:
      - state
      - discover
      - catalog
    settings:
      - name: client_id
        kind: password
      - name: client_secret
        kind: password
      - name: refresh_token
        kind: password
  - name: tap-aws-cost-explorer
    pip_url: git+https://github.com/albert-marrero/tap-aws-cost-explorer.git
    capabilities:
    - state
    - catalog
    - discover
    settings:
      - name: access_key
        kind: password
      - name: secret_key
        kind: password
      - name: start_date
      - name: end_date
      - name: granularity
      - name: metrics
```
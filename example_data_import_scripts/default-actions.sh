export EXTRACTOR='[(${job.pipeline.dataSource.extractor.name})]'
export LOADER='[(${job.pipeline.dataStore.loader.name})]'

script="orchestrate/$EXTRACTOR/elt.sh"
if [ -f "$script" ]; then . "$script"; exit $?; fi

# install plugins
meltano install extractor "$EXTRACTOR"
meltano install loader "$LOADER"
meltano install transform "$EXTRACTOR"
meltano install transformer dbt

transform='skip'
if [ -d .meltano/transformers/dbt ]; then
    # Temporary fix for markdown dependencies issue: https://github.com/dbt-labs/dbt-core/issues/4745
    .meltano/transformers/dbt/venv/bin/pip3 install --force-reinstall MarkupSafe==2.0.1
    transform='run'
fi

# run elt
meltano elt "$EXTRACTOR" "$LOADER" --transform="$transform"

# setup temporary pipeline environment
MELTANO_ENVIRONMENT="[(${job.pipeline.id})]"
meltano environment add "$MELTANO_ENVIRONMENT"

export MELTANO_ENVIRONMENT

# install plugins
[# th:each="dataComponent : ${job.pipeline.dataComponents}"]
meltano install "[(${#strings.toLowerCase(dataComponent.dataPlugin.type)})]" "[(${dataComponent.dataPlugin.name})]" --include-related
[/]

[# th:switch="${#lists.isEmpty(job.pipeline.actions)}"]

[# th:case="false"]
# run
meltano run [(${#strings.listJoin(job.pipeline.actions, ' ')})]
[/]

[# th:case="*"]

[# th:with="extractorComponent=${job.pipeline.dataComponents.?[dataPlugin.type.name == 'EXTRACTOR'].stream().findFirst()}"]
[# th:with="loaderComponent=${job.pipeline.dataComponents.?[dataPlugin.type.name == 'LOADER'].stream().findFirst()}"]

[# th:if="${extractorComponent.isPresent() && loaderComponent.isPresent()}"]
EXTRACTOR="[(${extractorComponent.get().dataPlugin.name})]"
LOADER="[(${loaderComponent.get().dataPlugin.name})]"

# run custom elt script, if present
script="orchestrate/$EXTRACTOR/elt.sh"
if [ -f "$script" ]; then
	. "$script"
	exit $?
fi

# run elt
meltano run "$EXTRACTOR" "$LOADER" dbt:deps dbt:run
[/]

[# th:unless="${extractorComponent.isPresent() && loaderComponent.isPresent()}"]
echo "Nothing to do for pipeline '[(${job.pipeline.name})]'"
[/]

[/][/][/][/]


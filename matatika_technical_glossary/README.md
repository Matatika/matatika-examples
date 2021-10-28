# Matatika Technical Glossary

Glossary of [Matatika](https://www.matatika.com/) technical terms.

You can see a high level overview of these concepts in our [documentation](https://www.matatika.com/docs/glossary).

---

## Analyze File Bundle

Analyze file bundles are our Matatika [dataset](https://www.matatika.com/docs/glossary#dataset) file bundles. These file bundles are included and all their [datasets](https://www.matatika.com/docs/glossary#dataset) published in your [workspace](https://www.matatika.com/docs/glossary#workspace) if you use one of our supported [data sources](https://www.matatika.com/docs/glossary#data-source).

Examples:
- [Analyze-Spotify](https://github.com/Matatika/analyze-spotify)
- [Analyze-Solarvista](https://github.com/Matatika/analyze-solarvista) 

---

## Config Job

A config job runs upon creation of a [data import](https://www.matatika.com/docs/glossary#data-import). It sets up the [workspace repository](#workspace-repository) with files and settings required to run your [data imports](https://www.matatika.com/docs/glossary#data-import).

A config job will run on every creation of a [data import](https://www.matatika.com/docs/glossary#data-import) and will commit the required changes to allow each one to run.

---

## Custom Data Plugin

A custom data plugin is a user defined [Meltano](#meltano) plugin within the Matatika platform.

Within the Matatika platform user defined Meltano [extractors](#extractor) once configured are [custom data sources](#custom-data-source), and similarly [targets](#target) are [custom data stores](#custom-data-store).

Meltano [transforms](#transform) and [analyze file bundles](#analyze-file-bundle) are generally just referred to as custom data plugins or just data plugins.

---

## Custom Data Source

A custom data source is a configured [custom data plugin](#custom-data-plugin) that is used in a [data import](https://www.matatika.com/docs/glossary#data-import).

To add and use your own custom data source, you can follow our [Adding a Custom Data Source](https://www.matatika.com/docs/getting-started/adding-a-custom-data-source) tutorial.

---

## Custom Data Store

A custom data store is a configured [custom data plugin](#custom-data-plugin) that is used in a [data import](https://www.matatika.com/docs/glossary#data-import).

The [workspace](https://www.matatika.com/docs/glossary#workspace) default [data store]() is the PostgreSQL database that gets created alongside your workspace. Again by default we use this PostgreSQL database though a default data plugin called `target-postgres`, and we also set all required environment variables in your [data import]() containers to use this PostgreSQL database as your data store.

---

## Data Plugin

A data plugin is a definition of a [Meltano](#meltano) plugin, (of any type; [extractor](#extractor), [loader](#loader), [transform](#transform) etc), within the Matatika platform. We have predefined data plugins for immediate use, and allow the creation of [custom data plugins](#custom-data-plugin).

---

## dbt

dbt (Data build tool) allows you to write custom transforms for you data. Some of our [extractors](#extractor) come with custom [transforms](#transform) included, which we use to clean and/or prepare your data for analysis.

Examples of our dbt projects: 
- [dbt-tap-spotify](https://github.com/Matatika/dbt-tap-spotify)
- [dbt-tap-solarvista](https://github.com/Matatika/dbt-tap-solarvista)

[dbt documentation](https://docs.getdbt.com/)

---

## Extractor

A extractor is a [Meltano](#meltano) instance of a [singer](#singer) [tap](#tap), that we use for our [data sources](https://www.matatika.com/docs/glossary#data-source).

---

## Loader

A loader is a [Meltano](#meltano) instance of a [singer](#singer) [target](#target), that we use for our [datastores](https://www.matatika.com/docs/glossary).

---

## Meltano

Meltano is a data automation tool used for managing plugins, mostly [singer](#singer) and [dbt](#dbt) plugins but also a few others. We use Meltano to run our [data imports](https://www.matatika.com/docs/glossary#data-import), and manage our [data sources](https://www.matatika.com/docs/glossary#data-source) and [data stores](https://www.matatika.com/docs/glossary#data-store).

[Meltano Documentation](https://meltano.com/docs/)

---

## Singer

Singer is a specification to describe data extraction and data loading scripts, called [taps](#tap) and [targets](#target).

[Singer Documentation](https://github.com/singer-io/getting-started)

---

## Tap

A tap is a [Singer](#singer) specification plugin to get data from a source. Instances of taps used in [Meltano](#meltano) are called [extractors](#extractor). 

Instances of [extractors](#extractor) used in the Matatika platform are called [data plugins](https://www.matatika.com/docs/glossary#data-plugin), and when configured and used in a [data import](https://www.matatika.com/docs/glossary#data-import) they are called a [data source](https://www.matatika.com/docs/glossary#data-source).

---

## Target

A target is a [Singer](#singer) specification plugin to load data into a destination. Instances of targets used in [Meltano](#meltano) are called [loaders](#loaders).

Instances of [loaders](#loaders) used in the Matatika platform are called [data plugins](https://www.matatika.com/docs/glossary#data-plugin), and when configured and used in a [data import](https://www.matatika.com/docs/glossary#data-import) they are called a [data store](https://www.matatika.com/docs/glossary#data-store).

---

## Transforms

Transforms are [dbt](#dbt) plugins used by [Meltano](#meltano). The transforms are used during the [data import](https://www.matatika.com/docs/glossary#data-import) run to clean and/or prepare data for analysis.

Not all of our supported [data sources](https://www.matatika.com/docs/glossary#data-source) use transforms, but if they do by default and they also have an [analyze file bundle](#analyze-file-bundle), then they will be required to run to make use of the [datasets](https://www.matatika.com/docs/glossary#dataset) included with your [data source](https://www.matatika.com/docs/glossary#data-source).

---

## Workspace Repository

Your workspace repository is a github hosted git repository that contains all files relating to your [workspace](https://www.matatika.com/docs/glossary#workspace). They workspace repository will be setup and adjusted during [config jobs](#config-job), which run each time a [data import](https://www.matatika.com/docs/glossary#data-import) is created.

The workspace repository is a normal repository in that you have complete source control, though it is recommended to leave the file structure intact, as this is required for [Meltano](#meltano) to run your [data imports](https://www.matatika.com/docs/glossary#data-import).

---
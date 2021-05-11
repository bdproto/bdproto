# BDPROTO raw data sources and scripts

This folder contains the raw input data sources for the aggregated BDPROTO database:

* [bdproto-original](bdproto-original)
* [uz](uz)
* [ancient-near-east](ancient-near-east)
* [huji](huji)

It also contains an [aggregation script](aggregation.Rmd) that combines these sources together with their metadata into a single [bdproto.csv](../bdproto.csv) file.

Note that the different raw data sources contain additional data that are pertinent to those sources or analyses that originally used those sources. Please refer to each source for particulars. The aggregation script combines the raw data sources on the parameters shared across them.
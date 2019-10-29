BDPROTO
=======

BDPROTO is a database of phonological inventories from ancient and reconstructed languages. The aggregated phonological inventory data and associated metadata is available in a flat CSV file in this directory named `bdproto.csv`. Bibliographic references for each data point are available in the `sources.bib` file.

This source is described in and can be cited as:

```Marsico, Egidio, Sebastien Flavier, Annemarie Verkerk and Steven Moran. 2018. BDPROTO: A Database of Phonological Inventories from Ancient and Reconstructed Languages. In Proceedings of the Eleventh International Conference on Language Resources and Evaluation (LREC 2018), 1654-1658. May 7-12, Miyazaki, Japan. Online:``` [http://www.lrec-conf.org/proceedings/lrec2018/pdf/534.pdf](http://www.lrec-conf.org/proceedings/lrec2018/pdf/534.pdf)

If using the data in your research, for replicability purposes you may also want to cite the specific version of BDPROTO being used. We archive versions of the BDPROTO data in [Zenodo](https://doi.org/10.5281/zenodo.3521639).

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3521639)](https://doi.org/10.5281/zenodo.3521639)

The original source data (and project name) come from:

```Marsico, Egidio. 1999. What can a database of proto-languages tell us about the last 10,000 years of sound changes. In Proceedings of the XIVth International Congress of Phonetic Sciences (ICPhS99), 353-356. Online:``` [https://www.internationalphoneticassociation.org/icphs-proceedings/ICPhS1999/papers/p14_0353.pdf](https://www.internationalphoneticassociation.org/icphs-proceedings/ICPhS1999/papers/p14_0353.pdf)

This legacy resource was converted into Unicode UTF-8 using principles defined in [Moran & Cysouw, 2018](https://github.com/unicode-cookbook/cookbook/blob/master/unicode-cookbook.pdf). The original BDPROTO data is available in various formats along with the extraction and transformation scripts at: [https://github.com/bdproto/bdproto-legacy](https://github.com/bdproto/bdproto-legacy). BDPROTO contains a convenience sample aimed at genealogical diversity and it contains no duplicate inventories for a given reconstruction.

Two additional resources have been compiled to update and extend the coverage of the original BDPROTO sample. These include the raw data in the `src` directory for the two resources `ancient-near-east` and `uz`. These data points contain more recent reconstructions, which in some cases introduces more than one inventory for a given reconstruction.

The ancient near-east inventories were collected as part of a project on ancient near-east languages at the Department of Comparative Linguistics at the University of Zurich, which were made available to this project. 

Additional inventories from recent publications was also extracted from source references at the Department of Comparative Linguistics. We simply call this source `uz`.

For all three data sources, we have gathered additional metadata including identifying information such as Glottolog codes, but also information about estimated time-depth, possible homeland, etc. The phonological inventory data and metadata are aggregated from the raw sources into a single flat-file table, available in this directory, called `bdproto.csv`.

We have also collected and curated references for each data point and we make them available in the `sources.bib` file. 

BDPROTO
=======

BDPROTO is a database of phonological inventories from ancient and reconstructed languages. The aggregated phonological inventory data and associated metadata is available in a flat CSV file in this directory named [bdproto.csv](bdproto.csv). Bibliographic references for each data point are available in the [sources.bib](sources.bib) file.

BDPROTO 1.0 is described in:

```Marsico, Egidio, Sebastien Flavier, Annemarie Verkerk and Steven Moran. 2018. BDPROTO: A Database of Phonological Inventories from Ancient and Reconstructed Languages. In Proceedings of the Eleventh International Conference on Language Resources and Evaluation (LREC 2018), 1654-1658. May 7-12, Miyazaki, Japan. Online:``` [http://www.lrec-conf.org/proceedings/lrec2018/pdf/534.pdf](http://www.lrec-conf.org/proceedings/lrec2018/pdf/534.pdf).

An expanded version, BDPROTO 1.1, is described in:

```Moran, Steven, Eitan Grossman and Annemarie Verkerk. 2020. Investigating diachronic trends in phonological inventories using BDPROTO. Language Resources and Evaluation. Online:``` [https://link.springer.com/article/10.1007/s10579-019-09483-3](https://link.springer.com/article/10.1007/s10579-019-09483-3).

The BDPROTO data are available under the [Creative Commons Attribution Share Alike 4.0 International](https://github.com/bdproto/bdproto/blob/master/LICENSE.txt) license. If you use the BDPROTO data in your research, it is recommended that you make use of the most recent release in your own analyses. We archive each release of BDPROTO in [Zenodo](https://doi.org/10.5281/zenodo.3521639).

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3521639.svg)](https://doi.org/10.5281/zenodo.3521639)

The original source data (and project name) come from:

```Marsico, Egidio. 1999. What can a database of proto-languages tell us about the last 10,000 years of sound changes. In Proceedings of the XIVth International Congress of Phonetic Sciences (ICPhS99), 353-356. Online:``` [https://www.internationalphoneticassociation.org/icphs-proceedings/ICPhS1999/papers/p14_0353.pdf](https://www.internationalphoneticassociation.org/icphs-proceedings/ICPhS1999/papers/p14_0353.pdf)

This legacy resource was converted into Unicode UTF-8 using principles defined in [Moran & Cysouw, 2018](https://langsci-press.org/catalog/book/176) and according to the [PHOIBLE Unicode IPA conventions](http://phoible.github.io/conventions/). The original BDPROTO data is available in various formats along with the extraction and transformation scripts at: [https://github.com/bdproto/bdproto-legacy](https://github.com/bdproto/bdproto-legacy). BDPROTO-legacy contains a convenience sample aimed at genealogical diversity and it contains no duplicate inventories for a given reconstruction.

Three additional resources have been compiled to update and extend the coverage of the original BDPROTO sample. These include the raw data in the [src](src) directory for the three resources [ancient-near-east](src/ancient-near-east), [uz](src/uz), and [huji](src/huji). These data points contain more recent reconstructions, which in some cases introduces more than one inventory for a given reconstruction.

The `ancient-near-east` inventories were collected as part of a project on ancient Near East languages at the Department of Comparative Linguistics at the University of Zurich. Additional inventories were also extracted from source references at the Department of Comparative Linguistics (we simply call this source `uz`). Ongoing work by The Hebrew University of Jerusalem includes phonological inventories from recent publications. This source is labeled `huji`.

For all four data sources, we have gathered additional metadata (when available) including identifying information such as [Glottolog](https://glottolog.org/) codes, but also information about estimated time-depths, possible homelands, etc. The phonological inventory data and metadata are aggregated from the four raw data sources into a single flat-file table, available in this directory, called [bdproto.csv](bdproto.csv).

We have also collected and curated references for each data point and we make them available in the [sources.bib](sources.bib) file. 

Preliminary studies based on recent versions of BDPROTO have been presented at the following conferences:

- Steven Moran and Eitan Grossman. 2021. Temporal bias: a new type of bias for typologists to worry about. *5th Usage-Based Linguistics Conference* (Tel Aviv, Israel, July 5-7 2021). [Slides](research/UBL2021.pdf).

- Eitan Grossman. 2021. Universals of phonological segment borrowing? Questions, evidence, methods, findings. Keynote address at the *43 Jahrestagung der Deutschen Gesellschaft fuer Sprachwissenschaft (DGfS).* (Freiburg, Germany, 23-26 February 2021). [Slides](research/DgFS_2021_Keynote-26.pdf).

A recent paper making extensive use of BDPROTO is:

- Steven Moran, Nicholas A. Lester and Eitan Grossman. 2021. Inferring recent evolutionary changes in speech sounds. *Philological Transactions of the Royal Society B* 376: 20200198. [https://doi.org/10.1098/rstb.2020.0198](https://doi.org/10.1098/rstb.2020.0198).

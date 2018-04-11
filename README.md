BDPROTO
=======

BDPROTO is a database of phonological inventories from ancient and reconstructed languages. This repository contains the originally compiled and more-recently updated and curated data from phonological inventories from reconstructed proto-languages (BDPROTO, UZ) and from ancient languages (UZ).


BDPROTO source data
-------------------
The original source data (and project name) come from Marsico 1999:

@inproceedings{marsico1999can,
  title={What can a database of proto-languages tell us about the last 10,000 years of sound changes},
  author={Marsico, Egidio},
  booktitle={Proceedings of the XIVth International Congress of Phonetic Sciences},
  year={1999}
}

Source BDPROTO inventories were converted into Unicode UTF-8 (for original data and conversion, see `raw-data/BDproto-original`). The updated inventories reside in the folder `raw-data/bdproto`. 

BibTeX references for each data point were collected and put into `raw-data/metadata/bdproto-references.bib`. This bibliography also contains references for the two other additional sources.

Additional metadata were collected about the inventories, including Glottolog codes, estimate time-depths, etc., in the metadata file in the same directory. 


UZ inventories
--------------
A number of additional inventories and corresponding metadata were collected at the Department of Comparative Linguistics. These can be found in the folder `raw-data/uz/`.


Ancient near-east inventories
-----------------------------
Inventories of ancient near-east languages were collected the the Department of Comparative Linguistics and made available to this project. These inventories and their corresponding metadata are in the folder `raw-data/ancient-near-east`.


Aggregation script
------------------
In the folder `code` there is an aggregation script written in R that takes the three sources mentioned above and aggregates them into one R data object that contains the combined inventory data, metadata, errors, and counts. We use the phonological feature vectors from PHOIBLE to annotated the segments described in the proto-inventories. Some new feature definitions must be added to generate complete coverage of segments (this is a work in progress).


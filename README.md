BDPROTO
=======
BDPROTO is repository that contains raw data about phonological inventories that have been reconstructed for a number of proto-languages.


BDPROTO original data
---------------------
The original source data (and project name!) come from Marsico 1999. 

@inproceedings{marsico1999can,
  title={What can a database of proto-languages tell us about the last 10,000 years of sound changes},
  author={Marsico, Egidio},
  booktitle={Proceedings of the XIVth International Congress of Phonetic Sciences},
  year={1999}
}

The original BDPROTO inventories were converted into Unicode UTF-8 (for original data and conversion, see `raw-data/BDproto-ogirinal`). The updated inventories reside in the folder `raw-data/bdproto`. Additional metadata were collected about the inventories, including Glottolog codes, estimate time-depths, etc., in the metadata file in the same directory. BibTeX references for each data point were collected and put into `raw-data/metadata/bdproto-references.bib`. This bibliography also contains references for the two other additional sources.


UZ inventories
--------------
A number of additional inventories and corresponding metadata were collected at the Department of Comparative Linguistics. These can be found in the folder `raw-data/uz/`.


Ancient near-east inventories
-----------------------------
Inventories of ancient near-east languages were collected the the Department of Comparative Linguistics. These inventories and their corresponding metadata are in the folder `raw-data/ancient-near-east`.


Aggregation script
------------------
In the folder `code` there is an aggregation script written in R that takes the three sources mentioned above and aggregates them into one R data object that contains the combined inventory data, metadata, errors, and counts. We use the phonological feature vectors from PHOIBLE to annotated the segments described in the proto-inventories. Some new definitions must be added (work in progress).


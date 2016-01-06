# bdproto

Below is an old README from another repository that needs to be sorted out.

BDPROTO
=======

Do not redistribute.

Contains data from BDPROTO, a database of proto-languages' segment inventories. See Marsico 1999. 

@inproceedings{marsico1999can,
  title={What can a database of proto-languages tell us about the last 10,000 years of sound changes},
  author={Marsico, Egidio},
  booktitle={Proceedings of the XIVth International Congress of Phonetic Sciences},
  year={1999}
}


Contents
--------

This repo contains the original data:

- bdproto/ - original files from Marisco et al (CRNS Lyon)
- bdproto/Informations/ - original metadata files
- bdproto/csv/ - original csv files
- bdproto/sql - original sql dumps

I created a bibtex db for BDPROTO's contents, aggregated some metadata and created a db table from Marisco's SQL files:

- bdproto.bib
- bdproto-metadata.tsv
- BDPROTO_2014-09-10.sql

My goal is to extract a BDPROTO inventories and their segments in Unicode IPA and in the PHOIBLE format.


CONVERSION NOTES
----------------

## Problems / corrections in the unicode2ipa file:

unicode2ipa (original) contained a many-to-one-mapping:

107	0027	'	02BC	ʼ
108	0027	'	02C0	ˀ

I delete the second occurrence (108) because all rows that contained 0027 in the phonemes (original) table contained the word "ejective".

Also updated:

7	0067	g	0261	ɡ

and to reflect Unicode's inclusion of the LATIN SMALL LETTER V WITH RIGHT HOOK (previously in PUA)

133	0056	2C71	ⱱ


## Missing code points

The IPALA-to-Unicode mapping in "unicode2ipa" (original) was not complete, so additions were made and put into a "unicode2ipa-updated" table. I referred to the PHOIBLE UPSID-to-IPA mappings file.

https://github.com/phoible/phoible/tree/master/data/UPSID


TODOS
-----

Ask Egidio if he wants to expand the dataset. What's with the current website development, etc?

What needs to be done to integrate the dataset with PHOIBLE inventories?

- no language codes (these are proto-languages)
- segment types need to be checked and aligned (e.g. bdproto-to-upsid/phoible)



NOTES
-----

One old version is online, with some php script to do the harmonization, for example :
http://www.diadm.ish-lyon.cnrs.fr/upsid/index.php?set_db=BDPROTO&view=lang&code=1061
 
change the code value in the example above with the code of the language, and it should work (see data for the code list).
 
For the data I use, I send you a zip with 6 files :
- Languesbdproto_dynaste.sql with basic information about languages and code (to use in the link above)

- Segments_dynaste.sql with links between code (of a language) and APICodeEntier ( of a phoneme)

- Phonemes_dynaste.sql with the APICodeEntier informations (features are in champs1 and Caracteristique). CaractHex represent the phoneme in IPALA (4 digits for each units).

- Caractapi_dynaste.sql with the CodeArticulation(features) for each APICodeEntier in a relational table.

- Articulation_dynaste.sql with the CodeArticulation description.

 
Last file :
- Unicode2ipa_dynaste.sql with the harmonization from ipala to unicode (for each 4 digits found in the field caractHex from the table phonemes)

 
Code in table above and following examples are in hexa.
I found a rule in the php script to harmonize ipala 0067 to 0261 when in a complex segment ( more than 2 units like ɡ͡b … the link is a unit )
 
One more thing :

The unicode 0361 (link between units in a segment) is in a different place in the ipala font (and different code : 2015).
In unicode : between the two units
In ipala : after the two units to join … but there is  one exception : nmg͡b the 2015 is between the 2 units and the first one is 0067 (make the change from 0067 to 0261 )
 
I hope this will help you, and that I don’t have make too much mistake in this email 







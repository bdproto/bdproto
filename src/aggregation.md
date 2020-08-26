BDPROTO raw data sources aggregation script
================
Steven Moran
<a href="mailto:steven.moran@uzh.ch" class="email">steven.moran@uzh.ch</a>
26 August, 2020

Overview
========

This a script to aggregate the raw data sources in BDPROTO into single
CSV and RData files.

In BDPROTO versions 1.0 and 1.1, we integreated separate metadata for
each raw data source (`bdproto-original`, `uz`, `huji`, and
`ancient-near-east`). To make things easier to maintain and process, we
extracted the metadata fields pertinent to all source inventories into a
separate CSV file, which we then aggregated into the combined raw data
sources.

    library(testthat)
    library(tidyverse)
    library(dplyr)
    library(readr)
    library(knitr)
    library(stringi)

Read in the metadata.

    metadata <- read_csv('BDPROTO metadata - bdproto_metadata.csv')

Let’s do some tests to make sure things like Glottolog glottocodes are
valid. First load the Glottolog’s languiods data.

    glottolog <- read_csv('glottolog_languoid.csv/languoid.csv')

Then make sure all BDPROTO glottocodes are represented in that file.
Note that we have a bunch of NAs (we know there exists no glottocode for
these languages). These should all be NA.

    metadata$Glottocode[which(!(metadata$Glottocode %in% glottolog$id))]

    ##  [1] NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA

Let’s eyeball the canonical language names for typos.

    table(metadata$LanguageName) %>% kable()

| Var1                             | Freq |
|:---------------------------------|-----:|
| Akkadian                         |    1 |
| Ancient North Arabian            |    1 |
| Ancient South Arabian            |    1 |
| Aramaic                          |    1 |
| Attic Greek                      |    1 |
| Avestan                          |    1 |
| Classical Armenian               |    1 |
| Common Slavic                    |    1 |
| Coptic                           |    1 |
| Early Proto-Finnic               |    1 |
| Elamite                          |    1 |
| Hattic                           |    1 |
| Hittite                          |    1 |
| Hurrian                          |    1 |
| Kassite                          |    1 |
| Luwian                           |    1 |
| Middle Egyptian                  |    1 |
| Middle English                   |    1 |
| Neo-Phrygian                     |    1 |
| Nostratic                        |    1 |
| Old Chinese                      |    1 |
| Old Egyptian                     |    1 |
| Old Persian                      |    1 |
| Old Telugu                       |    1 |
| Palaic                           |    1 |
| Paleo-Phrygian                   |    1 |
| Phoenician                       |    1 |
| Pre-Basque                       |    1 |
| Pre-Nizaa                        |    1 |
| Proto-Afroasiatic                |    1 |
| Proto-Ainu                       |    1 |
| Proto-Albanian                   |    1 |
| Proto-Algonquian                 |    2 |
| Proto-Alor-Pantar                |    1 |
| Proto-Altaic                     |    1 |
| Proto-Anatolian                  |    2 |
| Proto-Anim                       |    1 |
| Proto-Arawakan                   |    1 |
| Proto-Aslian                     |    1 |
| Proto-Athabaskan                 |    2 |
| Proto-Australian                 |    1 |
| Proto-Austroasiatic              |    2 |
| Proto-Austronesian               |    1 |
| Proto-Aymaran                    |    1 |
| Proto-Baltic                     |    1 |
| Proto-Baltic-Finnic              |    1 |
| Proto-Balto-Slavic               |    2 |
| Proto-Bantu                      |    1 |
| Proto-Baraic                     |    1 |
| Proto-Barbacoan                  |    1 |
| Proto-Berber                     |    3 |
| Proto-Blang                      |    1 |
| Proto-Boazi                      |    1 |
| Proto-Boran                      |    1 |
| Proto-Bulaka River               |    1 |
| Proto-Bungku-Tolaki              |    1 |
| Proto-Caddoan                    |    1 |
| Proto-Celtic                     |    2 |
| Proto-Central Chadic             |    1 |
| Proto-Central Gur                |    1 |
| Proto-Chadic                     |    1 |
| Proto-Cherokee                   |    1 |
| Proto-Chiapanec                  |    1 |
| Proto-Chibchan                   |    1 |
| Proto-Chimakuan                  |    2 |
| Proto-Chinantecan                |    1 |
| Proto-Chukotko-Kamchatkan        |    1 |
| Proto-Costanoan                  |    1 |
| Proto-Cushitic                   |    1 |
| Proto-Dené–Caucasian             |    1 |
| Proto-Dravidian                  |    1 |
| Proto-East Tariku                |    1 |
| Proto-East Timor                 |    1 |
| Proto-Eastern Nilotic            |    1 |
| Proto-Eastern-Oceanic            |    1 |
| Proto-Edoid                      |    1 |
| Proto-Egyptian                   |    1 |
| Proto-Engan-Kewa-Huli            |    1 |
| Proto-Ersuic                     |    1 |
| Proto-Eskimo                     |    2 |
| Proto-Eskimo-Aleut               |    2 |
| Proto-Finno-Permic               |    2 |
| Proto-Finno-Saamic               |    1 |
| Proto-Finno-Ugric                |    1 |
| Proto-Gbaya                      |    1 |
| Proto-Germanic                   |    2 |
| Proto-Gorokan                    |    1 |
| Proto-Greater Central Philippine |    1 |
| Proto-Greek                      |    1 |
| Proto-Guahiboan                  |    1 |
| Proto-Guang                      |    1 |
| Proto-Gunwinyguan                |    1 |
| Proto-Hlai                       |    2 |
| Proto-Huavean                    |    1 |
| Proto-Huon Gulf                  |    1 |
| Proto-Ijo                        |    1 |
| Proto-Indo-European              |    2 |
| Proto-Indo-Iranian               |    1 |
| Proto-Inland Gulf of Papua       |    1 |
| Proto-Iranian                    |    1 |
| Proto-Irish                      |    1 |
| Proto-Iroquoian                  |    2 |
| Proto-Italic                     |    1 |
| Proto-Iwaidjan                   |    1 |
| Proto-Jabuti                     |    1 |
| Proto-Japonic                    |    1 |
| Proto-Je                         |    1 |
| Proto-Kadaic                     |    2 |
| Proto-Kanyara                    |    1 |
| Proto-Karen                      |    1 |
| Proto-Kartvelian                 |    2 |
| Proto-Katuic                     |    1 |
| Proto-Keresan                    |    2 |
| Proto-Khanty                     |    1 |
| Proto-Khoe                       |    2 |
| Proto-Kiowa-Tanoan               |    2 |
| Proto-Kiranti                    |    1 |
| Proto-Koiarian                   |    1 |
| Proto-Koiaric                    |    1 |
| Proto-Koman                      |    1 |
| Proto-Kuki-Chin                  |    1 |
| Proto-Lakes Plain                |    1 |
| Proto-Lakkia                     |    1 |
| Proto-Lolo-Burmese               |    1 |
| Proto-Lower Cross                |    1 |
| Proto-Lower Sepik                |    1 |
| Proto-Maban                      |    1 |
| Proto-Maiduan                    |    2 |
| Proto-Malayo-Polynesian          |    1 |
| Proto-Mamore-Guapore             |    1 |
| Proto-Mande                      |    1 |
| Proto-Manding                    |    1 |
| Proto-Mansi                      |    1 |
| Proto-Markham                    |    1 |
| Proto-Maweti-Guarani             |    1 |
| Proto-Mayan                      |    2 |
| Proto-Micronesian                |    1 |
| Proto-Miwok-Costanoan            |    1 |
| Proto-Miwokan                    |    1 |
| Proto-Mixe-Zoquean               |    1 |
| Proto-Mixtecan                   |    1 |
| Proto-Mohawk                     |    1 |
| Proto-Mohawk-Oneida              |    1 |
| Proto-Mon                        |    1 |
| Proto-Mongolic                   |    1 |
| Proto-Munda                      |    1 |
| Proto-Muskogean                  |    1 |
| Proto-Nakanai                    |    1 |
| Proto-New Caledonian             |    1 |
| Proto-Nicobar                    |    1 |
| Proto-Nilo-Saharan               |    1 |
| Proto-Nilotic                    |    1 |
| Proto-North Germanic             |    1 |
| Proto-North Halmahera            |    1 |
| Proto-Northern Iroquoian         |    1 |
| Proto-Northwest Semitic          |    1 |
| Proto-Nubian                     |    1 |
| Proto-Nuclear Tirio              |    1 |
| Proto-Nuristani                  |    1 |
| Proto-Nyulnyulan                 |    1 |
| Proto-Ob-Ugric                   |    2 |
| Proto-Oirata-Fataluku            |    1 |
| Proto-Ongamo-Maa                 |    1 |
| Proto-Otomanguean                |    1 |
| Proto-Otomi                      |    1 |
| Proto-Palaihnihan                |    1 |
| Proto-Pama-Nyungan               |    1 |
| Proto-Paman                      |    2 |
| Proto-Pearic                     |    1 |
| Proto-Permian                    |    1 |
| Proto-Polynesian                 |    1 |
| Proto-Pomoan                     |    1 |
| Proto-Popolocan                  |    1 |
| Proto-Potou-Tano                 |    1 |
| Proto-Quechuan                   |    1 |
| Proto-Quichean                   |    1 |
| Proto-Saami                      |    2 |
| Proto-Sabaki                     |    1 |
| Proto-Salishan                   |    2 |
| Proto-Samoyedic                  |    2 |
| Proto-Sangiric                   |    1 |
| Proto-Sara-Bongo-Bagirmi         |    1 |
| Proto-Semitic                    |    2 |
| Proto-Siouan                     |    1 |
| Proto-Skou                       |    1 |
| Proto-Slavic                     |    2 |
| Proto-Southern Nilotic           |    1 |
| Proto-Southern-Cushitic          |    1 |
| Proto-Tacanan                    |    1 |
| Proto-Tai                        |    3 |
| Proto-Takelman                   |    1 |
| Proto-Taranoan                   |    1 |
| Proto-Tibeto-Burman              |    2 |
| Proto-Timor-Alor-Pantar          |    1 |
| Proto-Tokharian                  |    1 |
| Proto-Tol (Jicaque)              |    1 |
| Proto-Totonacan                  |    2 |
| Proto-Totozoquean                |    1 |
| Proto-Trans-New Guinea           |    1 |
| Proto-Tsimshian                  |    1 |
| Proto-Tucanoan                   |    2 |
| Proto-Tupi-Guarani               |    2 |
| Proto-Turkic                     |    1 |
| Proto-Tuscarora                  |    1 |
| Proto-Tuscarora-Nottoway         |    1 |
| Proto-Ugric                      |    1 |
| Proto-Unangam Tunuu (Aleut)      |    1 |
| Proto-Uralic                     |    2 |
| Proto-Uto-Aztecan                |    2 |
| Proto-Vietic                     |    1 |
| Proto-Vietnamese                 |    1 |
| Proto-Waikuruan (Guaicuruan)     |    1 |
| Proto-West Oceanic Linkage       |    2 |
| Proto-West Tariku                |    1 |
| Proto-Western Pantar             |    1 |
| Proto-Willaumez                  |    1 |
| Proto-Wintun                     |    1 |
| Proto-Yokuts                     |    2 |
| Proto-Zapotec                    |    2 |
| Proto-Zoque                      |    1 |
| Proto‒Marind-Yaqay               |    1 |
| Sumerian                         |    2 |
| Ugaritic                         |    1 |
| Uralo-Siberian                   |    1 |
| Urartian                         |    1 |

And the same for the language family names.

    table(metadata$LanguageFamily) %>% kable()

| Var1                       | Freq |
|:---------------------------|-----:|
| Afro-Asiatic               |    1 |
| Ainu                       |    1 |
| Albanian                   |    1 |
| Aleut                      |    1 |
| Algic                      |    2 |
| Alor-Pantor                |    1 |
| Altaic                     |    1 |
| Anatolian                  |    5 |
| Anim                       |    1 |
| Arawakan                   |    2 |
| Armenian                   |    1 |
| Aslian                     |    1 |
| Athabaskan                 |    2 |
| Australian                 |    1 |
| Austroasiatic              |    2 |
| Austronesian               |    1 |
| Aymaran                    |    1 |
| Balto-Slavic               |    6 |
| Bantoid                    |    2 |
| Baraic                     |    1 |
| Barbacoan                  |    1 |
| Berber                     |    3 |
| Boran                      |    1 |
| Bulaka River               |    1 |
| Burmo-Quiangic             |    1 |
| Caddoan                    |    1 |
| Celtic                     |    3 |
| Chadic                     |    2 |
| Cherokee                   |    1 |
| Chibchan                   |    1 |
| Chimakuan                  |    2 |
| Chinantecan                |    1 |
| Chukchi-Kamchatkan         |    1 |
| Costanoan                  |    1 |
| Cushitic                   |    2 |
| Dravidian                  |    1 |
| East Timor                 |    1 |
| East Timor-Bunaq           |    1 |
| Egyptian                   |    4 |
| Eskimo                     |    2 |
| Eskimo-Aleut               |    2 |
| Finnic                     |    2 |
| Gbaya-Manza-Ngbaka         |    1 |
| Germanic                   |    4 |
| Graeco-Phrygian            |    4 |
| Guahiboan                  |    1 |
| Guianan                    |    1 |
| Gunwinyguan                |    1 |
| Gur                        |    1 |
| Himalayish                 |    1 |
| Hlaic                      |    2 |
| Huavean                    |    1 |
| Hurro-Urartian             |    2 |
| Ijo                        |    1 |
| Indo-European              |    2 |
| Indo-Iranian               |    2 |
| Iranian                    |    3 |
| Iroquoian                  |    4 |
| Isolate                    |    6 |
| Italic                     |    1 |
| Iwaidjan                   |    1 |
| Jabuti                     |    1 |
| Japonic                    |    1 |
| Je                         |    1 |
| Kadaic                     |    2 |
| Kainantu-Goroka            |    1 |
| Kam-Tai                    |    3 |
| Karenic                    |    1 |
| Kartvelian                 |    2 |
| Katuic                     |    1 |
| Keresan                    |    2 |
| Khantyic                   |    1 |
| Khoe                       |    2 |
| Kiowa-Tanoan               |    2 |
| Koiarian                   |    1 |
| Koiaric                    |    1 |
| Koman                      |    1 |
| Kuki-Chin-Naga             |    1 |
| Kwa Volta-Congo            |    2 |
| Lakes Plain                |    1 |
| Lakkia-Biao                |    1 |
| Lolo-Burmese               |    1 |
| Lower Sepik                |    1 |
| Maban                      |    1 |
| Maiduan                    |    2 |
| Malayo-Polynesian          |   13 |
| Mande                      |    2 |
| Mansic                     |    1 |
| Marind-Boazi-Yaqai         |    2 |
| Maweti-Guarani             |    1 |
| Mayan                      |    2 |
| Micronesian                |    1 |
| Miwok-Costanoan            |    1 |
| Miwokan                    |    1 |
| Mixtec                     |    1 |
| Mongolic-Khitan            |    1 |
| Monic                      |    1 |
| Mundaric                   |    1 |
| Muskogean                  |    1 |
| Nicobaric                  |    1 |
| Nilo-Saharan               |    1 |
| Nilotic                    |    4 |
| North Halmahera            |    1 |
| North Iroquoian            |    1 |
| Northern Iroquoian         |    2 |
| Nostratic                  |    1 |
| Nubian                     |    1 |
| Nuclear Trans New Guinea   |    2 |
| Nyulnyulan                 |    1 |
| Ob-Ugric                   |    2 |
| Otomanguean                |    1 |
| Otomian                    |    1 |
| Palaihnihan                |    1 |
| Pama-Nyungan               |    1 |
| Paman                      |    2 |
| Paulaungic                 |    1 |
| Pearic                     |    1 |
| Permian                    |    1 |
| Pomoan                     |    1 |
| Popolocan-Mazatecan        |    1 |
| Proto-Dené–Caucasian       |    1 |
| Proto-Inland Gulf of Papua |    1 |
| Quechuan                   |    1 |
| Quichean-Mamean            |    1 |
| Saamic                     |    2 |
| Salishan                   |    2 |
| Samoyedic                  |    2 |
| Sara-Bongo-Bagirmi         |    1 |
| Semitic                    |    9 |
| Sinitic                    |    1 |
| Siouan                     |    1 |
| Skou-Serra-Piore           |    1 |
| South-West Pama-Nyungan    |    1 |
| Tacanan                    |    1 |
| Tariku                     |    2 |
| Teluguic                   |    1 |
| Tibeto-Burman              |    2 |
| Timor-Alor-Pantar          |    2 |
| Tirio                      |    1 |
| Tlapanec-Manguean          |    1 |
| Tokharian                  |    1 |
| Tol                        |    1 |
| Totonacan                  |    2 |
| Totozoquean                |    1 |
| Tsimshian                  |    1 |
| Tucanoan                   |    2 |
| Tupi-Guarani               |    2 |
| Turkic                     |    1 |
| Unclassifiable             |    1 |
| Uralic                     |    7 |
| Uralo-Siberian             |    1 |
| Uto-Aztecan                |    2 |
| Vietic                     |    2 |
| Volta-Congo                |    3 |
| Waikuruan (Guaicuruan)     |    1 |
| Wintuan                    |    1 |
| Yokutsan                   |    2 |
| Zapotecan                  |    2 |
| Zoque                      |    2 |

And the same for the root level language families.

    table(metadata$LanguageFamilyRoot) %>% kable()

| Var1                     | Freq |
|:-------------------------|-----:|
| Afro-Asiatic             |   18 |
| Afroasiatic              |    3 |
| Ainu                     |    1 |
| Algonquian               |    2 |
| Alor-Pantor              |    1 |
| Altaic                   |    1 |
| Anim                     |    5 |
| Arawakan                 |    2 |
| Athabaskan-Eyak-Tlingit  |    2 |
| Atlantic-Congo           |    9 |
| Austoasiatic             |    1 |
| Australian               |    1 |
| Austroasiatic            |   10 |
| Austronesian             |   15 |
| Aymaran                  |    1 |
| Barbacoan                |    1 |
| Boran                    |    1 |
| Bulaka River             |    1 |
| Caddoan                  |    1 |
| Cariban                  |    1 |
| Central Sudanic          |    1 |
| Chibchan                 |    1 |
| Chimakuan                |    2 |
| Chukchi-Kamchatkan       |    1 |
| Dravidian                |    2 |
| Eskimo-Aleut             |    5 |
| Guahiboan                |    1 |
| Gunwinyguan              |    1 |
| Huavean                  |    1 |
| Hurro-Urartian           |    2 |
| Ijoid                    |    1 |
| Indo-European            |   33 |
| Iroquoian                |    8 |
| Isolate                  |    6 |
| Iwaidjan                 |    1 |
| Japonic                  |    1 |
| Jicaquean                |    1 |
| Kartvelian               |    2 |
| Keresan                  |    2 |
| Khoe-Kwadi               |    2 |
| Kiowa-Tanoan             |    2 |
| Koiarian                 |    3 |
| Koman                    |    1 |
| Lakes Plain              |    3 |
| Lower Sepik-Ramu         |    1 |
| Maban                    |    1 |
| Maiduan                  |    2 |
| Mande                    |    2 |
| Mayan                    |    3 |
| Miwok-Costanoan          |    3 |
| Mixe-Zoque               |    2 |
| Mongolic                 |    1 |
| Muskogean                |    1 |
| Nilo-Saharan             |    1 |
| Nilotic                  |    4 |
| North Halmahera          |    1 |
| Nostratic                |    1 |
| Nubian                   |    1 |
| Nuclear Macro-Je         |    2 |
| Nuclear Trans New Guinea |    3 |
| Nyulnyulan               |    1 |
| Otomanguean              |    8 |
| Palaihnihan              |    1 |
| Pama-Nyungan             |    4 |
| Pano-Tacanan             |    1 |
| Pomoan                   |    1 |
| Proto-Dené–Caucasian     |    1 |
| Quechuan                 |    1 |
| Salishan                 |    2 |
| Sino-Tibetan             |    8 |
| Siouan                   |    1 |
| Sko                      |    1 |
| Tai-Kadai                |    8 |
| Timor-Alor-Pantar        |    4 |
| Totonacan                |    2 |
| Totozoquean              |    1 |
| Tsimshian                |    1 |
| Tucanoan                 |    2 |
| Tupian                   |    3 |
| Turkic                   |    1 |
| Unclassificable          |    1 |
| Uralic                   |   18 |
| Uralo-Siberian           |    1 |
| Uto-Aztecan              |    2 |
| Waikuruan (Guaicuruan)   |    1 |
| Wintuan                  |    1 |
| Yokutsan                 |    2 |

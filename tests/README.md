Data checks for BDPROTO
================
Steven Moran
(01 October, 2022)

Load libraries.

``` r
library(tidyverse)
library(testthat)
library(bib2df)
library(knitr)
```

Load BDPROTO data.

``` r
metadata <- read_csv('../src/BDPROTO metadata - bdproto_metadata.csv')
bdproto <- read_csv('../bdproto.csv')
```

Make sure there are no duplicate phonemes.

``` r
dups <- bdproto %>% group_by(BdprotoID, Glottocode, Phoneme) %>% filter(n()>1) %>% select(BdprotoID, Glottocode, Phoneme)
expect_equal(nrow(dups), 0)
```

Check the bibliography.

``` r
path <- '../sources.bib'
bib <- bib2df(path)
```

Some entries have multiple comma separated IDs in the metadata table.
Split them and get a list of all IDs.

``` r
keys <- metadata$BibtexKey
split_keys <- str_split(keys, ",")
split_keys <- split_keys %>% unlist()
split_keys <- str_trim(split_keys)
```

Which bibtex keys in the metadata do not match the keys in the bibtex
file?

``` r
unique(split_keys[which(!(split_keys %in% bib$BIBTEXKEY))])
```

    ## [1] NA

``` r
x <- unique(split_keys[which(!(split_keys %in% bib$BIBTEXKEY))])
# metadata %>% select(BibtexKey, Source) %>% filter(!(BibtexKey %in% split_keys))
```

Which are the bibtex file that are not in the BDPROTO data? Some of
these are included in the `Comments` field.

``` r
bib[which(!(bib$BIBTEXKEY %in% split_keys)),] %>% select(BIBTEXKEY) %>% arrange(BIBTEXKEY)
```

    ## # A tibble: 59 × 1
    ##    BIBTEXKEY                
    ##    <chr>                    
    ##  1 aikhenvald2014global     
    ##  2 andersen2003language     
    ##  3 antonsen2002runes        
    ##  4 Balee2000                
    ##  5 baugh1993history         
    ##  6 bellwood2007prehistory   
    ##  7 bengtson2008materials    
    ##  8 black1980                
    ##  9 bomhard2008reconstructing
    ## 10 Bouckaert_etal2018       
    ## # … with 49 more rows

All accounted for?

``` r
# expect_equal(nrow(metadata[which(!(split.keys %in% bib$BIBTEXKEY)),]), 0)
```

Matches both ways?

``` r
which(!(bib$BIBTEXKEY %in% split_keys))
```

    ##  [1]  34  70  71 101 102 105 106 107 108 112 114 115 117 119 122 124 125 131 133
    ## [20] 136 137 144 145 146 147 148 152 154 155 158 160 163 164 169 172 175 178 183
    ## [39] 184 196 197 200 207 208 209 212 217 218 219 221 224 230 231 236 237 239 240
    ## [58] 241 242

Do the Glottocodes follow the correct format in the metadata?

``` r
glottocode <- "([a-z0-9]{4})([0-9]{4})"
expect_equal(length(which(!(str_detect(metadata$Glottocode, glottocode)))), 0)
which(!(str_detect(metadata$Glottocode, glottocode)))
```

    ## integer(0)

``` r
metadata[which(!(str_detect(metadata$Glottocode, glottocode))), ]
```

    ## # A tibble: 0 × 21
    ## # … with 21 variables: BdprotoID <dbl>, LanguageName <chr>,
    ## #   SourceLanguageName <chr>, LanguageFamily <chr>, LanguageFamilyRoot <chr>,
    ## #   Glottocode <chr>, FamilyID <chr>, Type <chr>, Macroarea <chr>, Dates <chr>,
    ## #   DatesSource <chr>, InventoryType <chr>, TimeDepth <chr>,
    ## #   TimeDepthYBP <dbl>, HomelandLatitude <dbl>, HomelandLongitude <dbl>,
    ## #   HomelandSource <chr>, HomelandComments <chr>, BibtexKey <chr>,
    ## #   Source <chr>, Comments <chr>

Check whether the segments in SegBo are also reported in
[PHOIBLE](https://phoible.org). At the current time, this rhotic segment
reported by Mahanta (2012) in Assamese (ID 285, assa1263) is under
investigation (it is reported as a aspirated rhotic from Sanskrit).

``` r
phoible <- read_csv('https://raw.githubusercontent.com/phoible/dev/master/data/phoible.csv')
phoible_segments <- phoible %>% select(Phoneme) %>% distinct()
bdproto_phonemes <- bdproto %>% select(Phoneme) %>% distinct()
bdproto_phonemes[which(!(bdproto_phonemes$Phoneme %in% phoible_segments$Phoneme)),]
```

    ## # A tibble: 164 × 1
    ##    Phoneme
    ##    <chr>  
    ##  1 xʷʲ    
    ##  2 i̝      
    ##  3 u̝      
    ##  4 ǁ      
    ##  5 ǀ      
    ##  6 ǂ      
    ##  7 ǂ͇      
    ##  8 ǁ̟      
    ##  9 dʰ     
    ## 10 mʰ     
    ## # … with 154 more rows

Let’s figure out where those non-conventional phonemes come from.

``` r
ncp <- bdproto_phonemes[which(!(bdproto_phonemes$Phoneme %in% phoible_segments$Phoneme)),]
bdproto %>% filter(Phoneme %in% ncp$Phoneme) %>% arrange(Phoneme) %>% select(BdprotoID, Source, SourceLanguageName, Phoneme, PhonemeNotes, Allophone) %>% kable()
```

| BdprotoID | Source  | SourceLanguageName       | Phoneme | PhonemeNotes                                                                                                                                                                                      | Allophone |
|----------:|:--------|:-------------------------|:--------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------|
|        46 | HUJI    | Proto-Ersuic             | (w)æ    | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | (w)ɑ    | NA                                                                                                                                                                                                | NA        |
|        49 | HUJI    | Proto-Nilotic            | ä       | ask Dimmendaal                                                                                                                                                                                    | NA        |
|        55 | HUJI    | Proto-Tupi-Guarani       | ã       | NA                                                                                                                                                                                                | NA        |
|        56 | HUJI    | Proto-Maweti-Guarani     | ã       | NA                                                                                                                                                                                                | NA        |
|        57 | HUJI    | Proto-Jabuti             | ã       | NA                                                                                                                                                                                                | NA        |
|        58 | HUJI    | Proto-Je                 | ã       | NA                                                                                                                                                                                                | NA        |
|        83 | HUJI    | Proto-Siouan             | ã       | NA                                                                                                                                                                                                | NA        |
|      1009 | BDPROTO | TANO CONGO               | ã̘       | NA                                                                                                                                                                                                | NA        |
|      1060 | BDPROTO | EDOID                    | a̘       | NA                                                                                                                                                                                                | NA        |
|      1043 | BDPROTO | ONGAMO MAA               | a̘       | NA                                                                                                                                                                                                | NA        |
|      1009 | BDPROTO | TANO CONGO               | a̘       | NA                                                                                                                                                                                                | NA        |
|       116 | HUJI    | Proto-Keresan            | ḁ       | note the rare voiceless vowels                                                                                                                                                                    | NA        |
|        43 | HUJI    | Proto-Germanic           | ãː      | NA                                                                                                                                                                                                | NA        |
|        56 | HUJI    | Proto-Maweti-Guarani     | ãː      | NA                                                                                                                                                                                                | NA        |
|        83 | HUJI    | Proto-Siouan             | ãː      | NA                                                                                                                                                                                                | NA        |
|      1063 | BDPROTO | LOWER SEPIK              | aj      | NA                                                                                                                                                                                                | NA        |
|         6 | UZ      | Proto-Tai                | aɰ      | falling diphtong                                                                                                                                                                                  | NA        |
|      1063 | BDPROTO | LOWER SEPIK              | aw      | NA                                                                                                                                                                                                | NA        |
|        11 | UZ      | Proto-Tibeto-Burman      | ɑːi     | NA                                                                                                                                                                                                | NA        |
|        11 | UZ      | Proto-Tibeto-Burman      | ɑːu     | NA                                                                                                                                                                                                | NA        |
|      1060 | BDPROTO | EDOID                    | bʰ      | NA                                                                                                                                                                                                | NA        |
|      1051 | BDPROTO | INDO-EUROPEAN            | bʰ      | NA                                                                                                                                                                                                | NA        |
|        15 | UZ      | Indo-European            | bʰ      | NA                                                                                                                                                                                                | NA        |
|        33 | HUJI    | Proto-Indo-Iranian       | b̤ʰ      | NA                                                                                                                                                                                                | NA        |
|       148 | HUJI    | Proto-Nilo-Saharan       | c̟ʰ      | written as a “tʰ” with a dot under                                                                                                                                                                | NA        |
|       153 | HUJI    | Old Egyptian             | çˀ      | possibly affricate                                                                                                                                                                                | NA        |
|       148 | HUJI    | Proto-Nilo-Saharan       | c̟ʼ      | written as a “tʼ” with a dot under                                                                                                                                                                | NA        |
|        66 | HUJI    | Proto-Tukanoan           | ɕ̰       | laryngealized alveo-palatal                                                                                                                                                                       | NA        |
|        82 | HUJI    | Proto-Finno-Saamic       | ɕʲ      | Source lists it as ʃʲ, but it is described as palato-alveolar                                                                                                                                     | NA        |
|        84 | HUJI    | Proto-Finno-Permic       | ɕʲ      | Source lists it as ʃʲ, but it is described as palato-alveolar                                                                                                                                     | NA        |
|        82 | HUJI    | Proto-Finno-Saamic       | ɕʲː     | Source lists it as ʃʲ:, but it is described as palato-alveolar                                                                                                                                    | NA        |
|      1056 | BDPROTO | CENTRAL-KHOISAN          | dʰ      | NA                                                                                                                                                                                                | NA        |
|      1060 | BDPROTO | EDOID                    | dʰ      | NA                                                                                                                                                                                                | NA        |
|      1051 | BDPROTO | INDO-EUROPEAN            | dʰ      | NA                                                                                                                                                                                                | NA        |
|        15 | UZ      | Indo-European            | dʰ      | NA                                                                                                                                                                                                | NA        |
|        33 | HUJI    | Proto-Indo-Iranian       | d̤ʰ      | NA                                                                                                                                                                                                | NA        |
|      1065 | BDPROTO | EARLY PROTO FINNIC       | ð̪ʲ      | NA                                                                                                                                                                                                | NA        |
|      1068 | BDPROTO | FINNO-UGRIC              | ð̪ʲ      | NA                                                                                                                                                                                                | NA        |
|      1089 | BDPROTO | OB UGRIC                 | ð̪ʲ      | NA                                                                                                                                                                                                | NA        |
|      1084 | BDPROTO | URALIC                   | ð̪ʲ      | NA                                                                                                                                                                                                | NA        |
|      1114 | BDPROTO | URALO-SIBERIAN           | ð̪ʲ      | NA                                                                                                                                                                                                | NA        |
|        50 | HUJI    | Proto-Eastern Nilotic    | dy      | described as postalveolar stops, ask Dimmendaal                                                                                                                                                   | NA        |
|        33 | HUJI    | Proto-Indo-Iranian       | d̠ʓʰ     | NA                                                                                                                                                                                                | NA        |
|      1090 | BDPROTO | FINNO-PERMIC             | ð̪ʼ      | NA                                                                                                                                                                                                | NA        |
|      2002 | ANE     | Ancient North Arabian    | ðˤː     | only in intervocalic position                                                                                                                                                                     | NA        |
|        46 | HUJI    | Proto-Ersuic             | ẽ       | NA                                                                                                                                                                                                | NA        |
|        55 | HUJI    | Proto-Tupi-Guarani       | ẽ       | NA                                                                                                                                                                                                | NA        |
|        56 | HUJI    | Proto-Maweti-Guarani     | ẽ       | NA                                                                                                                                                                                                | NA        |
|        58 | HUJI    | Proto-Je                 | ẽ       | NA                                                                                                                                                                                                | NA        |
|        76 | HUJI    | Proto-Northern Iroquoian | ẽ       | NA                                                                                                                                                                                                | NA        |
|        77 | HUJI    | Proto-Tuscarora-Nottoway | ẽ       | NA                                                                                                                                                                                                | NA        |
|        56 | HUJI    | Proto-Maweti-Guarani     | ẽː      | NA                                                                                                                                                                                                | NA        |
|        76 | HUJI    | Proto-Northern Iroquoian | ẽː      | NA                                                                                                                                                                                                | NA        |
|        77 | HUJI    | Proto-Tuscarora-Nottoway | ẽː      | NA                                                                                                                                                                                                | NA        |
|       184 | HUJI    | Proto-Koiarian           | e1      | in source as “e-prime” – needed for correspondence set, no guess as to value                                                                                                                      | NA        |
|        46 | HUJI    | Proto-Ersuic             | ew      | NA                                                                                                                                                                                                | NA        |
|      1015 | BDPROTO | IJO                      | ə̘       | NA                                                                                                                                                                                                | NA        |
|        61 | HUJI    | Proto-Taranoan           | əe      | NA                                                                                                                                                                                                | NA        |
|      1058 | BDPROTO | KATUIC                   | əɛ      | NA                                                                                                                                                                                                | NA        |
|        38 | HUJI    | Proto-Tocharian          | ɜu      | NA                                                                                                                                                                                                | NA        |
|        69 | HUJI    | Proto-Tai                | ɤɯ      | Was written as <ɤɰ> – considering a typo.                                                                                                                                                         | NA        |
|         6 | UZ      | Proto-Tai                | ɤɰ      | falling diphtong                                                                                                                                                                                  | NA        |
|         7 | UZ      | Proto-Turkic             | ɡ̥       | weak and most probably also unvoiced                                                                                                                                                              | NA        |
|      1060 | BDPROTO | EDOID                    | ɡbʰ     | NA                                                                                                                                                                                                | NA        |
|      1060 | BDPROTO | EDOID                    | ɡʰ      | NA                                                                                                                                                                                                | NA        |
|      1051 | BDPROTO | INDO-EUROPEAN            | ɡʰ      | NA                                                                                                                                                                                                | NA        |
|        15 | UZ      | Indo-European            | ɡʰ      | NA                                                                                                                                                                                                | NA        |
|        33 | HUJI    | Proto-Indo-Iranian       | ɡ̈ʱ      | NA                                                                                                                                                                                                | NA        |
|      1051 | BDPROTO | INDO-EUROPEAN            | ɡʷʰ     | NA                                                                                                                                                                                                | NA        |
|        15 | UZ      | Indo-European            | ɡʷʰ     | NA                                                                                                                                                                                                | NA        |
|        15 | UZ      | Indo-European            | H1      | laryngeals; phonetic values still unknown                                                                                                                                                         | NA        |
|        15 | UZ      | Indo-European            | H2      | laryngeals; phonetic values still unknown                                                                                                                                                         | NA        |
|        15 | UZ      | Indo-European            | H3      | laryngeals; phonetic values still unknown                                                                                                                                                         | NA        |
|      1051 | BDPROTO | INDO-EUROPEAN            | ħh      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | ʰʈʂ     | Given with s in Yu 2012:15                                                                                                                                                                        | NA        |
|        52 | HUJI    | Proto-Kuki-Chin          | ʱr      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | ĩ       | NA                                                                                                                                                                                                | NA        |
|        55 | HUJI    | Proto-Tupi-Guarani       | ĩ       | NA                                                                                                                                                                                                | NA        |
|        56 | HUJI    | Proto-Maweti-Guarani     | ĩ       | NA                                                                                                                                                                                                | NA        |
|        57 | HUJI    | Proto-Jabuti             | ĩ       | NA                                                                                                                                                                                                | NA        |
|        58 | HUJI    | Proto-Je                 | ĩ       | NA                                                                                                                                                                                                | NA        |
|        83 | HUJI    | Proto-Siouan             | ĩ       | NA                                                                                                                                                                                                | NA        |
|      1094 | BDPROTO | BANTU                    | i̝       | NA                                                                                                                                                                                                | NA        |
|      1019 | BDPROTO | SABAKI                   | i̝       | NA                                                                                                                                                                                                | NA        |
|      1032 | BDPROTO | WEST TARIKU              | i̝       | NA                                                                                                                                                                                                | NA        |
|      1009 | BDPROTO | TANO CONGO               | ĩ̘       | NA                                                                                                                                                                                                | NA        |
|        62 | HUJI    | Proto-Totonacan          | ḭ       | Laryngealized vowels                                                                                                                                                                              | NA        |
|        43 | HUJI    | Proto-Germanic           | ĩː      | NA                                                                                                                                                                                                | NA        |
|        56 | HUJI    | Proto-Maweti-Guarani     | ĩː      | NA                                                                                                                                                                                                | NA        |
|        83 | HUJI    | Proto-Siouan             | ĩː      | NA                                                                                                                                                                                                | NA        |
|        62 | HUJI    | Proto-Totonacan          | ḭː      | Laryngealized vowels                                                                                                                                                                              | NA        |
|       184 | HUJI    | Proto-Koiarian           | i1      | in source as “i-prime” – needed for correspondence set, no guess as to value                                                                                                                      | NA        |
|      1089 | BDPROTO | OB UGRIC                 | ɨe      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | ja      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | je      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | jẽ      | NA                                                                                                                                                                                                | NA        |
|      1098 | BDPROTO | SALISH                   | jʼ      | NA                                                                                                                                                                                                | NA        |
|       114 | HUJI    | Proto-Yokutsan           | jʼ      | NA                                                                                                                                                                                                | NA        |
|        15 | UZ      | Indo-European            | ɟʰ      | NA                                                                                                                                                                                                | NA        |
|        33 | HUJI    | Proto-Indo-Iranian       | ɟ̈ʱ      | NA                                                                                                                                                                                                | NA        |
|       148 | HUJI    | Proto-Nilo-Saharan       | ʄ̟       | writte as a “ɗ” with a dot underneath. Described as prepalatal implosive voiced stop.                                                                                                             | NA        |
|       152 | HUJI    | Proto-Willaumez          | K       | NA                                                                                                                                                                                                | NA        |
|       101 | HUJI    | Proto-Semitic            | k’      | Also given as q                                                                                                                                                                                   | NA        |
|        52 | HUJI    | Proto-Kuki-Chin          | khl     | NA                                                                                                                                                                                                | NA        |
|        52 | HUJI    | Proto-Kuki-Chin          | khr     | NA                                                                                                                                                                                                | NA        |
|        52 | HUJI    | Proto-Kuki-Chin          | kr      | NA                                                                                                                                                                                                | NA        |
|       150 | HUJI    | Proto-Kimbe              | L       | I am not sure exactly what is meant by this symbol, perhaps an unspecified lateral?                                                                                                               | NA        |
|       152 | HUJI    | Proto-Willaumez          | L       | I am not sure what is meant by this symbol, possibly an unspesific lateral?                                                                                                                       | NA        |
|       163 | HUJI    | Proto-Zapotec            | L       | NA                                                                                                                                                                                                | NA        |
|       158 | HUJI    | Proto-Iwaidjan           | lɻ      | superscript approximant, “flapped lateral”                                                                                                                                                        | NA        |
|        50 | HUJI    | Proto-Eastern Nilotic    | ly      | NA                                                                                                                                                                                                | NA        |
|       101 | HUJI    | Proto-Semitic            | ɬ’      | NA                                                                                                                                                                                                | NA        |
|        91 | HUJI    | Proto-Salishan           | ɬʷˀ     | ɬʼ                                                                                                                                                                                                | NA        |
|       103 | HUJI    | Proto-Athabaskan         | ɬˀ      | given as tl’                                                                                                                                                                                      | NA        |
|       104 | HUJI    | Proto-Chimakuan          | ɬˀ      | NA                                                                                                                                                                                                | NA        |
|      2015 | ANE     | Old South Arabic         | ɬʼː     | NA                                                                                                                                                                                                | NA        |
|      2003 | ANE     | Aramaic                  | ɬˤ      | NA                                                                                                                                                                                                | NA        |
|        95 | HUJI    | Proto-Paman              | m̺       | apical                                                                                                                                                                                            | NA        |
|      1056 | BDPROTO | CENTRAL-KHOISAN          | mʰ      | NA                                                                                                                                                                                                | NA        |
|      1060 | BDPROTO | EDOID                    | mʰ      | NA                                                                                                                                                                                                | NA        |
|      1021 | BDPROTO | NEW CALEDONIAN           | mʷʼ     | NA                                                                                                                                                                                                | NA        |
|        48 | HUJI    | Proto-Central Chadic     | n̻d̻z̻     | described as laminal                                                                                                                                                                              | NA        |
|       136 | HUJI    | Proto-Southern-Cushitic  | ntʲ     | I am guessing this is meant to be palatal, or palatalized. t is witten as a something like “ntyʼ”, but the “y” is raised so that it’s tail rests at the same level as the bottom part of the “t”. | NA        |
|        92 | HUJI    | Proto-Khoe               | n̥ǀ      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | n̥ǁ      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | nǂ      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | n̥ǂ      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | nǃ      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | n̥ǃ      | NA                                                                                                                                                                                                | NA        |
|       116 | HUJI    | Proto-Keresan            | ɲˀ      | NA                                                                                                                                                                                                | NA        |
|      1098 | BDPROTO | SALISH                   | ŋʷʼ     | NA                                                                                                                                                                                                | NA        |
|       114 | HUJI    | Proto-Yokutsan           | ŋʼ      | “The segments in parentheses may have been marginal; it is difficult to compile convincing cognate sets for them.”                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | õ       | NA                                                                                                                                                                                                | NA        |
|        55 | HUJI    | Proto-Tupi-Guarani       | õ       | NA                                                                                                                                                                                                | NA        |
|        56 | HUJI    | Proto-Maweti-Guarani     | õ       | NA                                                                                                                                                                                                | NA        |
|        57 | HUJI    | Proto-Jabuti             | õ       | NA                                                                                                                                                                                                | NA        |
|        58 | HUJI    | Proto-Je                 | õ       | NA                                                                                                                                                                                                | NA        |
|        76 | HUJI    | Proto-Northern Iroquoian | õ       | NA                                                                                                                                                                                                | NA        |
|        77 | HUJI    | Proto-Tuscarora-Nottoway | õ       | NA                                                                                                                                                                                                | NA        |
|       116 | HUJI    | Proto-Keresan            | o̥       | note the rare voiceless vowels                                                                                                                                                                    | NA        |
|        56 | HUJI    | Proto-Maweti-Guarani     | õː      | NA                                                                                                                                                                                                | NA        |
|        76 | HUJI    | Proto-Northern Iroquoian | õː      | NA                                                                                                                                                                                                | NA        |
|        77 | HUJI    | Proto-Tuscarora-Nottoway | õː      | NA                                                                                                                                                                                                | NA        |
|       184 | HUJI    | Proto-Koiarian           | o1      | in source as “i-prime” – needed for correspondence set, no guess as to value                                                                                                                      | NA        |
|      1021 | BDPROTO | NEW CALEDONIAN           | pːʷ     | NA                                                                                                                                                                                                | NA        |
|        52 | HUJI    | Proto-Kuki-Chin          | pl      | NA                                                                                                                                                                                                | NA        |
|        52 | HUJI    | Proto-Kuki-Chin          | pr      | ask Nathan                                                                                                                                                                                        | NA        |
|      2016 | ANE     | Sumerian                 | ř       | discussed and with unclear phonetic realisation, maybe even \[tsʰ\]                                                                                                                               | NA        |
|        46 | HUJI    | Proto-Ersuic             | ræ      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | rɑ      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | rd      | NA                                                                                                                                                                                                | NA        |
|        50 | HUJI    | Proto-Eastern Nilotic    | rdʲ     | described as <rdy> what is this?                                                                                                                                                                  | NA        |
|        46 | HUJI    | Proto-Ersuic             | re      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | rɡ      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | ri      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | riu     | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | ro      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | ru      | NA                                                                                                                                                                                                | NA        |
|        99 | HUJI    | Proto-Mansi              | ṣ       | transcribed as ṣ                                                                                                                                                                                  | NA        |
|       101 | HUJI    | Proto-Semitic            | t’      | NA                                                                                                                                                                                                | NA        |
|         6 | UZ      | Proto-Tai                | T1      | Tone A                                                                                                                                                                                            | NA        |
|         9 | UZ      | Proto-Kra                | T1      | Tone A                                                                                                                                                                                            | NA        |
|        10 | UZ      | Proto-Hlai               | T1      | Tone A                                                                                                                                                                                            | NA        |
|        50 | HUJI    | Proto-Eastern Nilotic    | t2      | ask Dimmendaal                                                                                                                                                                                    | NA        |
|         6 | UZ      | Proto-Tai                | T2      | Tone B                                                                                                                                                                                            | NA        |
|         9 | UZ      | Proto-Kra                | T2      | Tone B                                                                                                                                                                                            | NA        |
|        10 | UZ      | Proto-Hlai               | T2      | Tone B                                                                                                                                                                                            | NA        |
|         6 | UZ      | Proto-Tai                | T3      | Tone C                                                                                                                                                                                            | NA        |
|         9 | UZ      | Proto-Kra                | T3      | Tone C                                                                                                                                                                                            | NA        |
|        10 | UZ      | Proto-Hlai               | T3      | Tone C                                                                                                                                                                                            | NA        |
|         9 | UZ      | Proto-Kra                | T4      | Tone D \[only in closed syllables\]                                                                                                                                                               | NA        |
|        10 | UZ      | Proto-Hlai               | T4      | Tone D                                                                                                                                                                                            | NA        |
|        82 | HUJI    | Proto-Finno-Saamic       | tɕʲ     | Source lists it as tʃʲ, but it is described as palato-alveolar                                                                                                                                    | NA        |
|        84 | HUJI    | Proto-Finno-Permic       | tɕʲ     | Source lists it as tʃʲ, but it is described as palato-alveolar                                                                                                                                    | NA        |
|        39 | HUJI    | Proto-Nuristani          | t̠s̠      | Postalveolar t (Kümmel 2007: V4)                                                                                                                                                                  | NA        |
|       100 | HUJI    | Proto-Samoyedic          | t̠s̠      | transcribed as ṭṣ – assuming this is Kuemmel, so updating it.                                                                                                                                     | NA        |
|       101 | HUJI    | Proto-Semitic            | ts’     | NA                                                                                                                                                                                                | NA        |
|       103 | HUJI    | Proto-Athabaskan         | t̠ʃʷˀ    | NA                                                                                                                                                                                                | NA        |
|      1052 | BDPROTO | KARTVELIAN               | tθʰ     | NA                                                                                                                                                                                                | NA        |
|      1052 | BDPROTO | KARTVELIAN               | t̪θ̪ʼ     | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | ũ       | NA                                                                                                                                                                                                | NA        |
|        55 | HUJI    | Proto-Tupi-Guarani       | ũ       | NA                                                                                                                                                                                                | NA        |
|        56 | HUJI    | Proto-Maweti-Guarani     | ũ       | NA                                                                                                                                                                                                | NA        |
|        57 | HUJI    | Proto-Jabuti             | ũ       | NA                                                                                                                                                                                                | NA        |
|        58 | HUJI    | Proto-Je                 | ũ       | check                                                                                                                                                                                             | NA        |
|        79 | HUJI    | Proto-Mohawk-Oneida      | ũ       | NA                                                                                                                                                                                                | NA        |
|        80 | HUJI    | Common Mohawk            | ũ       | NA                                                                                                                                                                                                | NA        |
|        83 | HUJI    | Proto-Siouan             | ũ       | NA                                                                                                                                                                                                | NA        |
|      1094 | BDPROTO | BANTU                    | u̝       | NA                                                                                                                                                                                                | NA        |
|      1019 | BDPROTO | SABAKI                   | u̝       | NA                                                                                                                                                                                                | NA        |
|      1032 | BDPROTO | WEST TARIKU              | u̝       | NA                                                                                                                                                                                                | NA        |
|      1009 | BDPROTO | TANO CONGO               | ũ̘       | NA                                                                                                                                                                                                | NA        |
|        62 | HUJI    | Proto-Totonacan          | ṵ       | Laryngealized vowels                                                                                                                                                                              | NA        |
|        43 | HUJI    | Proto-Germanic           | ũː      | NA                                                                                                                                                                                                | NA        |
|        56 | HUJI    | Proto-Maweti-Guarani     | ũː      | NA                                                                                                                                                                                                | NA        |
|        79 | HUJI    | Proto-Mohawk-Oneida      | ũː      | NA                                                                                                                                                                                                | NA        |
|        80 | HUJI    | Common Mohawk            | ũː      | NA                                                                                                                                                                                                | NA        |
|        83 | HUJI    | Proto-Siouan             | ũː      | NA                                                                                                                                                                                                | NA        |
|        62 | HUJI    | Proto-Totonacan          | ṵː      | Laryngealized vowels                                                                                                                                                                              | NA        |
|      1098 | BDPROTO | SALISH                   | ɰʷ      | NA                                                                                                                                                                                                | NA        |
|      1098 | BDPROTO | SALISH                   | ɰʼ      | NA                                                                                                                                                                                                | NA        |
|      1098 | BDPROTO | SALISH                   | ɰʼʷ     | NA                                                                                                                                                                                                | NA        |
|        83 | HUJI    | Proto-Siouan             | W       | funny w                                                                                                                                                                                           | NA        |
|        46 | HUJI    | Proto-Ersuic             | wE      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | wo      | NA                                                                                                                                                                                                | NA        |
|        46 | HUJI    | Proto-Ersuic             | wõ      | NA                                                                                                                                                                                                | NA        |
|       171 | HUJI    | Avestan                  | x̟       | front velar                                                                                                                                                                                       | NA        |
|      1110 | BDPROTO | ATHAPASKAN               | xʷʲ     | NA                                                                                                                                                                                                | NA        |
|       153 | HUJI    | Old Egyptian             | xˀ      | possibly affricate                                                                                                                                                                                | NA        |
|      1051 | BDPROTO | INDO-EUROPEAN            | ʕɦ      | NA                                                                                                                                                                                                | NA        |
|      1056 | BDPROTO | CENTRAL-KHOISAN          | ǀ       | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǀ       | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǀʰ      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǀx      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǀxʼ     | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǀʼ      | NA                                                                                                                                                                                                | NA        |
|      1056 | BDPROTO | CENTRAL-KHOISAN          | ǁ       | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǁ       | NA                                                                                                                                                                                                | NA        |
|      1056 | BDPROTO | CENTRAL-KHOISAN          | ǁ̟       | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǁʰ      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǁx      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǁxʼ     | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǁʼ      | NA                                                                                                                                                                                                | NA        |
|      1056 | BDPROTO | CENTRAL-KHOISAN          | ǂ       | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǂ       | NA                                                                                                                                                                                                | NA        |
|      1056 | BDPROTO | CENTRAL-KHOISAN          | ǂ͇       | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǂxʼ     | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǂʼ      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǃ       | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǃʰ      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǃx      | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǃxʼ     | NA                                                                                                                                                                                                | NA        |
|        92 | HUJI    | Proto-Khoe               | ǃʼ      | NA                                                                                                                                                                                                | NA        |
|       101 | HUJI    | Proto-Semitic            | θ’      | NA                                                                                                                                                                                                | NA        |
|      1080 | BDPROTO | SEMITIC                  | θ̪ʼ      | NA                                                                                                                                                                                                | NA        |
|      2015 | ANE     | Old South Arabic         | θʼː     | NA                                                                                                                                                                                                | NA        |
|      2002 | ANE     | Ancient North Arabian    | θˤ      | NA                                                                                                                                                                                                | NA        |
|      2003 | ANE     | Aramaic                  | θˤ      | NA                                                                                                                                                                                                | NA        |
|      2002 | ANE     | Ancient North Arabian    | θˤː     | only in intervocalic position                                                                                                                                                                     | NA        |

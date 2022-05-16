Data checks for BDPROTO
================
Steven Moran
(16 May, 2022)

Load libraries.

``` r
library(tidyverse)
library(testthat)
library(bib2df)
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

    ##  [1] "klamer2014"                   "holtonrobinson2014"          
    ##  [3] "Goddard1979"                  "Chafe1979"                   
    ##  [5] "Mandalaetal2011"              "Cerron2003"                  
    ##  [7] "Cerron2000"                   "curnow1998"                  
    ##  [9] "Austroasiatic_SidwellRau2015" NA                            
    ## [11] "kuemmel2007"                  "Kümmel2007"                  
    ## [13] "Mayrhofer1989"                "Kobayashi2004"               
    ## [15] "Lipp2009"                     "Hock2003a"                   
    ## [17] "Melchert1994a"                "Adams1988"                   
    ## [19] "Ringe1996"                    "Kim1999"                     
    ## [21] "Nelson1991"                   "Bartoněk1961"                
    ## [23] "Yu2012"                       "Jacques2017"                 
    ## [25] "Gravina2016"                  "Dimmendaal1988"              
    ## [27] "Vossen1982"                   "Rottland1982"                
    ## [29] "Hill2014"                     "Berge2018"                   
    ## [31] "MeiraDrude2015"               "RibeiroVandervoort2010"      
    ## [33] "Ultan1964"                    "Jolkesky2016"                
    ## [35] "Meira1998"                    "brown2011totozoquean.pdf"    
    ## [37] "CampbellOltrogge1980"         "Chacon2014"                  
    ## [39] "Tarpent1997"                  "Ostapirat2000"               
    ## [41] "Pittayaporn2009"              "Ostapirat2004"               
    ## [43] "KoosmannPC2018"               "Donohue2002"                 
    ## [45] "RankinEtAl2015"               "Hale1967"                    
    ## [47] "Sutton2014"                   "Alpher2004"                  
    ## [49] "sandalo1995"                  "Vossen1997"                  
    ## [51] "GueldemannElderkin2010"       "hale1966"                    
    ## [53] "Bergsland1986"                "KraussGolla1981"             
    ## [55] "Kraus1979"                    "CookRice1989"                
    ## [57] "Powell1993"                   "Berman1990"                  
    ## [59] "Shipley1970"                  "Cahallagan1967"              
    ## [61] "Callghan1967"                 "Callghan1997"                
    ## [63] "suarez1975"                   "CampbellKaufman1985"         
    ## [65] "ehret1980"                    "sidwellrau2014"              
    ## [67] "Ehret 2001"                   "goodenough1997"              
    ## [69] "kammerzell1998"               "goodetal2003"                
    ## [71] "Mead1998"                     "Austin1981"                  
    ## [73] "MailhammerHarvey2018"         "StokesMcGregor"              
    ## [75] "Huehnegard2007"               "Geraghty1983"                
    ## [77] "Bender1983"                   "Suarez 1973"                 
    ## [79] "SeifartEcheverri2015"         "harvey2003"                  
    ## [81] "woodward2008attic"            "clackson2008"                
    ## [83] "wallace2008oscan"             "hale2008avestan"             
    ## [85] "hale2008pahlavi"              "bricker2008mayan"            
    ## [87] "tuite2008georgian"            "usher2020"                   
    ## [89] "ushersuter2015"               "usher2014"                   
    ## [91] "dutton2010"                   "gregersonhartzler1987"       
    ## [93] "ogrady1966"                   "mcgregorrumsey2009"

``` r
x <- unique(split_keys[which(!(split_keys %in% bib$BIBTEXKEY))])
# metadata %>% select(BibtexKey, Source) %>% filter(!(BibtexKey %in% split_keys))
```

Which are the bibtex file that are not in the BDPROTO data? Some of
these are included in the `Comments` field.

``` r
bib[which(!(bib$BIBTEXKEY %in% split_keys)),] %>% select(BIBTEXKEY) %>% arrange(BIBTEXKEY)
```

    ## # A tibble: 58 × 1
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
    ## # … with 48 more rows

All accounted for?

``` r
# expect_equal(nrow(metadata[which(!(split.keys %in% bib$BIBTEXKEY)),]), 0)
```

Matches both ways?

``` r
which(!(bib$BIBTEXKEY %in% split_keys))
```

    ##  [1]   1   2  32  33  36  37  38  39  43  45  46  48  50  53  55  57  62  64  67
    ## [20]  68  75  76  77  78  79  83  85  86  89  91  94  95 100 103 106 109 114 115
    ## [39] 127 128 131 138 139 140 143 148 149 150 152 155 161 162 167 168 170 171 172
    ## [58] 173

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

    ## # A tibble: 169 × 1
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
    ## # … with 159 more rows

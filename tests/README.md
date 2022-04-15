Data checks for BDPROTO
================
Steven Moran
(15 April, 2022)

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

    ##  [1] NA                             "kammerzell1998"              
    ##  [3] "KoosmannPC2018"               "Gravina2016"                 
    ##  [5] "Huehnegard2007"               "ehret1980"                   
    ##  [7] "Goddard1979"                  "ushersuter2015"              
    ##  [9] "Jolkesky2016"                 "KraussGolla1981"             
    ## [11] "Kraus1979"                    "CookRice1989"                
    ## [13] "Austroasiatic_SidwellRau2015" "sidwellrau2014"              
    ## [15] "Mead1998"                     "Geraghty1983"                
    ## [17] "goodenough1997"               "Cerron2000"                  
    ## [19] "curnow1998"                   "SeifartEcheverri2015"        
    ## [21] "usher2014"                    "Chafe1979"                   
    ## [23] "Meira1998"                    "Powell1993"                  
    ## [25] "Berge2018"                    "Bergsland1986"               
    ## [27] "harvey2003"                   "suarez1975"                  
    ## [29] "Hock2003a"                    "Kümmel2007"                  
    ## [31] "Melchert1994a"                "kuemmel2007"                 
    ## [33] "Bartoněk1961"                 "Mayrhofer1989"               
    ## [35] "Kobayashi2004"                "Lipp2009"                    
    ## [37] "Nelson1991"                   "Adams1988"                   
    ## [39] "Ringe1996"                    "Kim1999"                     
    ## [41] "woodward2008attic"            "clackson2008"                
    ## [43] "wallace2008oscan"             "hale2008avestan"             
    ## [45] "hale2008pahlavi"              "MailhammerHarvey2018"        
    ## [47] "CampbellOltrogge1980"         "tuite2008georgian"           
    ## [49] "Vossen1997"                   "GueldemannElderkin2010"      
    ## [51] "Hale1967"                     "Sutton2014"                  
    ## [53] "dutton2010"                   "Bender1983"                  
    ## [55] "Ultan1964"                    "CampbellKaufman1985"         
    ## [57] "bricker2008mayan"             "Cahallagan1967"              
    ## [59] "Callghan1967"                 "brown2011totozoquean.pdf"    
    ## [61] "Ehret 2001"                   "Dimmendaal1988"              
    ## [63] "Vossen1982"                   "Rottland1982"                
    ## [65] "holtonrobinson2014"           "RibeiroVandervoort2010"      
    ## [67] "usher2020"                    "StokesMcGregor"              
    ## [69] "Suarez 1973"                  "goodetal2003"                
    ## [71] "Austin1981"                   "Alpher2004"                  
    ## [73] "hale1966"                     "ogrady1966"                  
    ## [75] "Cerron2003"                   "gregersonhartzler1987"       
    ## [77] "Yu2012"                       "Jacques2017"                 
    ## [79] "Hill2014"                     "RankinEtAl2015"              
    ## [81] "Donohue2002"                  "Ostapirat2004"               
    ## [83] "Ostapirat2000"                "Pittayaporn2009"             
    ## [85] "Berman1990"                   "Shipley1970"                 
    ## [87] "klamer2014"                   "Mandalaetal2011"             
    ## [89] "Tarpent1997"                  "Chacon2014"                  
    ## [91] "MeiraDrude2015"               "sandalo1995"                 
    ## [93] "mcgregorrumsey2009"           "Callghan1997"

``` r
x <- unique(split_keys[which(!(split_keys %in% bib$BIBTEXKEY))])
# metadata %>% select(BibtexKey, Source) %>% filter(!(BibtexKey %in% split_keys))
```

Which are the bibtex file that are not in the BDPROTO data? Some of
these are included in the `Comments` field.

``` r
bib[which(!(bib$BIBTEXKEY %in% split_keys)),] %>% select(BIBTEXKEY) %>% arrange(BIBTEXKEY)
```

    ## # A tibble: 57 × 1
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
    ## 10 brown2010concise         
    ## # … with 47 more rows

All accounted for?

``` r
# expect_equal(nrow(metadata[which(!(split.keys %in% bib$BIBTEXKEY)),]), 0)
```

Matches both ways?

``` r
which(!(bib$BIBTEXKEY %in% split_keys))
```

    ##  [1]   1  31  32  35  36  37  38  42  44  45  47  49  52  54  56  61  63  66  67
    ## [20]  74  75  76  77  78  82  84  85  88  90  93  94  99 102 105 108 113 114 126
    ## [39] 127 130 137 138 139 142 147 148 149 151 154 160 161 166 167 169 170 171 172

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

    ## # A tibble: 0 × 19
    ## # … with 19 variables: BdprotoID <dbl>, LanguageName <chr>,
    ## #   SourceLanguageName <chr>, LanguageFamily <chr>, LanguageFamilyRoot <chr>,
    ## #   Glottocode <chr>, FamilyID <chr>, Type <chr>, Macroarea <chr>, Dates <chr>,
    ## #   DatesSource <chr>, InventoryType <chr>, TimeDepth <chr>,
    ## #   TimeDepthYBP <dbl>, Homeland <chr>, HomelandSource <chr>, BibtexKey <chr>,
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

    ## # A tibble: 153 × 1
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
    ## # … with 143 more rows

BDPROTO aggregation script
================
Steven Moran

15 April, 2022

# Overview

This script aggregates the raw data sources in BDPROTO into single CSV
file..

In BDPROTO versions 1.0 and 1.1, we integrated separate metadata for
each raw data source (`bdproto-original`, `uz`, `huji`, and
`ancient-near-east`). To make things easier to maintain and process, we
extracted the metadata fields pertinent to all source inventories into a
separate CSV file, which we then aggregated into the combined raw data
sources.

``` r
library(tidyverse)
library(stringi)
library(knitr)
library(testthat)
```

# Metadata

Read in the metadata. It’s stored in a Google sheet for editors.

``` r
metadata <- read_csv('BDPROTO metadata - bdproto_metadata.csv')
```

Let’s do some tests to make sure things like Glottolog glottocodes are
valid. First load the Glottolog’s languiods data.

``` r
glottolog <- read_csv('glottolog_languoid.csv/languoid.csv')
```

Then make sure all BDPROTO glottocodes are represented in that file.
Note that we have a bunch of NAs (we know there exists no glottocode for
these languages). These should all be NA.

``` r
metadata$Glottocode[which(!(metadata$Glottocode %in% glottolog$id))]
```

    ##  [1] NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA

There should be no NAs in several fields in the metadata.

``` r
expect_false(any(is.na(metadata$LanguageName)))
expect_false(any(is.na(metadata$LanguageFamily)))
expect_false(any(is.na(metadata$LanguageFamilyRoot)))
```

We can uncomment this code to eyeball the canonical language names,
families, and roots for typos.

``` r
# table(metadata$LanguageName) %>% kable()
# table(metadata$LanguageFamily) %>% kable()
# table(metadata$LanguageFamilyRoot) %>% kable()
```

# Load and merge raw data sources

Load the original bdproto data.

``` r
bdproto <- read_csv('bdproto-original/bdproto-inventories.csv')
expect_equal(nrow(bdproto), 2862)
```

Load the inventories from the `UZ` source.

``` r
uz <- read_csv("uz/uz-inventories.csv")
expect_equal(nrow(uz), 424)
```

Load the ancient-near-east (ANE) inventories

``` r
ane <- read_csv('ancient-near-east/AnNeEa-inventories.csv')
expect_equal(nrow(ane), 684)
```

ANE is a slightly different format. It has blank rows between
inventories and the field for IDs and names do not repeat. Let’s remove
or fill those in.

``` r
dim(ane[rowSums(is.na(ane)) == ncol(ane), ])
```

    ## [1] 20  7

``` r
ane <- ane[rowSums(is.na(ane)) != ncol(ane), ]
rownames(ane) <- NULL
```

This should be zero.

``` r
expect_equal(nrow(ane[rowSums(is.na(ane)) == ncol(ane), ]), 0)
```

Fill in the blank ANE cells.

``` r
ane <- ane %>% fill(BdprotoID)
ane <- ane %>% fill(SourceLanguageName)
ane <- ane %>% fill(SpecificDialect)
```

The result has less rows.

``` r
expect_equal(nrow(ane), 664)
```

Load the HUJI Inventories.

``` r
huji <- read_csv('huji/BDPROTO Jerusalem - Inventories.csv')
expect_equal(nrow(huji), 3930)
```

Merge the three inventory data sources together.

``` r
all_sources <- bind_rows(bdproto, uz, ane, huji) %>% ungroup()
rownames(all_sources) <- NULL
```

The concatenation should reflect the same number of rows combined above.

``` r
expect_equal(nrow(all_sources), (nrow(bdproto) + nrow(uz) + nrow(ane) + nrow(huji)))
```

Make sure everything important is in the inventories and the metadata
before merging them.

``` r
expect_true(all(all_sources$BdprotoID %in% metadata$BdprotoID))
expect_true(all(metadata$BdprotoID %in% all_sources$BdprotoID))
expect_true(all(all_sources$SourceLanguageName %in% metadata$SourceLanguageName))
expect_true(all(metadata$SourceLanguageName %in% all_sources$SourceLanguageName))

# If something fails, adapt this code to find out what:
# metadata[which(!(metadata$BdprotoID %in% all_sources$BdprotoID)),]
```

And merge in the metadata.

``` r
inventories <- left_join(all_sources, metadata, by = c("BdprotoID" = "BdprotoID", "SourceLanguageName" = "SourceLanguageName"))
```

How’s it look?

``` r
inventories %>% head() %>% kable()
```

| BdprotoID | SourceLanguageName | SourceLanguageFamily | Phoneme | PhonemeNotes | Allophone | AllophoneNotes | SpecificDialect | Variants | LowconfidencePhonemic | LowconfidencePhonetic | LanguageName       | LanguageFamily | LanguageFamilyRoot | Glottocode | FamilyID | Type          | Macroarea | Dates | DatesSource | InventoryType | TimeDepth                                     | TimeDepthYBP | HomelandLatitude | HomelandLongitude | HomelandSource    | HomelandComments | BibtexKey               | Source  | Comments |
|----------:|:-------------------|:---------------------|:--------|:-------------|:----------|:---------------|:----------------|:---------|:----------------------|:----------------------|:-------------------|:---------------|:-------------------|:-----------|:---------|:--------------|:----------|:------|:------------|:--------------|:----------------------------------------------|-------------:|-----------------:|------------------:|:------------------|:-----------------|:------------------------|:--------|:---------|
|      1061 | AFRO-ASIATIC       | Afro-Asiatic         | ʕ       | NA           | NA        | NA             | NA              | NA       | NA                    | NA                    | Proto-Afro-Asiatic | Afro-Asiatic   | Afro-Asiatic       | afro1255   | afro1255 | Reconstructed | Africa    | NA    | NA          | all           | 9th-8th millenia B.C. (diakonoff1988afrasian) |        10000 |             8.67 |              8.08 | Wichmann_etal2010 | NA               | ehret1995reconstructing | BDPROTO | NA       |
|      1061 | AFRO-ASIATIC       | Afro-Asiatic         | ʔ       | NA           | NA        | NA             | NA              | NA       | NA                    | NA                    | Proto-Afro-Asiatic | Afro-Asiatic   | Afro-Asiatic       | afro1255   | afro1255 | Reconstructed | Africa    | NA    | NA          | all           | 9th-8th millenia B.C. (diakonoff1988afrasian) |        10000 |             8.67 |              8.08 | Wichmann_etal2010 | NA               | ehret1995reconstructing | BDPROTO | NA       |
|      1061 | AFRO-ASIATIC       | Afro-Asiatic         | ħ       | NA           | NA        | NA             | NA              | NA       | NA                    | NA                    | Proto-Afro-Asiatic | Afro-Asiatic   | Afro-Asiatic       | afro1255   | afro1255 | Reconstructed | Africa    | NA    | NA          | all           | 9th-8th millenia B.C. (diakonoff1988afrasian) |        10000 |             8.67 |              8.08 | Wichmann_etal2010 | NA               | ehret1995reconstructing | BDPROTO | NA       |
|      1061 | AFRO-ASIATIC       | Afro-Asiatic         | ŋ       | NA           | NA        | NA             | NA              | NA       | NA                    | NA                    | Proto-Afro-Asiatic | Afro-Asiatic   | Afro-Asiatic       | afro1255   | afro1255 | Reconstructed | Africa    | NA    | NA          | all           | 9th-8th millenia B.C. (diakonoff1988afrasian) |        10000 |             8.67 |              8.08 | Wichmann_etal2010 | NA               | ehret1995reconstructing | BDPROTO | NA       |
|      1061 | AFRO-ASIATIC       | Afro-Asiatic         | ŋʷ      | NA           | NA        | NA             | NA              | NA       | NA                    | NA                    | Proto-Afro-Asiatic | Afro-Asiatic   | Afro-Asiatic       | afro1255   | afro1255 | Reconstructed | Africa    | NA    | NA          | all           | 9th-8th millenia B.C. (diakonoff1988afrasian) |        10000 |             8.67 |              8.08 | Wichmann_etal2010 | NA               | ehret1995reconstructing | BDPROTO | NA       |
|      1061 | AFRO-ASIATIC       | Afro-Asiatic         | ʃ       | NA           | NA        | NA             | NA              | NA       | NA                    | NA                    | Proto-Afro-Asiatic | Afro-Asiatic   | Afro-Asiatic       | afro1255   | afro1255 | Reconstructed | Africa    | NA    | NA          | all           | 9th-8th millenia B.C. (diakonoff1988afrasian) |        10000 |             8.67 |              8.08 | Wichmann_etal2010 | NA               | ehret1995reconstructing | BDPROTO | NA       |

Let’s run some checks. No NAs.

``` r
expect_false(any(is.na(inventories$BdprotoID)))
expect_false(any(is.na(inventories$SourceLanguageName)))
expect_false(any(is.na(inventories$LanguageName)))
expect_false(any(is.na(inventories$LanguageFamily)))
expect_false(any(is.na(inventories$LanguageFamilyRoot)))
expect_false(any(is.na(inventories$InventoryType)))
expect_false(any(is.na(inventories$Type)))
expect_false(any(is.na(inventories$Phoneme)))
# Todo
# expect_false(any(is.na(inventories$BibtexKey)))
```

Make sure there are no duplicate phoneme values within each language.

``` r
expect_equal(nrow(inventories %>% group_by(BdprotoID, Phoneme) %>% select(BdprotoID, SourceLanguageName, Phoneme) %>% filter(n()>1) %>% arrange(BdprotoID, Phoneme)), 0)

# If so, these are the ones:
# inventories %>% group_by(BdprotoID, Phoneme) %>% select(BdprotoID, SourceLanguageName, Phoneme) %>% filter(n()>1) %>% arrange(BdprotoID, Phoneme)
```

Make sure there are no empty `Phoneme` rows.

``` r
expect_equal(nrow(inventories %>% filter(Phoneme=="")), 0)
```

Are there still parentheses in the `Phoneme` column? There should not
be.

``` r
inventories %>% select(Phoneme) %>% filter(grepl('\\(', Phoneme)) %>% distinct()
```

    ## # A tibble: 2 × 1
    ##   Phoneme
    ##   <chr>  
    ## 1 (w)æ   
    ## 2 (w)ɑ

Anything weird about the phoneme counts? Recall, some inventories are
consonants or vowels only.

``` r
inventories %>% group_by(BdprotoID, InventoryType) %>% summarize(segments = n()) %>% arrange(segments) %>% head() %>% kable()
```

    ## `summarise()` has grouped output by 'BdprotoID'. You can override using the
    ## `.groups` argument.

| BdprotoID | InventoryType   | segments |
|----------:|:----------------|---------:|
|      1101 | vowels only     |        4 |
|      1049 | vowels only     |        6 |
|      1046 | vowels only     |        9 |
|      1066 | vowels only     |        9 |
|        86 | consonants only |       11 |
|      1096 | all             |       11 |

``` r
inventories %>% group_by(BdprotoID, InventoryType) %>% summarize(segments = n()) %>% arrange(segments) %>% tail() %>% kable()
```

    ## `summarise()` has grouped output by 'BdprotoID'. You can override using the
    ## `.groups` argument.

| BdprotoID | InventoryType | segments |
|----------:|:--------------|---------:|
|       116 | all           |       61 |
|      2002 | all           |       61 |
|       136 | all           |       62 |
|      2015 | all           |       63 |
|      1003 | all           |       66 |
|        46 | all           |       90 |

What the distribution of inventory types?

``` r
temp <- inventories %>% select(BdprotoID, InventoryType) %>% distinct()
table(temp$InventoryType, exclude = FALSE)
```

    ## 
    ##             all consonants only     vowels only 
    ##             229              38               5

Check BDPROTO segments against PHOIBLE. First load PHOIBLE.

``` r
col_types <- cols(InventoryID='i', Marginal='l', .default='c')
phoible <- read_csv(url('https://github.com/phoible/dev/blob/master/data/phoible.csv?raw=true'), col_types=col_types)
```

Which segments in BDPROTO are not in PHOIBLE?

``` r
bdproto.segments <- inventories %>% select(Source, LanguageName, Phoneme) %>% group_by(Source, LanguageName, Phoneme) %>% summarize(count=n())
```

    ## `summarise()` has grouped output by 'Source', 'LanguageName'. You can override
    ## using the `.groups` argument.

``` r
table(bdproto.segments$Phoneme %in% phoible$Phoneme)
```

    ## 
    ## FALSE  TRUE 
    ##   194  7665

``` r
temp <- bdproto.segments[which(!(bdproto.segments$Phoneme %in% phoible$Phoneme)),]
# write_csv(temp, 'missing-phonemes-by-lg.csv')
```

How about if we NDF the characters?

``` r
inventories$PhonemeNFD <- stri_trans_nfd(inventories$Phoneme)
bdproto.segments <- inventories %>% select(Source, PhonemeNFD) %>% group_by(Source, PhonemeNFD) %>% summarize(count=n())
```

    ## `summarise()` has grouped output by 'Source'. You can override using the
    ## `.groups` argument.

``` r
table(bdproto.segments$PhonemeNFD %in% phoible$Phoneme)
```

    ## 
    ## FALSE  TRUE 
    ##   176   936

``` r
temp <- bdproto.segments[which(!(bdproto.segments$PhonemeNFD %in% phoible$Phoneme)),]
# write_csv(temp, 'inventories_NFD.csv')
```

Let’s write the merged results to disk.

``` r
write_csv(inventories, '../bdproto.csv')
```

# BDPROTO raw data sources aggregation script
# Steven Moran <steven.moran@uzh.ch>

library(testthat)
library(tidyverse)
library(dplyr)
library(stringi)

####################
# HUJI Inventories #
####################

# Get inventories data
huji.inventories <- read.csv("huji/BDPROTO Jerusalem - Inventories.csv", header=T, na.strings="", blank.lines.skip=T, stringsAsFactors = F)

# Clean the inventories data
huji.inventories$Phoneme <- stri_trim(huji.inventories$Phoneme)
huji.inventories$LanguageName <- stri_trim(huji.inventories$LanguageName)

# Check the inventories for blank rows -- if yes, they need to be removed so not to introduce NA as a phoneme
expect_equal(nrow(huji.inventories[rowSums(is.na(huji.inventories)) == ncol(huji.inventories), ]), 0)

# Get metadata
huji.metadata <- read.csv("huji/BDPROTO Jerusalem - Metadata.csv", header=T, stringsAsFactors = F)
huji.metadata$LanguageName <- stri_trim(huji.metadata$LanguageName)
huji.metadata$Glottocode <- stri_trim(huji.metadata$Glottocode)

# Check that all BdprotoIDs in the inventories are present in the metadata
huji.inventories.ids <- huji.inventories %>% select(BdprotoID, LanguageName) %>% distinct() %>% arrange(BdprotoID)
expect_true(all(huji.inventories.ids$BdprotoID %in% huji.metadata$BdprotoID))

# The vice versa isn't true because (at the moment) some data points have not been entered into the inventories tab
expect_true(all(huji.metadata$BdprotoID %in% huji.inventories.ids$BdprotoID))
table(huji.metadata$BdprotoID %in% huji.inventories.ids$BdprotoID)
huji.metadata[which(!(huji.metadata$BdprotoID %in% huji.inventories.ids$BdprotoID)),] %>% select(BdprotoID, LanguageName)
rm(huji.inventories.ids)

# Languages with no phonemes (e.g. place holders mentioned above)? There should not be
expect_equal(nrow(huji.inventories %>% group_by(BdprotoID) %>% filter(n()==1) %>% select(BdprotoID, LanguageName)), 0)

# If so, we will need to filter them out
# huji.inventories <- huji.inventories %>% filter(!(LanguageName %in% missing.data$LanguageName))

# Some inventories are incomplete -- drop them
huji.inventories %>% group_by(BdprotoID,LanguageName) %>% summarize(Phoneme.count = n()) %>% arrange(Phoneme.count)
huji.inventories <- huji.inventories %>% filter(LanguageName != "Proto-Tabla-Sentani")
huji.inventories <- huji.inventories %>% filter(LanguageName != "Proto-Sahaptian")
huji.inventories %>% group_by(BdprotoID,LanguageName) %>% summarize(Phoneme.count = n()) %>% arrange(Phoneme.count)
huji.inventories %>% group_by(BdprotoID,LanguageName) %>% summarize(Phoneme.count = n()) %>% arrange(desc(Phoneme.count))

# Identify duplicate segments in the input.
huji.inventories %>% group_by(BdprotoID, Phoneme) %>% select(BdprotoID, LanguageName, Phoneme) %>% filter(n()>1)
dups <- nrow(huji.inventories %>% group_by(BdprotoID, Phoneme) %>% select(BdprotoID, LanguageName, Phoneme) %>% filter(n()>1))

# Drop the duplicate segments.
before.dups <- nrow(huji.inventories)
huji.inventories %>% group_by(BdprotoID, Phoneme) %>% filter(n()<2)
huji.inventories <- huji.inventories %>% group_by(BdprotoID, Phoneme) %>% filter(n()<2)
after.dups <- nrow(huji.inventories)
expect_true(after.dups + dups == before.dups)
rm(after.dups, before.dups)

# Are there empty phonemes?
expect_equal(nrow(huji.inventories %>% filter(Phoneme=="")), 0)
# If so, we need to drop them
# drop.ids <- huji.inventories %>% filter(Phoneme=="") %>% select(BdprotoID, Phoneme)
# huji.inventories <- huji.inventories %>% filter(!(BdprotoID %in% drop.ids$BdprotoID))
# dim(huji.inventories)

# How many data points after cleaning?
nrow(huji.inventories %>% group_by(BdprotoID, LanguageName) %>% select(BdprotoID, LanguageName) %>% distinct()) # 120

# Merge in metadata
dim(huji.inventories) # 3541
huji.inventories <- left_join(huji.inventories, huji.metadata)
dim(huji.inventories) # 3541

# Add in source field
huji.inventories$Source <- "HUJI"
glimpse(huji.inventories)
dim(huji.inventories) # 3468

# Remove parentheses in segments
huji.inventories$Phoneme <- gsub("[()]", "", huji.inventories$Phoneme)
rm(huji.metadata)


################################
# Original BDproto inventories #
################################

# Get inventories
bdproto.inventories <- read.csv("bdproto-original/bdproto-inventories.csv", header=T, stringsAsFactors = F)
expect_equal(nrow(bdproto.inventories), 2864)

# Identify duplicate segments in the input (4 rows).
bdproto.inventories %>% group_by(BdprotoID, Phoneme) %>% select(BdprotoID, LanguageName, Phoneme) %>% filter(n()>1)

# Remove the two duplicate phonemes.
bdproto.inventories <- bdproto.inventories %>% group_by(BdprotoID, Phoneme) %>% filter(row_number(Phoneme) == 1)
expect_equal(nrow(bdproto.inventories), 2862)

# Get metadata and drop language names because they do not necessarily match the inventory language names (see below)
bdproto.metadata <- read.csv("bdproto-original/bdproto-metadata.csv", header=T, stringsAsFactors = F)
bdproto.metadata <- bdproto.metadata %>% select(-LanguageName)
bdproto.metadata <- bdproto.metadata %>% select(-LanguageFamily)

# Join inventories and metadata.
bdproto.inventories <- left_join(bdproto.inventories, bdproto.metadata, by=c("BdprotoID"="BdprotoID"))
bdproto.inventories$Source <- "BDPROTO"
expect_equal(nrow(bdproto.inventories), 2862)
rm(bdproto.metadata)


########
# TODO #
########
# The language names in the original BDPROTO do not match between inventories and metadata. Furthermore, there 
#  is more metadata entries than inventories. See: https://github.com/bdproto/bdproto-original.
# x <- bdproto.inventories %>% ungroup() %>% select(LanguageName.x, LanguageName.y) %>% distinct()
# which(x$LanguageName.x != x$LanguageName.y)
# 1 12 29 38 40 45 64 97
# x[1,] # AFRO-ASIATIC   AFROASIATIC
# x[12,] # CENTRAL-KHOISAN CENTRAL KHOISAN
# x[29,] # FINNO-PERMIC   FINNO PERMIC
# x[38,] # INDO-EUROPEAN  INDO EUROPEAN
# x[40,] # KATUIC         KATOUIQUE 
# x[45,] # LOLO-BURMESE   LOLO BURMESE
# x[64,] # OTO-MANGUEAN   OTOMANGUEAN
# x[97,] # UTO-AZTECAN    UTO AZTECAN


##################
# UZ inventories #
##################

# Get inventories
uz.raw <- read.csv("uz/uz-inventories.csv", header=T, blank.lines.skip=T, stringsAsFactors=F, na.strings="")

# Remove all rows that are all NA (blank lines between )
dim(uz.raw[rowSums(is.na(uz.raw)) != ncol(uz.raw), ])
uz.raw <- uz.raw[rowSums(is.na(uz.raw)) != ncol(uz.raw), ]
rownames(uz.raw) <- NULL
# Should be zero
uz.raw[rowSums(is.na(uz.raw)) == ncol(uz.raw), ]

# Fill in the blank cells
uz.raw <- uz.raw %>% fill(BdprotoID)
uz.raw <- uz.raw %>% fill(LanguageName)
dim(uz.raw)

# Get metadata, subset relevant columns, fix data types.
uz.metadata <- read.csv("uz/uz-metadata.csv", header=T, stringsAsFactors = F)
glimpse(uz.metadata)

# Join inventories and metadata
uz.inventories <- left_join(uz.raw, uz.metadata, by=c("BdprotoID"="BdprotoID", "LanguageName"="LanguageName"))
uz.inventories$Source <- "UZ"
rm(uz.raw, uz.metadata)


#################################
# Ancient-near-east inventories #
#################################

# Get inventories
ane.raw <- read.csv("ancient-near-east/AnNeEa-inventories.csv", header=T, na.strings="", blank.lines.skip=T, stringsAsFactors = F)

# Does it contain blank rows? Yes, so remove them.
dim(ane.raw[rowSums(is.na(ane.raw)) == ncol(ane.raw), ])
ane.raw <- ane.raw[rowSums(is.na(ane.raw)) != ncol(ane.raw), ]
rownames(ane.raw) <- NULL
# Should be zero
expect_equal(nrow(ane.raw[rowSums(is.na(ane.raw)) == ncol(ane.raw), ]), 0)

# Fill in the blank cells
ane.raw <- ane.raw %>% fill(BdprotoID)
ane.raw <- ane.raw %>% fill(LanguageName)
ane.raw <- ane.raw %>% fill(SpecificDialect)

# TODO: remove trailing white space

# Metadata
ane.metadata <- read.csv("ancient-near-east/AnNeEa-metadata.csv", na.strings="NA", stringsAsFactors = F)
head(ane.metadata)

# Join em!
ane.inventories <- left_join(ane.raw, ane.metadata, by=c("BdprotoID"="BdprotoID"))
ane.inventories$Source <- "ANE"
rm(ane.raw, ane.metadata)


###################################################
# Merge the three inventory data sources together #
###################################################
expect_equal(nrow(bdproto.inventories), 2862)
expect_equal(nrow(uz.inventories), 573)
expect_equal(nrow(ane.inventories), 666)
expect_equal(nrow(huji.inventories), 3468)

# Stack em!
inventories <- bind_rows(bdproto.inventories, uz.inventories, ane.inventories, huji.inventories)
inventories <- ungroup(inventories)
rownames(inventories) <- NULL

# Test counts
expect_equal(nrow(inventories), nrow(bdproto.inventories)+nrow(uz.inventories)+nrow(ane.inventories)+nrow(huji.inventories))
nrow(inventories %>% select(LanguageName) %>% distinct())
expect_equal(nrow(inventories %>% select(LanguageName) %>% distinct()), 243) # unique language names
nrow(inventories %>% select(BdprotoID) %>% distinct())
expect_equal(nrow(inventories %>% select(BdprotoID) %>% distinct()), 254) # unique inventories
rm(ane.inventories, bdproto.inventories, uz.inventories, huji.inventories)

# Tests for duplicates -- should be 0!!
dups <- ungroup(inventories %>% group_by(BdprotoID, LanguageName) %>% select(BdprotoID, LanguageName) %>% distinct()) %>% arrange(BdprotoID)
expect_equal(nrow(dups %>% group_by(BdprotoID) %>% filter(n()>1)), 0)
rm(dups)


####################################
# Add the PHOIBLE segment features #
####################################
load(url('https://github.com/phoible/dev/blob/master/data/phoible-by-phoneme.RData?raw=true'))
features <- read.table('https://raw.githubusercontent.com/phoible/dev/master/raw-data/FEATURES/phoible-segments-features.tsv', header=T, sep='\t', stringsAsFactors=F)
expect_equal(nrow(features), 2163)
num_inventories <- nrow(inventories)

# Merge
inventories <- left_join(inventories, features, by=c("Phoneme"="segment"))
expect_equal(nrow(inventories), num_inventories)
rm(num_inventories, final.data, features)

# Identify potential coding errors in HUJI
bad.chars <- inventories %>% filter(Source=="HUJI") %>% group_by(Phoneme, consonantal) %>% select(Phoneme, consonantal) %>% filter(is.na(consonantal)) %>% distinct()
write.csv(bad.chars, file='bad-chars.csv')
rm(bad.chars)

# TODO: identify potential coding errors in other resources


################################
# Identify consonant vs vowels #
################################
phonemes <- inventories %>% group_by(Phoneme) %>% select(Phoneme, consonantal, syllabic) %>% distinct()
table(phonemes$consonantal, exclude=F) # 349 NAs

# [consonantal] is a proxy for consonants and does not work in all cases, see below
phonemes.cs <- phonemes %>% summarize(is.consonantal = ifelse(consonantal=="+", TRUE, FALSE))
phonemes.vs <- phonemes %>% summarize(is.not.consonantal = ifelse(consonantal=="-" & syllabic=="+", TRUE, FALSE))
phonemes.status <- left_join(phonemes.cs, phonemes.vs)
phonemes.status[which(phonemes.status$is.consonant == phonemes.status$is.vowel),]

# We write the data to disk and then fix the missing data points by hand
# To this we add a `type` column (copied from `is.consonantal` and updated by hand)
# write.csv(phonemes.status, file='phonemes-status.csv')
rm(phonemes, phonemes.cs, phonemes.vs, phonemes.status)

# TODO: when the input data sources are changed or updated in the future, we should:
# read in the current output csv `phonemes-status-by-hand.csv` and check newly inputted 
# segments against it and then add correct them.

# The hand curated consonant vs vowel types
segment.types <- read.csv('phonemes-status-by-hand.csv', header=TRUE, stringsAsFactors=FALSE)
glimpse(segment.types)
glimpse(inventories)

# Merge in the segment type information
inventories <- left_join(inventories, segment.types)
table(inventories$type, exclude=F) # Looks like 16 NA segments to deal with

rm(segment.types)

###############
# Data checks #
###############

# TODO: check that all Glottocodes are valid
# x <- inventories %>% select(BdprotoID, Glottocode) %>% distinct() %>% filter(!is.na(Glottocode)) %>% filter(Glottocode!="")
# x$Glottocode
# grepl("")

# InventoryType introduces NA during the merge. Make all non-values NA.
inventories %>% select(InventoryType)
table(inventories$InventoryType, exclude = F)
inventories$InventoryType[inventories$InventoryType==""] <- NA
table(inventories$InventoryType, exclude = F)


########################################
# Identify how many unique data points #
########################################

# Identify the unique entries given their IDs, language names, and reported Glottocodes
# We write these to disk and then update them by hand

# inventories-duplicates <- inventories %>% select(BdprotoID, LanguageName, Glottocode) %>% unique() %>% arrange(LanguageName)
# write.csv(x, 'inventories-duplicates.csv')

duplicate.entries <- read.csv('inventories-duplicates-by-hand.csv', header=T, stringsAsFactors=F)
inventories <- left_join(inventories, duplicate.entries)
rm(duplicate.entries)


##################
# Cache the data #
##################
save(inventories, file='../bdproto.Rdata')
write.csv(inventories, file='../bdproto.csv', row.names = FALSE)


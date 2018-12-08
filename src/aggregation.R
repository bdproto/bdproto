# BDPROTO raw data sources aggregation script
# Steven Moran <steven.moran@uzh.ch>

library(testthat)
library(tidyverse)
library(dplyr)

################################
# Original BDproto inventories #
################################
# Get inventories.
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
# Get inventories.
uz.raw <- read.csv("uz/uz-inventories.csv", header=T, blank.lines.skip=T, stringsAsFactors=F, na.strings="")
glimpse(uz.raw)

# Fill in the blank cells
uz.raw <- uz.raw %>% fill(BdprotoID)
uz.raw <- uz.raw %>% fill(LanguageName)

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
ane.raw <- read.csv("ancient-near-east/AnNeEa-inventories.csv", header=T, na.strings="", blank.lines.skip=T, stringsAsFactors = F)

# Fill in the blank cells
ane.raw <- ane.raw %>% fill(BdprotoID)
ane.raw <- ane.raw %>% fill(LanguageName)
ane.raw <- ane.raw %>% fill(SpecificDialect)

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
expect_equal(nrow(uz.inventories), 590)
expect_equal(nrow(ane.inventories), 686)

# Stack em!
inventories <- bind_rows(bdproto.inventories, uz.inventories, ane.inventories)
inventories <- ungroup(inventories)
rownames(inventories) <- NULL

# Test counts
expect_equal(nrow(inventories), nrow(bdproto.inventories)+nrow(uz.inventories)+nrow(ane.inventories))
expect_equal(nrow(inventories %>% select(LanguageName) %>% distinct()), 136) # unique language names
expect_equal(nrow(inventories %>% select(BdprotoID) %>% distinct()), 137) # unique inventories
rm(ane.inventories, bdproto.inventories, uz.inventories)


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
rm(num_inventories)


#########
# Cache #
#########
save(inventories, file='../bdproto.Rdata')
write.csv(inventories, file='../bdproto.csv', row.names = FALSE)


##############################
# Towards CLDF specification #
##############################
# Rename columns according to CLDF ontology
names(inventories)[names(inventories) == 'BdprotoID'] <- 'ID'
names(inventories)[names(inventories) == 'LanguageName'] <- 'Name'
names(inventories)[names(inventories) == 'LanguageCode'] <- 'ISO639P3code'
glimpse(inventories)


########################################################
# Merge results in segments with NA for feature values #
########################################################
inventories %>% dplyr::filter(is.na(consonantal)) %>% select(ID, Name, Glottocode) %>% unique()
missing.segments <- inventories %>% filter(is.na(consonantal)) %>% select(Phoneme) %>% unique()
write.table(missing.segments, "missing-segments.csv", sep="\t", quote = F, row.names = F)

# There are 36 languages that have one or more missing feature vectors.
dim(inventories %>% filter(is.na(consonantal)) %>% select(ID, Name) %>% unique())
no.feature.vectors <- anti_join(inventories, features)
no.feature.vectors <- no.feature.vectors %>% select(ID, Name, Phoneme, Source) %>% arrange(Name) %>% arrange(ID)
nrow(no.feature.vectors) # 91 feature vectors missing (with duplicates)
dim(no.feature.vectors %>% distinct(LanguageName)) # 36 distinct segments
head(no.feature.vectors)





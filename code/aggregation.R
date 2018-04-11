# BDPROTO aggregation script
# Steven Moran <steven.moran@uzh.ch>
# https://github.com/uzling/data/tree/master/bdproto
#
# TODO: move ANE metadata out of inventories file and into metadata file; unify columns names across data sources

library(zoo)
library(dplyr)


################################
# Original bdproto inventories #
################################
bdproto.inventories <- read.table("../raw-data/bdproto/bdproto-inventories.tsv", header=T, sep="\t", stringsAsFactors = F)
dim(bdproto.inventories) # 2864 4

# Identify duplicate segments in the input (4 rows).
bdproto.inventories %>% group_by(BdprotoID, Phoneme) %>% select(BdprotoID, LanguageName, Phoneme) %>% filter(n()>1)

# Remove the two duplicate phonemes.
bdproto.inventories <- bdproto.inventories %>% group_by(BdprotoID, Phoneme) %>% filter(row_number(Phoneme) == 1)
dim(bdproto.inventories) # 2862 4

# Metadata.
bdproto.metadata <- read.table("../raw-data/bdproto/bdproto-metadata.tsv", header=T, sep="\t", stringsAsFactors = F)
bdproto.metadata <- bdproto.metadata %>% select(BdprotoID, GlottologID, TimeDepth, TimeDepthInventorySource, TimeDepthDateSource)
glimpse(bdproto.metadata)

# Join inventories and metadata.
bdproto.inventories <- left_join(bdproto.inventories, bdproto.metadata, by=c("BdprotoID"="BdprotoID"))
glimpse(bdproto.inventories)


##################
# UZ inventories #
##################
uz.raw <- read.table("../raw-data/uz/uz-inventories.tsv", header=T, sep="\t", na.strings="", blank.lines.skip=T)
glimpse(uz.raw)
uz.raw <- uz.raw %>% select(BdprotoID, LanguageName, Phoneme)
uz.inventories <- uz.raw %>% do(na.locf(.))

# Reconstruct the data types.
uz.inventories$BdprotoID <- as.numeric(uz.inventories$BdprotoID)
# uz.inventories$Glottocode <- as.factor(uz.inventories$Glottocode)
# uz.inventories$LanguageName <- as.factor(uz.inventories$LanguageName)
# uz.inventories$LanguageName <- as.factor(uz.inventories$LanguageName)
glimpse(uz.inventories)

# Metadata
uz.metadata <- read.table("../raw-data/uz/uz-metadata.tsv", header=T, sep="\t", stringsAsFactors = F)
glimpse(uz.metadata)
uz.metadata <- uz.metadata %>% select(BdprotoID, GlottologID, TimeDepth, TimeDepthInventorySource, TimeDepthDateSource)
uz.metadata$TimeDepth <- as.character(uz.metadata$TimeDepth)
uz.metadata$TimeDepthInventorySource <- as.character(uz.metadata$TimeDepthInventorySource)
glimpse(uz.metadata)

# Join inventories and metadata
uz.inventories <- left_join(uz.inventories, uz.metadata, by=c("BdprotoID"="BdprotoID"))
glimpse(uz.inventories)


#################################
# Ancient-near-east inventories #
#################################
ane.raw <- read.table("../raw-data/ancient-near-east/AnNeEa-inventories.tsv", header=T, sep="\t", na.strings="", blank.lines.skip=T, stringsAsFactors = F)
ane.raw <- ane.raw %>% select(BdprotoID, LanguageName, Phoneme)
ane.inventories <- ane.raw %>% do(na.locf(.))

# Reconstruct data types
ane.inventories$BdprotoID <- as.numeric(ane.inventories$BdprotoID)
# ane.inventories$LanguageName <- as.factor(ane.inventories$LanguageName)
# ane.inventories$Phoneme <- as.factor(ane.inventories$Phoneme)
glimpse(ane.inventories)

# Metadata
ane.metadata <- read.table("../raw-data/ancient-near-east/AnNeEa-metadata.tsv", header=T, sep="\t", stringsAsFactors = F)
glimpse(ane.metadata)
ane.metadata <- ane.metadata %>% select(BdprotoID, GlottologID, TimeDepth)

# Join em
ane.inventories <- left_join(ane.inventories, ane.metadata, by=c("BdprotoID"="BdprotoID"))
glimpse(ane.inventories)


###################################################
# Merge the three inventory data sources together #
###################################################
dim(bdproto.inventories) # 2862    8
dim(uz.inventories) # 590   8
dim(ane.inventories) # 686   6

inventories <- bind_rows(bdproto.inventories, uz.inventories, ane.inventories)
inventories <- ungroup(inventories)
rownames(inventories) <- NULL

glimpse(inventories)
dim(inventories) # 4138   10
inventories %>% select(LanguageName) %>% distinct() # 126 unique language names
inventories %>% select(BdprotoID) %>% distinct() # 127 inventories

####################
# Phoible features #
####################
features <- read.table("/Users/stiv/Dropbox/Github/phoible/raw-data/FEATURES/phoible-segments-features.tsv", header=T, sep="\t")
nrow(features) # 2163
names(features)[1] <- c("Phoneme")

#################################
# Join inventories and features #
#################################
inventories.features <- left_join(inventories, features)
head(inventories.features)
dim(inventories.features) # 4138 45


########################################################
# Merge results in segments with NA for feature values #
########################################################
inventories.features %>% filter(is.na(consonantal)) %>% select(BdprotoID, LanguageName, GlottologID) %>% unique()
missing.segments <- inventories.features %>% filter(is.na(consonantal)) %>% select(Phoneme) %>% unique()
write.table(missing.segments, "missing-segments.csv", sep="\t", quote = F, row.names = F)
# There are 36 languages that have one or more missing feature vectors.
dim(inventories.features %>% filter(is.na(consonantal)) %>% select(BdprotoID, LanguageName) %>% unique()) # 36 2
no.feature.vectors <- anti_join(inventories, features)
no.feature.vectors <- no.feature.vectors %>% select(BdprotoID, LanguageName, Phoneme) %>% arrange(LanguageName) %>% arrange(BdprotoID)
nrow(no.feature.vectors) # 91 feature vectors missing (with duplicates)
dim(no.feature.vectors %>% distinct(LanguageName)) # 36 distinct segments
head(no.feature.vectors)


#############################################
# Generate segment, consonant, vowel counts #
#############################################
inventories.cs.vs <- inventories.features
inventories.cs.vs$is.consonant <- ifelse(inventories.cs.vs$syllabic %in% '-', TRUE, FALSE)
inventories.cs.vs$is.vowel <- ifelse(inventories.cs.vs$syllabic %in% '+' & inventories.cs.vs$consonantal %in% '-', TRUE, FALSE)
inventories.cs.vs <- inventories.cs.vs %>% select(BdprotoID, LanguageName, GlottologID, Phoneme, is.consonant, is.vowel)
inventories.cs.vs %>% filter(!is.consonant, !is.vowel) %>% select(Phoneme, is.consonant, is.vowel) %>% unique() # 91 missing feature vectors
# Counts  
total.segments <- inventories.features %>% group_by(BdprotoID) %>% summarise(segments = n())
head(total.segments)
total.vowels <- inventories.features %>% group_by(BdprotoID) %>% filter(syllabic %in% '+' & consonantal %in% '-') %>% summarise(vowels = n())
total.consonants <- inventories.features %>% group_by(BdprotoID) %>% filter(syllabic %in% '-') %>% summarise(consonants = n())
# TODO: update this if tone is introduced in a proto-inventory
# inventories.features$tone!=0
# total.tones <- inventories.features %>% group_by(BdprotoID) %>% filter(tone %in% '+') %>% summarise(tones = n())
counts <- left_join(total.segments, total.vowels) %>% left_join(., total.consonants)
counts$diff <- (counts$vowels+counts$consonants)-counts$segments
sum(counts$diff, na.rm = T)
head(counts, n=10)
length(counts$diff!=0)


############################
# Merge in Glottolog codes #
############################
gcodes <- metadata %>% select(BdprotoID, GlottologID, LanguageName, TimeDepth)
counts <- left_join(counts, gcodes)
dim(counts) # 101 8


#########
# Cache #
#########
save(inventories, inventories.features, no.feature.vectors, counts, inventories.cs.vs, file='bdproto.Rdata')



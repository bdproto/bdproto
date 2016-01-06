# BDPROTO scipts
# Steven Moran <steven.moran@uzh.ch>
# Sept, 2014

# background / data workflow / more information:
# https://github.com/uzling/data/tree/master/bdproto

library(dplyr)

# load bdproto data
load("bdproto.RData")

## query for labiodentals and output matrix of TRUE / FALSE

# query the inventories by regex
subset(inventories, grepl('f', Phoneme)) # subset f rows
filter(inventories, grepl('f|v', Phoneme)) # subset f rows with dplyr 
filter(inventories, !grepl('f|v', Phoneme)) # subset NOT f rows with dplyr
filter(inventories, grepl('^.*?m.*?$', Phoneme)) # MySQL LIKE in regex (see below)

#####################
## the SQL keyword LIKE in regular expression syntax
# bcd → ^bcd$
# %bcd → ^.*?bcd$
# bcd% → ^bcd.*?$
# %bcd% → ^.*?bcd.*?$
#####################

# add hasfv column of whether Phoneme is f or v
mutate(inventories, hasfv = grepl('f|v', Phoneme))

# summarize inventories by unique LanguageName and whether each inventory has f or v
group_by(inventories, LanguageName, BdprotoID) %>% summarize(hasfv = any(grepl('f|v', Phoneme)))
hasfv <- group_by(inventories, LanguageName) %>% summarize(hasfv = any(grepl('f|v', Phoneme)))


## combine with output from BB's methods

# load data
bb.metadata <- read.table("/Users/stiv/Dropbox/Work/Patrick-Steve/bb_bdproto_linked.csv", sep="\t", header=T)
head(bb.metadata)

coupled.mc.dep <- read.table("/Users/stiv/Dropbox/Work/Patrick-Steve/bayes.traits.files_labiodentals.fam.coupled.large.nonunif.trees.mc_dep_spreadsheet.csv", sep="\t", header=T)
head(coupled.mc.dep)

coupled.mc.ind <- read.table("/Users/stiv/Dropbox/Work/Patrick-Steve/bayes.traits.files_labiodentals.fam.coupled.large.nonunif.trees.mc_ind_spreadsheet.csv", sep="\t", header=T)
coupled.dep <- read.table("/Users/stiv/Dropbox/Work/Patrick-Steve/bayes.traits.files_labiodentals.fam.coupled.large.nonunif.trees_dep_spreadsheet.csv", sep="\t", header=T)
coupled.ind <- read.table("/Users/stiv/Dropbox/Work/Patrick-Steve/bayes.traits.files_labiodentals.fam.coupled.large.nonunif.trees_ind_spreadsheet.csv", sep="\t", header=T)
trees.ard <- read.table("/Users/stiv/Dropbox/Work/Patrick-Steve/bayes.traits.files_labiodentals.fam.large.nonunif.trees_ard_spreadsheet.csv", sep="\t", header=T)
trees.er <- read.table("/Users/stiv/Dropbox/Work/Patrick-Steve/bayes.traits.files_labiodentals.fam.large.nonunif.trees_er_spreadsheet.csv", sep="\t", header=T)

# do the joining
x <- inner_join(bb_metadata, coupled.mc.dep)
coupled.mc.dep.hasfv <- inner_join(x, hasfv)
coupled.mc.dep.hasfv

x <- inner_join(bb_metadata, coupled.mc.ind)
coupled.mc.ind.hasfv <- inner_join(x, hasfv)
head(coupled.mc.ind.hasfv)

x <- inner_join(bb_metadata, coupled.dep)
coupled.dep.hasfv <- inner_join(x, hasfv)
head(coupled.dep.hasfv)

x <- inner_join(bb_metadata, coupled.ind)
coupled.ind.hasfv <- inner_join(x, hasfv)
head(coupled.ind.hasfv)

x <- inner_join(bb_metadata, trees.ard)
trees.ard.hasfv <- inner_join(x, hasfv)
head(trees.ard.hasfv)

x <- inner_join(bb_metadata, trees.er)
trees.er.hasfv <- inner_join(x, hasfv)
head(trees.er.hasfv)

write.table(coupled.mc.dep.hasfv, "coupled.mc.dep.hasfv.tsv")
write.table(coupled.mc.ind.hasfv, "coupled.mc.ind.hasfv.tsv")
write.table(coupled.dep.hasfv, "coupled.dep.hasfv.tsv")
write.table(coupled.ind.hasfv, "coupled.ind.hasfv.tsv")
write.table(trees.ard.hasfv, "trees.ard.hasfv.tsv")
write.table(trees.er.hasfv, "trees.er.hasfv.tsv")

save.image(file="bdproto-with-labiodentals.RData")


## aggregate and combine the data into an R data object

# load the bdproto metadata table
bdproto.metadata <- read.table("bdproto-metadata.tsv", header=T, sep="\t")
head(bdproto.metadata)

# load the bdproto inventories (current working directory)
inventories <- read.table("bdproto-inventories.tsv", header=T, sep="\t")
head(inventories)
nrow(inventories)

# load the phoible features
features <- read.table("~/Dropbox/Github/phoible/data/FEATURES/phoible-segments-features.tsv", header=T, sep="\t")
head(features)
nrow(features)
names(features)[1] <- c("Phoneme")

# join inventories and features == 2790 rows
x <- inner_join(inventories, features)
head(x)
nrow(x)

# identify the rows where there is no corresponding matching segment feature vector (i.e. not in phoible)
y <- anti_join(inventories, features)
nrow(y)
head(y)

save.image(file="bdproto.RData")
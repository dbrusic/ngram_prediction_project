#### CREATE MAXIMUM LIKELIHOOD ESTIMATE COLUMNS, TRIM TABLES, AND COMBINE TABLES INTO ONE ####

library(data.table)
# source("2_download_corpus.R")
# source("3_sentence_tokens.R")
# source("4_sample_train_test.R")
# source("5_ngram_type_count.R")

# fivegrams and fourgrams are done in 4 chunks (split alphabetically by base column)

#### FIVEGRAMS ####
# a-d
# e-l
# m-s
# t-z
fivegrams <- readRDS("train_5grams.rds")
setorder(fivegrams, base)
# last ngram starting with d
spl1 <- grep("^e", fivegrams$base, perl = TRUE)[1] - 1
# last ngram starting with l
spl2 <- grep("^m", fivegrams$base, perl = TRUE)[1] - 1 
# last ngram starting with s
spl3 <- grep("^t", fivegrams$base, perl = TRUE)[1] - 1 
# 1st chunk
fivegrams <- fivegrams[1:spl1]
# remove ngrams that have the same word repeated at least once
fivegrams[, ngram := paste(base, pred)]
fivegrams <- fivegrams[-grep("(.+)\\s\\1", fivegrams$ngram, perl = TRUE)]
fivegrams[, ngram := NULL]
setkey(fivegrams, base)
fivegrams[, mle := (frequency/sum(frequency)), by=.(base)]
setorder(fivegrams, -mle)
setkey(fivegrams, base)
fivegrams[,indx := seq_len(.N), by = .(base)]
saveRDS(fivegrams, "train_5grams_split1.rds")
rm(fivegrams)
gc()
# 2nd chunk
fivegrams <- readRDS("train_5grams.rds")
setorder(fivegrams, base)
fivegrams <- fivegrams[(spl1 + 1):spl2]
fivegrams[, ngram := paste(base, pred)]
fivegrams <- fivegrams[-grep("(.+)\\s\\1", fivegrams$ngram, perl = TRUE)]
fivegrams[, ngram := NULL]
setkey(fivegrams, base)
fivegrams[, mle := (frequency/sum(frequency)), by=.(base)]
setorder(fivegrams, -mle)
setkey(fivegrams, base)
fivegrams[,indx := seq_len(.N), by = .(base)]
saveRDS(fivegrams, "train_5grams_split2.rds")
rm(fivegrams)
gc()
# 3rd chunk
fivegrams <- readRDS("train_5grams.rds")
setorder(fivegrams, base)
fivegrams <- fivegrams[(spl2 + 1):spl3]
fivegrams[, ngram := paste(base, pred)]
fivegrams <- fivegrams[-grep("(.+)\\s\\1", fivegrams$ngram, perl = TRUE)]
fivegrams[, ngram := NULL]
setkey(fivegrams, base)
fivegrams[, mle := (frequency/sum(frequency)), by=.(base)]
setorder(fivegrams, -mle)
setkey(fivegrams, base)
fivegrams[,indx := seq_len(.N), by = .(base)]
saveRDS(fivegrams, "train_5grams_split3.rds")
rm(fivegrams)
gc()
# 4th chunk
fivegrams <- readRDS("train_5grams.rds")
setorder(fivegrams, base)
fivegrams <- fivegrams[(spl3 + 1):fivegrams[,.N]]
fivegrams[, ngram := paste(base, pred)]
fivegrams <- fivegrams[-grep("(.+)\\s\\1", fivegrams$ngram, perl = TRUE)]
fivegrams[, ngram := NULL]
setkey(fivegrams, base)
fivegrams[, mle := (frequency/sum(frequency)), by=.(base)]
setorder(fivegrams, -mle)
setkey(fivegrams, base)
fivegrams[,indx := seq_len(.N), by = .(base)]
saveRDS(fivegrams, "train_5grams_split4.rds")
rm(fivegrams, spl1, spl2, spl3)
gc()

# combine 
# remove ngrams that only have one base and frequency of one
f1 <- readRDS("train_5grams_split1.rds")
f1 <- f1[(frequency != 1) | (frequency == 1 & mle < 1)]
f1 <- f1[indx <= 3]

f2 <- readRDS("train_5grams_split2.rds")
f2 <- f2[(frequency != 1) | (frequency == 1 & mle < 1)]
f2 <- f2[indx <= 3]

f3 <- readRDS("train_5grams_split3.rds")
f3 <- f3[(frequency != 1) | (frequency == 1 & mle < 1)]
f3 <- f3[indx <= 3]

f4 <- readRDS("train_5grams_split4.rds")
f4 <- f4[(frequency != 1) | (frequency == 1 & mle < 1)]
f4 <- f4[indx <= 3]

f1 <- rbindlist(list(f1,f2,f3,f4))
rm(f2,f3,f4)
saveRDS(f1,"train_5grams_mle.rds")
# unlink("train_5grams_split1.rds")
# unlink("train_5grams_split2.rds")
# unlink("train_5grams_split3.rds")
# unlink("train_5grams_split4.rds")


#### FOURGRAMS ####
# a-d
# e-l
# m-s
# t-z
fourgrams <- readRDS("train_4grams.rds")
setorder(fourgrams, base)
# last ngram starting with d
spl1 <- grep("^e", fourgrams$base, perl = TRUE)[1] - 1 
# last ngram starting with l
spl2 <- grep("^m", fourgrams$base, perl = TRUE)[1] - 1 
# last ngram starting with s
spl3 <- grep("^t", fourgrams$base, perl = TRUE)[1] - 1 
# 1st chunk
fourgrams <- fourgrams[1:spl1]
# remove ngrams that have the same word repeated at least once
fourgrams[, ngram := paste(base, pred)]
fourgrams <- fourgrams[-grep("(.+)\\s\\1", fourgrams$ngram, perl = TRUE)]
fourgrams[, ngram := NULL]
setkey(fourgrams, base)
fourgrams[, mle := (frequency/sum(frequency)), by=.(base)]
setorder(fourgrams, -mle)
setkey(fourgrams, base)
fourgrams[,indx := seq_len(.N), by = .(base)]
saveRDS(fourgrams, "train_4grams_split1.rds")
rm(fourgrams)
gc()
# 2nd chunk
fourgrams <- readRDS("train_4grams.rds")
setorder(fourgrams, base)
fourgrams <- fourgrams[(spl1 + 1):spl2]
fourgrams[, ngram := paste(base, pred)]
fourgrams <- fourgrams[-grep("(.+)\\s\\1", fourgrams$ngram, perl = TRUE)]
fourgrams[, ngram := NULL]
setkey(fourgrams, base)
fourgrams[, mle := (frequency/sum(frequency)), by=.(base)]
setorder(fourgrams, -mle)
setkey(fourgrams, base)
fourgrams[,indx := seq_len(.N), by = .(base)]
saveRDS(fourgrams, "train_4grams_split2.rds")
rm(fourgrams)
gc()
# 3rd chunk
fourgrams <- readRDS("train_4grams.rds")
setorder(fourgrams, base)
fourgrams <- fourgrams[(spl2 + 1):spl3]
fourgrams[, ngram := paste(base, pred)]
fourgrams <- fourgrams[-grep("(.+)\\s\\1", fourgrams$ngram, perl = TRUE)]
fourgrams[, ngram := NULL]
setkey(fourgrams, base)
fourgrams[, mle := (frequency/sum(frequency)), by=.(base)]
setorder(fourgrams, -mle)
setkey(fourgrams, base)
fourgrams[,indx := seq_len(.N), by = .(base)]
saveRDS(fourgrams, "train_4grams_split3.rds")
rm(fourgrams)
gc()
# 4th chunk
fourgrams <- readRDS("train_4grams.rds")
setorder(fourgrams, base)
fourgrams <- fourgrams[(spl3 + 1):fourgrams[,.N]]
fourgrams[, ngram := paste(base, pred)]
fourgrams <- fourgrams[-grep("(.+)\\s\\1", fourgrams$ngram, perl = TRUE)]
fourgrams[, ngram := NULL]
setkey(fourgrams, base)
fourgrams[, mle := (frequency/sum(frequency)), by=.(base)]
setorder(fourgrams, -mle)
setkey(fourgrams, base)
fourgrams[,indx := seq_len(.N), by = .(base)]
saveRDS(fourgrams, "train_4grams_split4.rds")
rm(fourgrams)
gc()
rm(spl1, spl2, spl3)
# combine 
f1 <- readRDS("train_4grams_split1.rds")
f1 <- f1[(frequency != 1) | (frequency == 1 & mle < 1)]
f1 <- f1[indx <= 3]

f2 <- readRDS("train_4grams_split2.rds")
f2 <- f2[(frequency != 1) | (frequency == 1 & mle < 1)]
f2 <- f2[indx <= 3]

f3 <- readRDS("train_4grams_split3.rds")
f3 <- f3[(frequency != 1) | (frequency == 1 & mle < 1)]
f3 <- f3[indx <= 3]

f4 <- readRDS("train_4grams_split4.rds")
f4 <- f4[(frequency != 1) | (frequency == 1 & mle < 1)]
f4 <- f4[indx <= 3]

f1 <- rbindlist(list(f1,f2,f3,f4))
rm(f2,f3,f4)
saveRDS(f1,"train_4grams_mle.rds")
# unlink("train_4grams_split1.rds")
# unlink("train_4grams_split2.rds")
# unlink("train_4grams_split3.rds")
# unlink("train_4grams_split4.rds")


#### TRIGRAMS ####
trigrams <- readRDS("train_3grams.rds")
# remove ngrams that have the same word repeated at least once
trigrams[, ngram := paste(base, pred)]
trigrams <- trigrams[-grep("(.+)\\s\\1", trigrams$ngram, perl = TRUE)]
trigrams[, ngram := NULL]
setkey(trigrams, base)
trigrams[, mle := (frequency/sum(frequency)), by=.(base)]
setorder(trigrams, -mle)
setkey(trigrams, base)
trigrams[,indx := seq_len(.N), by = .(base)]
saveRDS(trigrams, "train_3grams_split1.rds")
rm(trigrams)
gc()

f <- readRDS("train_3grams_split1.rds")
f <- f[(frequency != 1) | (frequency == 1 & mle < 1)]
f <- f[indx <= 3]
saveRDS(f, "train_3grams_mle.rds")
rm(f)


#### BIGRAMS #### 
bigrams <- readRDS("train_2grams.rds")
# remove ngrams that have the same word repeated at least once
bigrams[, ngram := paste(base, pred)]
bigrams <- bigrams[-grep("(.+)\\s\\1", bigrams$ngram, perl = TRUE)]
bigrams[, ngram := NULL]
setkey(bigrams, base)
bigrams[, mle := (frequency/sum(frequency)), by=.(base)]
setorder(bigrams, -mle)
setkey(bigrams, base)
bigrams[,indx := seq_len(.N), by = .(base)]
saveRDS(bigrams, "train_2grams_split1.rds")
rm(bigrams)
gc()

f <- readRDS("train_2grams_split1.rds")
f <- f[(frequency != 1) | (frequency == 1 & mle < 1)]
f <- f[indx <= 3]
saveRDS(f, "train_2grams_mle.rds")
rm(f)


#### COMBINE ####
n2 <- readRDS("train_2grams_mle.rds")
n3 <- readRDS("train_3grams_mle.rds")
n4 <- readRDS("train_4grams_mle.rds")
n5 <- readRDS("train_5grams_mle.rds")

n2 <- n2[frequency > 3]
n3 <- n3[frequency > 3]
n4 <- n4[frequency > 2]
n5 <- n5[frequency > 2]

query_table <- rbindlist(list(n2, n3, n4, n5))
rm(n2, n3, n4, n5)
query_table[, c('frequency', 'mle', 'indx') := NULL]
saveRDS(query_table, "query_table.rds")
rm(query_table)


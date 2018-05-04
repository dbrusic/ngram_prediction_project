#### GENERATE NGRAM TYPE COUNT DATA TABLES ####

source("1_functions.R")
# source("2_download_corpus.R")
# source("3_sentence_tokens.R")
# source("4_sample_train_test.R")

con <- file("train.txt", open = "rb")
train <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
rm(con)

top_ngram <- 5
chunks <- 20

ind <- chunkIndex(train, chunks = chunks)[[1]]

for(i in 1:chunks) {
        s <- ind[,i][1]
        e <- ind[,i][2]
        for(j in 1:top_ngram) {
                dtbl <- type_count(txt = train[s:e], ng = j)
                dtbl <- dt_clean(dt = dtbl)
                split_base_pred(dt = dtbl, ng = j)
                saveRDS(dtbl, file = paste("train", i, "_", j,".rds", sep = ""))
                rm(dtbl)
        }
}

rm(ind, s, e, i, j, train)
gc()

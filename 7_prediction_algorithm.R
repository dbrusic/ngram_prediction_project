#### FUNCTION/ALGORITHM THAT SEARCHES FOR TOP THREE NEXT WORD PREDICTIONS ####

library(data.table)
# source("2_download_corpus.R")
# source("3_sentence_tokens.R")
# source("4_sample_train_test.R")
# source("5_ngram_type_count.R")
# source("6_create_query_table.R")

if(!("query_table" %in% ls())) {
        query_table <- readRDS("query_table.rds")
}
setkey(query_table, base)

suggest <- function(input) {
        words <- gsub("[^[:alnum:][:space:]'-]", "", input, perl = TRUE)
        words <- gsub("\\s+", " ", words, perl = TRUE)
        words <- gsub("^\\s+|\\s+$", "", words, perl = TRUE)
        words <- tolower(words)
        words <- unlist(strsplit(words, " "))
        lw <- length(words)
        if(lw == 0) {
                # top three unigrams in order
                p <- c("the", "to", "and")
                return(p)
        } else {
                if(lw < 4) {
                        s <- lw - 1 
                } else {
                        s <- 3
                }
        }
        p <- list()
        cnt <- 0
        for(i in s:0) {
                cnt <- cnt + 1
                ngram <- paste(words[(lw-i):lw], collapse = " ")
                p[[cnt]] <- query_table[ngram, pred]
                if(sum(!is.na(unique(unlist(p)))) >= 3) {
                        break
                }
        }
        p <- unlist(p)
        # add top three unigrams to end 
        # if at least three words have already been found,
        # these unigram predictions will get cut off
        p <- c(p, "the", "to", "and")
        p <- p[!is.na(p)]
        p <- unique(p)
        return(p[1:3])
}
#### CREATE TEST SET AND TEST PREDICTION ACCURACY ####

# source("2_download_corpus.R")
# source("3_sentence_tokens.R")
# source("4_sample_train_test.R")
# source("5_ngram_type_count.R")
# source("6_create_query_table.R")
# source("7_prediction_algorithm.R")

# test data is cleaned (done in 3_sentence_tokens.R):
# (see string_clean function)
# split by sentence
# remove all punctuation except apostrophes and hyphens
# to lower case
# urls will be replaced by "URL"
# non_ASCII character replaced with "AA"
# 
# numbers are kept 
# 750 sentences from each of the three leftover files (extra_news.txt, extra_blogs.txt, and extra_twitter.txt)
# 

# read in extra sentences
con <- file("extra_news.txt", open = "rb")
news <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
con <- file("extra_blogs.txt", open = "r")
blogs <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
con <- file("extra_twitter.txt", open = "r")
twitter <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
rm(con)

# remove strings that have "AA" or "URL" (model does not predict urls)
news <- news[-grep("AA|URL", news, perl = TRUE)]
blogs <- blogs[-grep("AA|URL", blogs, perl = TRUE)]
twitter <- twitter[-grep("AA|URL", twitter, perl = TRUE)]

# remove strings that contain numbers (model does not predict numbers)
news <- news[-grep("[[:digit:]]", news, perl = TRUE)]
blogs <- blogs[-grep("[[:digit:]]", blogs, perl = TRUE)]
twitter <- twitter[-grep("[[:digit:]]", twitter, perl = TRUE)]

# replace double spaces with single
news <- gsub("\\s{2,}", " ", news, perl = TRUE)
blogs <- gsub("\\s{2,}", " ", blogs, perl = TRUE)
twitter <- gsub("\\s{2,}", " ", twitter, perl = TRUE)

# replace everything but alphabetic characters, numbers, apostrophes, hyphens, and space
news <- gsub("[^[:alnum:][:space:]'-]", "", news, perl = TRUE)
blogs <- gsub("[^[:alnum:][:space:]'-]", "", blogs, perl = TRUE)
twitter <- gsub("[^[:alnum:][:space:]'-]", "", twitter, perl = TRUE)

# remove strings that don't contain alphabetic characters
news <- news[grep("[[:alpha:]]", news, perl = TRUE)]
blogs <- blogs[grep("[[:alpha:]]", blogs, perl = TRUE)]
twitter <- twitter[grep("[[:alpha:]]", twitter, perl = TRUE)]

# remove strings that contain more than 1 word and less than 30 words
sl <- sapply(news,function(x){length(unlist(strsplit(x," ")))})
news <- news[sl > 2 & sl < 31]
sl <- sapply(blogs,function(x){length(unlist(strsplit(x," ")))})
blogs <- blogs[sl > 2 & sl < 31]
sl <- sapply(twitter,function(x){length(unlist(strsplit(x," ")))})
twitter <- twitter[sl > 2 & sl < 31]
rm(sl)

# sample sentences from each
sz = 750
set.seed(111)
samp1 <- sample(1:length(news), size = sz)
set.seed(222)
samp2 <- sample(1:length(blogs), size = sz)
set.seed(333)
samp3 <- sample(1:length(twitter), size = sz)

# combine to make test set
test <- c(news[samp1], blogs[samp2], twitter[samp3])
rm(news, blogs, twitter, samp1, samp2, samp3, sz)

# write test set
con <- file("test.txt")
writeLines(test, con)
close(con)
rm(con)


#### READ TEST TEXT FILE INTO R AND PREPARE IT FOR TESTING ####

con <- file("test.txt")
test <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
rm(con)

# split into words (creates list)
test_list <- sapply(test, strsplit, split = " ")
names(test_list) <- NULL
rm(test)

# remove apostrophes and hyphens that start or end words
test_list <- lapply(test_list, function(x) {gsub("^-|^\'", "", x, perl = TRUE)})
test_list <- lapply(test_list, function(x) {gsub("-$|\'$", "", x, perl = TRUE)})

# remove words that don't contain alphabetic characters
test_list <- lapply(test_list, function(x) {x[grep("[[:alpha:]]", x)]})


#### ACCURACY TESTING FUNCTION ####

# run prediction algorithm line by line (sentence by sentence);
# basically just feed each sentence to prediction algorithm and
# test if it predicts each word or not

# test_txt needs to be a list of sentences that have been split by word;
# fun needs to be an ngram prediction function/algorithm that takes a text string contained in a 
# sentence; overlapping sentences won't yield accurate results for ngram model because
# the model does not contain any ngrams that overlap sentences
test_accuracy <- function(fun, test_txt) {
        total <- length(test_txt)
        pb <- txtProgressBar(min = 0, max = total, style = 3)
        correct <- sapply(1:total, function(x) {
                setTxtProgressBar(pb, x)
                sent <- test_txt[[x]]
                len <- length(sent)
                pred <- sapply(1:len, function(i) {
                        sug <- do.call(fun, list(paste(sent[-(i:len)], collapse = " ")))
                        sug1 <- sug[1]
                        sug3 <- sug[!is.na(sug[1:3])]
                        if(!(sent[i] %in% sug3)) {
                                return(0)
                        } else {
                                if(sug1 == sent[i]) {
                                        return(1)
                                } else {
                                        return(3)
                                }
                        }
                })
                # output will be a matrix with two rows
                # and number of columns equal to length of test_txt
                c(sum(pred == 1), sum(pred == 1 | pred == 3))
        })
        total_correct_1 <- sum(correct[1,])
        total_correct_3 <- sum(correct[2,])
        total_test_words <- sum(sapply(test_txt, length))
        accuracy_1 <- total_correct_1/total_test_words
        accuracy_3 <- total_correct_3/total_test_words
        cat(paste("\ntop 1 accuracy: ", round(accuracy_1*100, 2), "%\n", sep = ""))
        cat(paste("top 3 accuracy: ", round(accuracy_3*100, 2), "%", sep = ""))
}

# run the test on test_list using suggest function and query_table
test_accuracy(suggest, test_list)



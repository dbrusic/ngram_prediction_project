#### SPLIT TEXT FILES INTO SENTENCES AND USE STRING_CLEAN FUNCTION ####

source("1_functions.R")
# source("2_download_corpus.R")

# read in each of the three text files
# (for news file, there are several substitute characters that 
# make readLines function stop so it is read in as binary)
# then tokenize into sentences
# then write the tokenized text to a new text file

# NEWS
con <- file("corpora/en_US.news.txt", open = "rb")
news <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
sent <- as.character(tokens(news, what = 'sentence', verbose = TRUE))
sent <- string_clean(sent)
con <- file("news.txt")
writeLines(sent, con)
close(con)
rm(news, sent)

# BLOGS
con <- file("corpora/en_US.blogs.txt", open = "r")
blogs <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
sent <- as.character(tokens(blogs, what = 'sentence', verbose = TRUE))
sent <- string_clean(sent)
con <- file("blogs.txt")
writeLines(sent, con)
close(con)
rm(blogs, sent)

# TWITTER (done in chunks to avoid running out of RAM)
# uses chunkIndex function
con <- file("corpora/en_US.twitter.txt", open = "r")
twitter <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
ind <- chunkIndex(twitter, chunks = 4)[[1]]
for(i in 1:4) {
        s <- ind[,i][1]
        e <- ind[,i][2]
        sent <- as.character(tokens(twitter[s:e], what = 'sentence', verbose = TRUE))
        sent <- string_clean(sent)
        con <- file(paste("twitter", i, ".txt", sep = ""))
        writeLines(sent, con)
        close(con)
        rm(sent)
}
rm(twitter, ind, s, e, i)
tw <- vector(mode = "list", length = 4)
for(i in 1:4) {
        con <- file(paste("twitter", i, ".txt", sep = ""), open = "r")
        tw[[i]] <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
        close(con)
}
twitter <- unlist(tw)
rm(tw)
con <- file("twitter.txt")
writeLines(twitter, con)
close(con)
rm(twitter, i)
rm(con)
file.remove("twitter1.txt", "twitter2.txt", "twitter3.txt", "twitter4.txt")



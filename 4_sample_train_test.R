#### SAMPLE SENTENCES FROM EACH OF THE THREE TEXTS ####

# source("2_download_corpus.R")

# read in each of the three text files
# for news file, there are several substitute characters that 
# make readLines function stop so it is read in as binary 
con <- file("news.txt", open = "rb")
news <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
con <- file("blogs.txt", open = "r")
blogs <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
con <- file("twitter.txt", open = "r")
twitter <- readLines(con, skipNul = TRUE, encoding = "UTF-8")
close(con)
rm(con)

# find minimum number of sentences from each of the three files;
# take percentage from the minimum (60% in this case);
# sample that value from each file (get same number of sentences from each source)
l_twitter <- length(twitter)
l_blogs <- length(blogs)
l_news <- length(news)
min_length <- min(l_twitter, l_blogs, l_news)
perc <- 0.6
sample_length <- ceiling(min_length*perc)

# subset each of the three documents
# to create the training corpus
set.seed(12345)
samp1 <- sample(1:l_twitter, size = sample_length)
set.seed(54321)
samp2 <- sample(1:l_blogs, size = sample_length)
set.seed(34215)
samp3 <- sample(1:l_news, size = sample_length)
# training corpus
train <- c(twitter[samp1], blogs[samp2], news[samp3])

# leftover lines (sentences) from each source 
# will be different sizes
extra_twitter <- twitter[-samp1]
extra_news <- news[-samp3]
extra_blogs <- blogs[-samp2]

# write training text
con <- file("train.txt")
writeLines(train, con)
close(con)

# write extra lines for each source
con <- file("extra_twitter.txt")
writeLines(extra_twitter, con)
close(con)
con <- file("extra_news.txt")
writeLines(extra_news, con)
close(con)
con <- file("extra_blogs.txt")
writeLines(extra_blogs, con)
close(con)

# clean environment
rm(con)
rm(twitter, blogs, news)
rm(l_twitter, l_blogs, l_news)
rm(samp1, samp2, samp3)
rm(extra_twitter, extra_news, extra_blogs)
rm(train)
rm(perc, min_length, sample_length)


# load extra lines of text from each source

# set.seed(42315)
# l_left < length(extra)
# samp4 <- sample(1:l_left, size = (l_left*0.5))
# 
# # development and test sets
# dev <- extra[samp4]
# test <- extra[-samp4]
# 
# rm(samp4, l_left)

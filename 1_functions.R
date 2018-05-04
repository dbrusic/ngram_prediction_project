#### FUNCTIONS USED TO CREATE NGRAM MODEL ####

library(quanteda)
library(data.table)


#### Loading Text ####

# returns matrix of upper and lower index values for each chunk 
chunkIndex <- function(..., chunks = 10) {
        text <- list(...)
        names(text) <- as.list(sys.call())[2:(length(text)+1)]
        # make sure all text sources will have whole number quotients
        if(any(lengths(text) < chunks)) {
                return("chunks > number of lines")
        }
        lapply(text, function(x) {
                z <- as.integer(seq(0, length(x), by = length(x)/chunks))
                z[chunks+1] <- length(x)
                
                sapply(1:chunks, function(i) {
                        s <- z[i]+1
                        e <- z[i+1]
                        c(s,e)
                })
        })
}


#### Ngram Creation ####

# intial cleaning of text: lower case, encoding, underscores, urls 
string_clean <- function(txt) {
        # make lower case (base tolower function won't work on different encoded characters)
        txt <- char_tolower(txt)
        # replace different encodings with "AA" (to be taken out later)
        txt <- iconv(txt, "latin1", "ASCII", "AA")
        # replace underscores and non-break space with space
        txt <- gsub("[[:blank:]_]", " ", txt)
        # replace urls with "URL" (to be taken out later)
        txt <- gsub("[[:alnum:][:punct:]]*(http:|https:|www\\.|\\.com|\\.edu|\\.org|\\.net|\\.gov|\\.html)[[:alnum:][:punct:]]*", 
                    "URL", txt, perl = TRUE)
        # lines/strings must contain alphabetic characters
        txt <- txt[grep("[[:alpha:]]", txt, perl = TRUE)]
        return(txt)
}
# separate by quotations in sentences (not inline quotes but dialogue quotes: "He said, 'blahblah.'")
# not perfect because not every string follows perfect grammar for quotations (particularly in the twitter strings)
# fulltxt <- unlist(strsplit(fulltxt, split = "(, \")|(,\")|(\\.\")|(!\")|(\\?\")"))
# fulltxt <- fulltxt[grep("[[:alpha:]]", fulltxt, perl = TRUE)]

# meant to be used after text has been passed through cleaner_before function
# uses quanteda package and returns data table with ngram type counts
type_count <- function(txt, ng) {
        # txt should already all be lower case (except "AA" and "URL")
        toke <- tokens(txt, ngrams = as.integer(ng), 
                       remove_punct = TRUE,
                       remove_twitter = TRUE,
                       remove_symbols = TRUE,
                       remove_hyphens = FALSE,
                       remove_numbers = FALSE,
                       remove_url = FALSE,
                       concatenator = " ",
                       verbose = TRUE)
        toke_dfm <- dfm(toke, tolower = FALSE)
        toke_freq <- data.table(textstat_frequency(toke_dfm)[, 1:2])
        return(toke_freq)
}

# meant to be used on data table created from type_count function
# data table will have two columns: features and frequency
dt_clean <- function(dt) {
        toke_freq <- dt
        
        # remove ngrams that contain anything that is not alphabetic, space, apostrophe, or hyphen
        remove <- grep("[^[:alpha:][:space:]'-]", toke_freq$feature, perl = TRUE)
        toke_freq <- toke_freq[-remove]
        
        
        # further cleaning to remove foreign language characters, numbers, and urls
        # this is done now so that incorrect ngrams were not created  
        # (for example, so we do not get a bigram like "am_years_old"
        # from the string "i am 10 years old")
        
        # "AA" and "URL" (below) should be only capital characters at this point
        # remove ngrams that contain them
        
        # "AA" is marker given to foreign characters in string_clean function
        # "URL" was marker given to urls in cleaner_before function 
        remove <- grep("URL|AA", toke_freq$feature, perl = TRUE)
        toke_freq <- toke_freq[-remove]
        
        # remove ngrams that have repeated characters more than two times (e.g. blahhhhh)
        remove <- grep("(.)(\\1){2,}", toke_freq$feature, perl = TRUE)
        toke_freq <- toke_freq[-remove]
        return(toke_freq)
}

# split data table (toke_freq) into base and prediction;
# input data table should have two columns: feature and frequency
split_base_pred <- function(dt, ng) {
        if(ng == 1) {
                setnames(dt, "feature", "base")
        } else {
                reg <- paste("(.+", paste(rep("\\s.+", ng - 2), collapse = ""), ")\\s(.+)", sep = "")
                dt[, c("base", "pred") := .(sub(reg, "\\1", feature), 
                                            sub(reg, "\\2", feature))]
                dt[, feature := NULL]
                setcolorder(dt, c("base", "pred", "frequency"))
        }
}


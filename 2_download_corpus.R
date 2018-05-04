#### DOWNLOAD CORPUS FILES FROM COURSERA ####

# System Time: 2018-02-22 15:29:47 PST
# platform: x86_64-w64-mingw32          
# arch: x86_64                      
# os: mingw32                     
# system: x86_64, mingw32             
# status                                     
# major: 3                           
# minor: 4.3                         
# year: 2017                        
# month: 11                          
# day: 30                          
# svn rev: 73796                       
# language: R                           
# version.string R version 3.4.3 (2017-11-30)
# nickname: Kite-Eating Tree
# 
# sysname: Windows
# release: >= 8 x64
# version: build 9200
# machine: x86-64


#### ASSUMES DESIRED WORKING DIRECTORY HAS ALREADY BEEN SPECIFIED ####

# Download the data and unzip it in new directory called "corpora"
if(!file.exists("./corpora")) {
        dir.create("./corpora")
        temp <- tempfile()
        fileUrl <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
        download.file(fileUrl, destfile = temp)
        unzip(temp, exdir = "./corpora")
        unlink(temp)

        # Move English files
        corpus_dir <- "corpora/"
        blogs <- "en_US.blogs.txt"
        news <- "en_US.news.txt"
        twitter <- "en_US.twitter.txt"
        file.rename(from  = "corpora/final/en_US/en_US.blogs.txt",
                to = paste(corpus_dir, blogs, sep = ""))
        file.rename(from  = "corpora/final/en_US/en_US.news.txt",
                to = paste(corpus_dir, news, sep = ""))
        file.rename(from  = "corpora/final/en_US/en_US.twitter.txt",
                to = paste(corpus_dir, twitter, sep = ""))

        # Delete other files that are not in English
        unlink("corpora/final", recursive = TRUE)
}

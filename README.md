# Next Word Prediction Using N-gram Language Model
Daniel Brusic  
April, 2018
  
## Overview
This is the capstone project for the Coursera Data Science Specialization through Johns Hopkins. The task was to create a text prediction model using three sources of text: news articles, blog posts, and tweets. This prediction model was then utilized in a Shiny app that allows a user to input text and be given next word predictions.
  
The project uses these packages:

- data.table
- quanteda 
  
## Prediction Model
Five-grams, four-grams, tri-grams, and bi-grams were counted from the text sources and saved in a data table. Maximum likelihood estimates were then calculated for each unique n-gram. These probability estimates were then used to order the n-grams by their base (words that precede the last word of an n-gram), and only the top three n-grams for each base were kept. This data table can then be searched to suggest the most probable ending words to a particular n-gram base.
  
## R Scripts
The R scripts in this repository are numbered in the order that they should be run (if one wants to recreate the project). They assume that the desired working directory has been set and that each script is run inside that directory. This is important because some of the scripts create many rds files that will be aggregated together into one file in other scripts. 
  
Each script contains lines at the top that source the required project scripts. These lines are commented out so as to not re-run code (except for the functions script). Be aware that this project was done on a  machine with 4 gigabytes of RAM, which necessitated processing the text files in chunks.
  
  
[link](https://dbrusic.shinyapps.io/next_word_prediction) to Shiny App  
[link](https://rpubs.com/dbrusic/ngram_prediction_presentation) to RStudio Presentation
[link](https://github.com/dbrusic/ngram_prediction_shiny_app) to app GitHub repo


# ==================================================================================================
#                         Exploratory data analysis: Text Analytics                                #
#                                       Megan Beckett                                              #
# ==================================================================================================

# LIBRARIES ----------------------------------------------------------------------------------------
library(dplyr)
library(here)
library(tidyr)
library(tm)
library(wordcloud2)

# READ DATA ----------------------------------------------------------------------------------------
source(here::here("code/00_data.R"))

# TEXT ANALYTICS -----------------------------------------------------------------------------------
# Analyse the words used in TurtleCharacteristics
# Remove punctuation
gsub("[[:punct:]]", "", clean$TurtleCharacteristics)
clean$TurtleCharacteristics <- gsub("\"", "", clean)

# Create corpus
corpus = Corpus(VectorSource(clean$TurtleCharacteristics))

# Pre-process data
corpus <- tm_map(corpus, function(x) iconv(enc2utf8(x), sub = "byte"))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, PlainTextDocument)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

#corpus = tm_map(corpus, stemDocument)

corpus <- Corpus(VectorSource(corpus))

# Create matrix
dtm <- DocumentTermMatrix(corpus)

# Create data frame
words <- as.data.frame(as.matrix(dtm))

words <- words %>%
  gather(key = "word", value = "counts") %>%
  group_by(word) %>%
  summarise(count = sum(counts))

words_small <- words %>%
  filter(count > 10)

# Plot word cloud
wordcloud2(words_small)
#wordcloud2(words_small, figPath = here::here("turtle.png"))


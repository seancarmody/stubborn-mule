require(tm)
require(wordcloud)
library(plyr)
library(ggplot2)
library(reshape2)

if (!exists("clean")) clean <- TRUE

if (!exists("abbott")) {
  abbott <- Corpus(DirSource("abbott"))  
  
  meta.data <- read.csv("summary.csv", as.is=TRUE)
  rownames(meta.data) <- meta.data$filename
  
  idx <- names(abbott)
  meta(abbott, tag = "DateTimeStamp", type = "local") <-  meta.data[idx, "date"]
  meta(abbott, tag = "Heading", type = "local") <-  meta.data[idx, "title"]
  #meta(abbott, tag = "ID", type = "local") <-  meta.data[idx, "digest"]
  meta(abbott, tag = "source", type = "local") <-
    rep("http://www.tonyabbott.com.au", length(idx))
  meta(abbott, tag = "Author", type = "local") <- 
    rep("Tony Abbott", length(idx))
#  rm(meta.data, idx)
}

if (clean) {
  cleanText <- function(x) {
    x <- sub("'s", "", x)
    x <- removePunctuation(x)
    x <- stripWhitespace(x)
    x <- tolower(x)
    x
  }
  abbott <- tm_map(abbott, cleanText)
  abbott <- tm_map(abbott, removeWords, stopwords("english"))
}

tdm <- TermDocumentMatrix(abbott)
m <- as.matrix(tdm)
v <- sort(rowSums(m), decreasing=TRUE)
d <- data.frame(word=names(v), freq=v)

if (!exists("n.words")) n.words <- 50

png("wc.png", width=600, height=600)
par(mar=rep(0, 4), oma=rep(0, 4))

wordcloud(d$word[1:n.words], d$freq[1:n.words], scale=c(7, .7),
          colors=brewer.pal(6,"Dark2"), random.order=FALSE)
dev.off()

get_words <- function(words, label) {
  word.count <- as.data.frame(as.matrix(dtm[, words]))
  word.count$count <- rowSums(word.count)
  word.count$year <- as.numeric(substr(rownames(word.count), 1, 4))
  x <- ddply(word.count, .(year), summarise, count=sum(count))
  names(x)[2] <- label
  x
}

dtm <- DocumentTermMatrix(abbott)

word.list <- c("tax", "boat", "boats", "carbon", "howard", "reform")
word.freq <- as.data.frame(as.matrix(dtm[, word.list]))
word.freq$boat <- with(word.freq, boats + boat)
word.freq$boats <- NULL
word.freq$year <- as.numeric(substr(rownames(word.freq), 1, 4))

word.freq <- melt(word.freq, id="year", variable.name="word", value.name="freq")
word.freq <- ddply(word.freq, .(year, word), summarise, count=sum(freq))

ggplot(word.freq, aes(x=year, y=count)) +
  facet_wrap(~word) + geom_bar(stat="identity")
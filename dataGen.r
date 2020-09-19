library(tidytext)
library(dplyr)
library(tidyr)

fh_twitter <- file("./data/en_US/en_US.twitter.txt")
tw <- readLines(fh_twitter, encoding="UTF-8")
fh_blogs <- file("./data/en_US/en_US.blogs.txt")
bg <- readLines(fh_blogs, encoding="UTF-8")
fh_news <- file("./data/en_US/en_US.news.txt")
nw <- readLines(fh_news,  encoding="UTF-8")

set.seed(100)
blogs <- sample(bg,length(bg)/100,replace=TRUE)
twitter <- sample(tw,length(tw)/100,replace=TRUE)
news <- sample(nw,length(nw)/100,replace=TRUE)
tp <- function(x){
  gsub("http[[:alnum:]]*",'', x)
  gsub('http\\S+\\s*', '', x) ## Remove URLs
  gsub('\\b+RT', '', x) ## Remove RT
  gsub('#\\S+', '', x) ## Remove Hashtags
  gsub('@\\S+', '', x) ## Remove Mentions
  gsub('[[:cntrl:]]', '', x) ## Remove Controls and special characters
  gsub("\\d", '', x) ## Remove Controls and special characters
  gsub('[[:punct:]]', '', x) ## Remove Punctuations
  gsub("^[[:space:]]*","",x) ## Remove leading whitespaces
  gsub(' +',' ',x) ## Remove extra whitespaces
} 
twitter<-tp(twitter)
news<-tp(news)
blogs<-tp(blogs)

mytext <- tibble(text=c(twitter,news,blogs))
titles <-  c("word1", "word2")
for(num in c(1:6)) {
  ngrams <- mytext %>% unnest_tokens(ngram, text, token = "ngrams", n = num)
  total_words <- nrow(ngrams)
  ngrams <- ngrams %>% count(ngram, sort = TRUE,name="count")  %>% mutate( frequency = count / total_words)
  if(num>1) {
    ngrams <- ngrams %>% separate(ngram, titles, sep = ' (?=[^ ]+$)')
  }
  else {
    ngrams <- ngrams %>% rename(word2 = ngram)
  }
  saveRDS(ngrams,file=paste("data",num,".sav",sep=""))
}
grams.list <- list(readRDS(file="data1.sav"),readRDS(file="data2.sav"),readRDS(file="data3.sav"), readRDS(file="data4.sav"), readRDS(file="data5.sav"), readRDS(file="data6.sav"))

search <- function(x) {
  words <- strsplit(x," ")
  len <- length(words)
  if(len > 6) {
    words <- words[len-6:len]
  }
  else if(len == 0) {
    return(sample(grams.list[1],5,replace = TRUE))
  }
  for( n in c(len:2)) {
    word <- paste(unlist(words[len-n+1:len]),collapse =' ')
    print(word)
    ans <- as.data.frame(grams.list[n]) %>% filter(word1==word)
    if(nrows(ans) > 0) { 
      return(ans)
    }
  }
  return(sample(grams.list[1],5,replace = TRUE))
}

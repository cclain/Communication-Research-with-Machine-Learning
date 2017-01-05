

stem_data <- function(str_data,stopwords)
{
  str_data = gsub(',','',toString(wordStem(scan_tokenizer(removeWords(str_data,words=stopwords)))))
  return(str_data)
}


clean_data <- function(str_data)
{
  str_data = gsub("[^\x20-\x7e]"," ", str_data)
  str_data = gsub("(@|http)[^[:blank:]]*|[[:punct:]]|[[:digit:]]"," ", str_data)
  str_data = gsub("\\s+", " ", str_data)
  str_data = tolower(str_data)
  return(str_data)
}

processing_tm <- function (corp)
{
  dtm = DocumentTermMatrix(corp)
  dtm = removeSparseTerms(dtm,0.99); #remove words with sparse factor 0.9995 or up
  return(dtm) 
}

library(RTextTools) 
library(tm)
library(SnowballC)
library(RWeka)
library(stringr)
election <- read.csv('C:\\Users\\Administrator\\Desktop\\FINAL_CROWD.csv',header=TRUE,stringsAsFactors=FALSE)
election_text<-election$Tweet

myStopwords = c(stopwords('english'),'description','null','text','description','url','text','href','rel','nofollow','false','true','rt') #Define stopwords 
for (i in 1:length(election_text)) {election_text[i] = stem_data(clean_data(election_text[i]),myStopwords)}
dtm<-create_matrix(election_text, language="english", minWordLength=3, maxWordLength=Inf,removeNumbers=TRUE, removePunctuation=TRUE, removeStopwords=TRUE,  stemWords=FALSE, stripWhitespace=TRUE, toLower=TRUE, weighting=weightTf)  #Creates a document-term matrix that can be used in the "create_container" function.
features=as.matrix(dtm)
#write.csv(m,'C:\\Users\\Administrator\\Desktop\\dtm2.csv')


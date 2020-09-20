N-gram Predict Next Word
========================================================
author: Philip Chen
date: 9/20/2020
autosize: true

References:

Word Prediction App requirements
========================================================

This shiny app is a web based application that accepts user typed input and predicts the next word. The app is capstone project of Coursera course:
Key Highlights are:

- Utilizing dataset for Coursera, clean and process them into corpus.
- Generate N-Grams matrix base on the corpus. 
- Build predictive backoff algorithm that takes any text input, break them down to tokens, match them to ngram, and generate next word base on the frequency score to provide the prediction.
- build a usable shiny application. The user should be able to use this app easily to predict the words. 
- Optimize the N-gram predictive function to make the app work smoothly on server 

Model used
========================================================
N-gram approach:

Backoff algotherm


Model Implementation
========================================================
Pruned term document matrix (tdm) for each unigram, bigram, trigram, quadgram and grouped together and stored as a list: Ngram_Models <- list(quadgram = quadgram, trigram = trigram, bigram = bigram, unigram = unigram)

R script function predictText <- function (predictString, Ngram_Models) where predictString is user defined input text variable and Ngram_Models references the stored N-Grams.

The predictText function takes no more than the last 4 words of the input phrase and builds a table of all the matching N-Grams from quadgram to bigram lists and sorts by highest frequency.

The Stupid Backoff Variation is deployed by applying scores to each N-Gram based on the frequency count divided by the preceding N-Gram frequency count (n-1). e.g. “i had a dream” input would search for the top word results after “i had a”, “had a”, and “a”. All the N-Grams are matched and combined into a table and the highest score is the next predicted word.

The model was tested by sampling 300 random tweets from my Twitter timeline and predicting the next word after the first 5 words. The model had a 10% success rate which appears to be average based on Coursera commentary boards while could argue Twitter has difficult sentence structure.

Shinny App
========================================================

![plot of chunk unnamed-chunk-1](PPT-figure/unnamed-chunk-1-1.png)

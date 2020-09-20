#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidytext)
library(dplyr)
library(tidyr)
library(DT)


# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
    grams.list <- list(readRDS(file="./data/data1.sav"),
                       readRDS(file="./data/data2.sav"),
                       readRDS(file="./data/data3.sav"), 
                       readRDS(file="./data/data4.sav"),
                       readRDS(file="./data/data5.sav"), 
                       readRDS(file="./data/data6.sav"))
    top.list <- as.data.frame(grams.list[1])[1:100,]
    search <- function(x) {
        x <- tolower(x)
        words <- unlist(strsplit(x," "))
        len <- length(words)
        if(len > 5) {
            words <- tail(words, 5)
        }
        else if(len == 0) {
            return(sample_n(top.list,5,replace = FALSE))
        }
        for( n in c(len:1)) {
            word <- paste(unlist(tail(words,n)),collapse =' ')
            print(n)
            print(word)
            ans <- as.data.frame(grams.list[n+1]) %>% filter(word1==word)
            if(nrow(ans) > 0) { 
                return(ans)
            }
        }
        return(sample_n(top.list,5,replace = FALSE))
    }
    terms <- reactive({
        # Change when the "update" button is pressed...
        input$update
        # ...but not for anything else
        isolate({
            withProgress({
                setProgress(message = "Processing corpus...")
                getTermMatrix(input$selection)
            })
        })
    })
    output$pridict_var <- renderText({
        input$input
    })
    output$table <-  renderDataTable({
        ans<-search(input$input)
        ans %>% select(word2,frequency) %>% top_n(5)
    },options = list(paging = FALSE, searching = FALSE))
    
    observeEvent(input$table_cell_clicked,{
        info = input$table_cell_clicked
        word <- input$input
        # do nothing if not clicked yet, or the clicked cell is not in the 1st column
        if (!is.null(info$value)){
             updateTextInput(session, "input", value = paste(word, info$value))
        }
            
    })
})

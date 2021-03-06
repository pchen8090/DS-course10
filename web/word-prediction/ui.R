#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("N-gram word prediction"),

    # Sidebar with a slider input for number of bins

    # Show a plot of the generated distribution
    mainPanel(
        h2("Please enter the word:"),
        textInput("input", "Input", value = ""),
        textOutput("pridict_var"),
        h2("Prediction:"),
        
        fluidRow(
            column(6, DT::dataTableOutput("table")),
            column(6, plotOutput("plot"))
        ),
        h2("Please click the row in prediction table to continue:")
    )
    
))

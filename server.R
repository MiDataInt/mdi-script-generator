#----------------------------------------------------------------------
# script generator server logic
#----------------------------------------------------------------------

# load packages
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyBS)
library(data.table)

# load script generator elements
options <- fread("lib/options.csv")
source("lib/download.R", local = TRUE)

# OPTIONS TAB SERVER ACTIONS
addOptionsServer <- function(input, output, session){

    # automatically show option-relevant help when option is clicked
    observeEvent(input$RUN_MODE, {
        hide(selector = ".runMode")
        show(selector = paste0("#", paste("runMode", input$RUN_MODE, sep = "-")))
    })
}

# DOWNLOAD TAB SERVER ACTIONS
scriptContents <- reactiveVal(NULL)  
addDownloadServer <- function(input, output, session){
     
    # use all options to generate and preview the requested launcher script
    output$scriptContents <- renderText({
        setScriptContents(input)
        scriptContents <- scriptContents()
        req(scriptContents)
        scriptContents
    })

    # script download handler
    output$downloadScript <- downloadHandler(
        filename = function() {
            runMode <- input$RUN_MODE
            operatingSystem <- input$operatingSystem
            getScriptBasename(runMode, operatingSystem)
        },
        content = function(tempFile) {
            cat(scriptContents(), file = tempFile)
        }
    )
}

# MAIN SERVER FUNCTION: this is the function called by Shiny RunApp
server <- function(input, output, session){
    addOptionsServer(input, output, session)
    addDownloadServer(input, output, session)
}

#----------------------------------------------------------------------
# script generator server logic
#----------------------------------------------------------------------

# load packages
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyBS)
library(data.table)
library(markdown)

# load script generator elements
options <- fread("lib/options.csv")
source("lib/download.R", local = TRUE)

# OPTIONS TAB SERVER ACTIONS
showAdvancedOptions <- reactiveVal(FALSE)
addOptionsServer <- function(input, output, session){

    # disaply the appropriate set of options based on run mode
    observe({
        hide(selector = ".runMode")
        show(selector = paste0("#", paste("runMode", input$RUN_MODE, sep = "-")))
        toggle(selector = ".advanced", condition = showAdvancedOptions())
    })

    # toggle the display of advanced options
    observeEvent(showAdvancedOptions(), {
        showAdvancedOptions <- showAdvancedOptions()
        toggle('showAdvancedOptionsWrapper', condition = !showAdvancedOptions)
        toggle('hideAdvancedOptionsWrapper', condition =  showAdvancedOptions)
    })
    observeEvent(input$showAdvancedOptions, {
        showAdvancedOptions(TRUE)
    })
    observeEvent(input$hideAdvancedOptions, {
        showAdvancedOptions(FALSE)
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

#----------------------------------------------------------------------
# set up the UI dashboard and launch page (i.e., the interface for first file upload)
#----------------------------------------------------------------------

# load packages
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyBS)
library(data.table)

# load script generator elements
options <- fread("lib/options.csv")
source("lib/options.R", local = TRUE)
source("lib/download.R", local = TRUE)

#----------------------------------------------------------------------
# STYLES AND SCRIPTS, loaded into html <head>
#----------------------------------------------------------------------
htmlHeadElements <- tags$head(
    tags$link(rel = "icon", type = "image/png", href = "logo/favicon-16x16.png"), # favicon
    tags$link(href = "framework.css", rel = "stylesheet", type = "text/css"), # framework js and css
    tags$script(src = "framework.js", type = "text/javascript", charset = "utf-8")
)

#----------------------------------------------------------------------
# TAB ITEMS UI
#----------------------------------------------------------------------
overviewTabUI <- tabItem(tabName = "overviewTab", tags$div(
    class = "text-block",
    includeMarkdown( file.path('static/mdi-intro.md') )
))
#----------------------------------------------------------------------
configureTabUI <- tabItem(tabName = "configureTab", tags$span(
    fluidRow(
        class = "configureTab-fluidRow",
        column(
            width = 5,
            tags$div(
                class = "configureTab-scrolling",
                style = "padding-right: 0.5em; overflow: auto;",
                tags$h3("Options"),
                tags$div(
                    class = "option-input",
                    "data-help" = paste('RUN_MODE', 'help', sep = "-"),
                    selectInput('RUN_MODE', "MDI Run Mode", choices = runModes, width = "100%")  
                ),
                getAllOptionInputs()
            )
        ), 
        column(
            width = 7,
            tags$div(
                class = "configureTab-scrolling",
                style = "padding-right: 0.5em; overflow: auto;",
                tags$div(
                    id = paste('RUN_MODE', 'help', sep = "-"),
                    class = "option-help",
                    includeMarkdown("static/options/RUN_MODE.md")
                ),
                lapply(options$option, function(optionName){
                    mdFile <- file.path('static', 'options', paste0(optionName, '.md'))
                    tags$div(
                        id = paste(optionName, 'help', sep = "-"),
                        class = "option-help",
                        style = "display: none;",
                        if(file.exists(mdFile)) includeMarkdown(mdFile) else ""
                    )
                })
            )
        )
    )
))
#----------------------------------------------------------------------
downloadTabUI <- tabItem(tabName = "downloadTab", tags$div(
    class = "downloadTab-scrolling",
    style = "margin-top: 1em; max-width: 800px; overflow: auto;",
    includeMarkdown(file.path('static', paste0('download1', '.md'))),
    radioButtons(
        "operatingSystem",
        label = "Local Operating System",
        choices = operatingSystems,
        inline = TRUE
    ),
    tags$hr(),
    includeMarkdown(file.path('static', paste0('download2', '.md'))),
    downloadButton(
        'downloadScript', 
        label = "Download Script", 
        class = NULL, 
        style = "margin-top: 1em; color: white; background-color: rgb(0,0,200); border-radius: 5px; display: none;" # nolint
    ),
    tags$hr(),
    verbatimTextOutput('scriptContents')
))
#----------------------------------------------------------------------
shareTabUI <- tabItem(tabName = "shareTab", tags$div(class = "text-block",
    tags$div(

    )
))

#----------------------------------------------------------------------
# MAIN UI FUNCTION: this is the function called by Shiny RunApp
#----------------------------------------------------------------------
ui <- function(request){
    # cookie <- parseCookie(request$HTTP_COOKIE) # parseCookie is an MDI-encoded helper function
    # queryString <- parseQueryString(request$QUERY_STRING) # parseQueryString is an httr function
    dashboardPage(
        dashboardHeader(
            title = "MDI",
            titleWidth = "175px"
        ),
        dashboardSidebar(
            # the dashboard option selectors, filled dynamically per app after first data load
            sidebarMenu(
                id = "sidebarMenu", 
                menuItem(tags$div('Script Generator',  class = "app-step"), tabName = "overviewTab"),
                menuItem(tags$div('1 - Configure',     class = "app-step"), tabName = "configureTab"),
                menuItem(tags$div('2 - Download',      class = "app-step"), tabName = "downloadTab"),
                menuItem(tags$div('3 - Share',         class = "app-step"), tabName = "shareTab")
            ),
            htmlHeadElements, # yes, place the <head> content here (even though it seems odd)
            width = "175px" # must be here, not in CSS
        ),
    
        # body content, i.e., panels associated with each dashboard option
        dashboardBody(
            useShinyjs(), # enable shinyjs
            tabItems(
                overviewTabUI,
                configureTabUI,
                downloadTabUI,
                shareTabUI
            )
        )
    )   
}

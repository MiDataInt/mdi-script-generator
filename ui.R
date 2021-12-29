#----------------------------------------------------------------------
# set up the UI dashboard and launch page (i.e., the interface for first file upload)
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
source("lib/options.R",  local = TRUE)
source("lib/download.R", local = TRUE)
includeMarkdownFile <- function(folder, file){
    includeMarkdown( file.path('static', folder, paste0(file, '.md') ) )
}

#----------------------------------------------------------------------
# STYLES AND SCRIPTS, loaded into html <head>
#----------------------------------------------------------------------
htmlHeadElements <- tags$head(
    tags$link(rel = "icon", type = "image/png", href = "logo/favicon-16x16.png"), # favicon
    tags$link(href = "framework.css", rel = "stylesheet", type = "text/css"), # framework js and css
    tags$link(href = "documentation.css", rel = "stylesheet", type = "text/css"), # documentation styles, mainly graphics # nolint
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
                tags$h3(
                    "Options", 
                    tags$span(
                        id = "showAdvancedOptionsWrapper",
                        style = "font-size: 15px; margin-left: 0.75em;",
                        actionLink('showAdvancedOptions', "Show Advanced Options")
                    ),
                    tags$span(
                        id = "hideAdvancedOptionsWrapper",
                        style = "font-size: 15px; margin-left: 0.75em;",
                        actionLink('hideAdvancedOptions', "Hide Advanced Options")
                    ),
                ),
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
                    includeMarkdownFile("options", "RUN_MODE")
                ),
                lapply(options$option, function(optionName){
                    mdFile <- file.path('static', 'options', paste0(optionName, '.md'))
                    tags$div(
                        id = paste(optionName, 'help', sep = "-"),
                        class = "option-help",
                        style = "display: none;",
                        if(file.exists(mdFile)) includeMarkdown(mdFile) else "PENDING"
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
    includeMarkdownFile("download", "os"),
    radioButtons(
        "operatingSystem",
        label = "Local Operating System",
        choices = operatingSystems,
        inline = TRUE
    ),
    tags$hr(),
    includeMarkdownFile("download", "link"),
    downloadButton(
        'downloadScript', 
        label = "Download Script", 
        style = "margin-top: 1em; color: white; background-color: rgb(0,0,200); border-radius: 5px; display: none;" # nolint
    ),
    tags$hr(),
    verbatimTextOutput('scriptContents')
))
#----------------------------------------------------------------------
usageTabUI <- tabItem(tabName = "usageTab", tags$div(class = "text-block usageTab-scrolling",
    includeMarkdownFile("usage", "header"),
    fluidRow(
        tabBox(
            width = 12,
            tabPanel(
                title = "Windows",
                includeMarkdownFile("usage", "windows")
            ),
            tabPanel(
                title = "Mac / Linux",
                includeMarkdownFile("usage", "mac")
            )
        )        
    ),
    includeMarkdownFile("usage", "footer")
))

#----------------------------------------------------------------------
# MAIN UI FUNCTION: this is the function called by Shiny RunApp
#----------------------------------------------------------------------
ui <- function(request){
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
                menuItem(tags$div('3 - Usage',         class = "app-step"), tabName = "usageTab")
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
                usageTabUI
            )
        )
    )   
}

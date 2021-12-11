#----------------------------------------------------------------------
# set up the UI dashboard and launch page (i.e., the interface for first file upload)
#----------------------------------------------------------------------

# load packages
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyBS)

# source scripts
source("options.R")

# STYLES AND SCRIPTS, loaded into html <head>
htmlHeadElements <- tags$head(
    tags$link(rel = "icon", type = "image/png", href = "logo/favicon-16x16.png"), # favicon
    tags$link(href = "framework.css", rel = "stylesheet", type = "text/css"), # framework js and css
    tags$script(src = "framework.js", type = "text/javascript", charset = "utf-8")
)

# TAB ITEMS UI
overviewTabUI <- tabItem(tabName = "overviewTab", tags$div(
    class = "text-block",
    includeMarkdown( file.path('static/mdi-intro.md') )
))
configureTabUI <- tabItem(tabName = "configureTab", tags$span(
    fluidRow(
        column(
            width = 4,
            tags$div(
                style = "height: 750px; overflow: auto;",
                lapply(names(scriptOptions), function(name){
                    x <- scriptOptions[[name]]
                    placeholder <- if(!is.null(x$placeholder)) x$placeholder
                                else if(!is.null(placeholders[[x$type]])) placeholders[[x$type]]
                                else ""
                    tags$div(
                        class = "option-input",
                        style = "margin-top: 0.5em;",
                        "data-help" = paste(name, 'help', sep = "-"),
                        if(x$type == "select") selectInput(name, x$label, choices = x$choices, width = "100%")
                        else if(x$type == "checkbox") checkboxGroupInput(name, x$label, choices = "", width = "100%")
                        else textInput(name, x$label, value = x$default, placeholder = placeholder, width = "100%") # nolint                  
                    )
                })                     
            )
        ), 
        column(
            width = 8,
            tags$div(
                class = "option-help",
                tags$h4("Instructions"),
                tags$p("Click into any input to show option-specific help.")
            ),
            lapply(names(scriptOptions), function(name){
                x <- scriptOptions[[name]]
                mdFile <- file.path('static', 'options', paste0(name, '.md'))
                tags$div(
                    id = paste(name, 'help', sep = "-"),
                    class = "option-help",
                    style = "display: none;",
                    if(file.exists(mdFile)) includeMarkdown(mdFile) else ""
                )
            })   
        )
    )
))
downloadTabUI <- tabItem(tabName = "downloadTab", tags$div(class = "text-block",
    tags$div(

    )
))
shareTabUI <- tabItem(tabName = "shareTab", tags$div(class = "text-block",
    tags$div(

    )
))

# MAIN UI FUNCTION: this is the function called by Shiny RunApp
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

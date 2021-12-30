#----------------------------------------------------------------------
# script option definitions and processing functions
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# quick start options, from the Overview tab
#----------------------------------------------------------------------
quickStart <- list(
    "Local Computer"    = "local",
    "UM Great Lakes"    = "node",
    "AWS Public Server" = "public"
)
quickStartOptions <- function(mode){
    if(mode == "local"){ tagList(
        textInput("quickStartRDirectory", "R Source Directory", 
                    placeholder = "required unless Rscript executable is in PATH", width = "100%")

    )} else if(mode == "node"){tagList( # i.e., greatlakes
        textInput("quickStartRVersion", "R Version", value = "4.1.0",
                    placeholder = "e.g., 4.1.0, required", width = "100%"),
        textInput("quickStartUsername", "Username", 
                    placeholder = "required", width = "100%"),
        textInput("quickStartAccount", "Slurm Account", 
                    placeholder = "e.g., johndoe99, required", width = "100%")

    )} else if(mode == "public"){tagList( # i.e., AWS
        textInput("quickStartDomain",  "Server Web Domain", 
                    placeholder = "e.g., my-mdi.io, required", width = "100%"),
        textInput("quickStartKeyFile", "SSH Key File Path",   
                    placeholder = "required", width = "100%")
    )}
}
checkQuickStartOptions <- function(input){
    if(input$quickStartMode == "node"){ # i.e., greatlakes
        req(input$quickStartRVersion)
        req(input$quickStartUsername)
        req(input$quickStartAccount)

    } else if(input$quickStartMode == "public"){ # i.e., AWS
        req(input$quickStartDomain)
        req(input$quickStartKeyFile)
    }
}

#----------------------------------------------------------------------
# full options, from the Configure tab
#----------------------------------------------------------------------

# the ways that the MDI can be run
runModes <- list(
    "--"                = "",
    "Local Computer"    = "local",
    "Remote Server"     = "remote",
    "Cluster Node"      = "node",
    "AWS Public Server" = "public"
)

# functions to create option inputs on the configureTab
getOptionInput <- function(option, runMode){
    optionName <- option$option
    id <- paste(runMode, optionName, sep = "-")
    value <- if(is.na(option$default)) NULL else option$default
    selected <- if(option$type == "checkbox" && value == TRUE) "" else NULL
    label <- if(option[[runMode]] == "required"){
        HTML(paste(option$label, tags$span("**", style = "color: rgb(200,0,0); font-size: 1.1em;")))
    } else option$label
    tags$div(
        class = paste("option-input", if(option$advanced) "advanced" else ""),
        style = "margin-top: 0.5em;",
        "data-help" = paste(optionName, 'help', sep = "-"),
        if(option$type == "integer") numericInput(id, label, value = value, width = "100%")
        else if(option$type == "checkbox") checkboxGroupInput(id, label, choices = "", selected = selected, width = "100%") # nolint
        else textInput(id, label, value = value, width = "100%")         
    )
}
getFamilyInputs <- function(familyOptions, runMode){
    lapply(seq_len(nrow(familyOptions)), function(i) getOptionInput(familyOptions[i], runMode))
}
getRunModeInputs <- function(runMode){
    modeOptions <- options[!is.na(options[[runMode]])]
    tags$span(
        id = paste("runMode", runMode, sep = "-"),
        class = "runMode",
        style = "display: none;",
        lapply(unique(modeOptions$family), function(familyName){
            tags$span(
                tags$hr(),
                getFamilyInputs(modeOptions[family == familyName], runMode)
            )
        })
    )
}
getAllOptionInputs <- function(){
    lapply(runModes[runModes != ""], getRunModeInputs)
}

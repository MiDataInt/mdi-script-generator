#----------------------------------------------------------------------
# script option definitions and processing functions
#----------------------------------------------------------------------

# the ways that the MDI can be run
runModes <- list(
    "--" = "",
    "Local" = "local",
    "Remote Server" = "remote",
    "Cluster Node" = "node",
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
        class = "option-input",
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

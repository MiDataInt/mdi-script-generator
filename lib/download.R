#----------------------------------------------------------------------
# download options and actions
#----------------------------------------------------------------------

# the local operating systems we can write scripts for
operatingSystems <- c(
    "Windows" = "windows",
    "Mac or Linux" = "unix"
)

# the name of the template script file
getScriptBasename <- function(runMode, operatingSystem){
    script <- paste("mdi", runMode, sep = "-")
    extension <- if(operatingSystem == "windows") "bat" else "sh"
    paste(script, extension, sep = ".")
}

# parse inputs into values for scripts
getScriptValue <- function(runMode, optionName, option, input){ 
    id <- paste(runMode, optionName, sep = "-")
    value <- input[[id]]
    if(option$type == "checkbox"){ # strings are single-quoted, TRUE, FALSE, NULL and integer are bare strings
        if(!is.null(value) && value == "") "TRUE" else "FALSE"
    } else if(option$type == "text"){ 
        if(value == "") {
            "NULL"
        } else if(optionName == "R_DIRECTORY"){ # special handling of this value for Windows local scripts
            gsub('\\', '/', value, fixed = TRUE)
        } else {
            x <- paste0("'", value, "'")
            gsub('\\', '/', x, fixed = TRUE) # coerce all file paths to unix-compatible
        }
    } else { 
        value # numeric
    }
} 

# required options cannot be NULL
checkScriptValue <- function(runMode, option, value){ 
    if(option[[runMode]] != 'required') return(TRUE)
    value != "NULL"
}

# fill the reactiveVal with a script reflecting current option values
setScriptContents <- function(input){

        # check inputs required to set the required script template
        scriptContents(NULL)
        hide('downloadScript')
        runMode <- input$RUN_MODE
        req(runMode)
        operatingSystem <- input$operatingSystem
        req(operatingSystem)

        # get the required script template
        template <- getScriptBasename(runMode, operatingSystem)
        fileName <- file.path("script-templates", template)
        template <- readChar(fileName, file.info(fileName)$size)
        template <- gsub('\r', '', template) # remove Windows return characters

        # fill the script template with option values by string replacement
        modeOptions <- options[!is.na(options[[runMode]])]
        for(optionName in modeOptions$option){
            option <- modeOptions[option == optionName]
            value <- getScriptValue(runMode, optionName, option, input)
            if(!checkScriptValue(runMode, option, value)) return(NULL)
            template <- gsub(paste0("__", optionName, "__"), value, template)
        }

        # if successful, save and preview the script contents
        scriptContents(template)
        show('downloadScript')
}

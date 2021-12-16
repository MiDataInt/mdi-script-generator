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
getScriptValue <- function(runMode, optionName, option, input, operatingSystem){ 
    id <- paste(runMode, optionName, sep = "-")
    value <- input[[id]]
    if(option$type == "checkbox"){
        if(!is.null(value) && value == "") "TRUE" else "FALSE"
    } else if(option$type == "text"){ 

        # handle string nulls
        if(value == "" || value == "NULL" || value == "NA") {
            if(optionName == "R_LOAD_COMMAND") "echo" 
            else if(optionName == "IDENTITY_FILE") ""
            else "NULL"

        # coerce all file paths to unix-compatible    
        } else {
            value <- gsub('\\', '/', value, fixed = TRUE) 

            # coerce MDI_DIRECTORY so that it always ends in /mdi
            if(optionName == "MDI_DIRECTORY" && !endsWith(value, '/mdi')){
                value <- file.path(value, "mdi")
            }

            # coerce IDENTITY_FILE to a proper ssh argument
            if(optionName == "IDENTITY_FILE"){
                if(operatingSystem == "windows") value <- paste0('"', value, '"') # account for spaces in file path
                value <- paste('-i', value)
            }

            # apply single quotes to certain values for proper parsing of Windows bat files
            if(runMode == 'local' && 
               !is.na(option$quote_local) && 
               option$quote_local == TRUE) value <- paste0("'", value, "'")
            value
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
            value <- getScriptValue(runMode, optionName, option, input, operatingSystem)
            if(!checkScriptValue(runMode, option, value)) return(NULL)
            template <- gsub(paste0("__", optionName, "__"), value, template)

            # simplify passing of space-containing load commands to server
            if(optionName == "R_LOAD_COMMAND"){
                maskedName <- "R_LOAD_COMMAND_MASKED"
                maskedValue <- gsub(' ', '~~', value)
                template <- gsub(paste0("__", maskedName, "__"), maskedValue, template)
            }
        }

        # if successful, save and preview the script contents
        scriptContents(template)
        show('downloadScript')
}

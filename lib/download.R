#----------------------------------------------------------------------
# download options and actions
#----------------------------------------------------------------------

# the local operating systems we can write scripts for
operatingSystems <- c(
    "Windows" = "windows",
    "Mac or Linux" = "unix"
)
operatingSystemInput <- function(id = "operatingSystem"){
    radioButtons(
        id,
        label = "Local Operating System",
        choices = operatingSystems,
        inline = TRUE
    )
}

# the name of the template script file
getScriptBasename <- function(runMode, operatingSystem){
    script <- paste("mdi", runMode, sep = "-")
    extension <- if(operatingSystem == "windows") "bat" else "sh"
    paste(script, extension, sep = ".")
}

# formatted download button
scriptDownloadButton <- function(id, display = "none"){
    downloadButton(
        id, 
        label = "Download Script", 
        style = paste("margin-top: 1em; color: white; background-color: rgb(0,0,200); border-radius: 5px; display:", display) # nolint
    )
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
            if((optionName == "MDI_DIRECTORY" ||
                optionName == "HOST_DIRECTORY") && !endsWith(value, '/mdi')){
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
getQuickStartValue <- function(runMode, optionName, option, input, operatingSystem){
    nullOptions  <- c("HOST_DIRECTORY", "DATA_DIRECTORY")
    falseOptions <- c("DEVELOPER")
    if(optionName == "MDI_DIRECTORY"){
        "~/mdi"
    } else if (optionName %in% nullOptions){
        "NULL"
    } else if (optionName %in% falseOptions){
        "FALSE"
    }

}

Installation Parameters,R_LOAD_COMMAND,R Load Command,text,FALSE,NA,NA,optional,optional,NA,NA
Installation Parameters,R_DIRECTORY,R Source Directory,text,FALSE,NA,optional,NA,NA,NA,FALSE
Installation Parameters,INSTALL_PACKAGES,Install R Packages,checkbox,TRUE,TRUE,optional,optional,optional,NA,NA
Installation Parameters,ADD_TO_PATH,Add to PATH,checkbox,TRUE,FALSE,NA,optional,optional,NA,NA
Server Information,SERVER_URL,Server Domain,text,FALSE,NA,NA,required,required,required,NA
Server Information,USER,Server Username,text,FALSE,NA,NA,required,required,NA,NA
Server Information,IDENTITY_FILE,Identity Key File,text,FALSE,NA,NA,optional,optional,optional,NA
Ports,SHINY_PORT,R Shiny Port,integer,TRUE,3838,required,required,required,NA,FALSE
Ports,PROXY_PORT,Local Proxy Port,integer,TRUE,1080,NA,NA,required,NA,NA
Cluster Job Parameters,CLUSTER_ACCOUNT,Cluster Account,text,FALSE,NA,NA,NA,optional,NA,NA
Cluster Job Parameters,JOB_TIME_MINUTES,Job Time Minutes,integer,FALSE,120,NA,NA,optional,NA,NA
Cluster Job Parameters,CPUS_PER_TASK,CPUs per Task,integer,TRUE,2,NA,NA,required,NA,NA
Cluster Job Parameters,MEM_PER_CPU,Memory per CPU,text,TRUE,4g,NA,NA,required,NA,NA
Run Parameters,DEVELOPER,Developer Mode,checkbox,TRUE,FALSE,optional,optional,optional,NA,NA


# required options cannot be NULL
checkScriptValue <- function(runMode, option, value){ 
    if(option[[runMode]] != 'required') return(TRUE)
    value != "NULL"
}

# fill the reactiveVal with a script reflecting current option values
getScriptContents <- function(input, runMode, operatingSystem, getFn, checkFn){

    # get the required script template
    template <- getScriptBasename(runMode, operatingSystem)
    fileName <- file.path("script-templates", template)
    template <- readChar(fileName, file.info(fileName)$size)
    template <- gsub('\r', '', template) # remove Windows return characters    

    # fill the script template with option values by string replacement
    modeOptions <- options[!is.na(options[[runMode]])]
    for(optionName in modeOptions$option){
        option <- modeOptions[option == optionName]
        value <- getFn(runMode, optionName, option, input, operatingSystem)
        if(!checkFn(runMode, option, value)) return(NULL)
        template <- gsub(paste0("__", optionName, "__"), value, template)

        # simplify passing of space-containing load commands to server
        if(optionName == "R_LOAD_COMMAND"){
            maskedName <- "R_LOAD_COMMAND_MASKED"
            maskedValue <- gsub(' ', '~~', value)
            template <- gsub(paste0("__", maskedName, "__"), maskedValue, template)
        }
    }
}
setScriptContents <- function(input){

    # check inputs required to set the required script template
    scriptContents(NULL)
    hide('downloadScript')
    runMode <- input$RUN_MODE
    req(runMode)
    operatingSystem <- input$operatingSystem
    req(operatingSystem)

    # if successful, save and preview the script contents
    x <- getScriptContents(input, runMode, operatingSystem, getScriptValue, checkScriptValue)
    scriptContents(x)
    show('downloadScript')
}

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

            # # coerce Singularity container version to start with 'v'
            # if(optionName == "R_VERSION"){
            #     if(!startsWith(value, 'v')) value <- paste0('v', value) 
            # }

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

    # set handling for all quick start options
    # three quick start types are local, node (i.e., greatlakes) and public (i.e., AWS)
    qsOptions <- list( # options determined by the small number of quick start inputs
        MDI_DIRECTORY = function(){
            value <- "~/mdi"
            if(runMode == "local") value <- paste0("'", value, "'")
            value
        },
        R_DIRECTORY = function(){ # only applicable to local
            value <- input$quickStartRDirectory
            value <- gsub('\\', '/', value, fixed = TRUE) 
            if(value == "") "NULL" else value # but is not required
        },
        # R_VERSION = function(){ # only applicable to greatlakes/node
        #     input$quickStartRVersion
        # },
        USER = function(){ # only applicable to greatlakes/node
            input$quickStartUsername
        }, 
        CLUSTER_ACCOUNT = function(){ # only applicable to greatlakes/node
            input$quickStartAccount
        },
        SERVER_URL = function(){
            if(runMode == "node") "greatlakes.arc-ts.umich.edu"
            else if(runMode == "public") input$quickStartDomain
            else NA # local mode has no server
        },
        IDENTITY_FILE = function(){
            if(runMode == "public"){ # AWS servers must have a key file, greatlakes/local never do
                value <- input$quickStartKeyFile
                value <- gsub('\\', '/', value, fixed = TRUE) 
                if(operatingSystem == "windows") value <- paste0('"', value, '"')
                paste('-i', value)
            } else ""
        }
    )
    nullOptions  <- c("HOST_DIRECTORY", "DATA_DIRECTORY") # quick start installations are never hosted or shared
    trueOptions  <- c("INSTALL_PACKAGES") # quick start is assumed to want to run the apps server
    falseOptions <- c("ADD_TO_PATH", "DEVELOPER") # but never in developer mode, i.e., is for end users

    # parse quick start options
    if (optionName %in% names(qsOptions)) qsOptions[[optionName]]()
    else if (optionName %in% nullOptions)  "NULL"
    else if (optionName %in% trueOptions)  "TRUE"
    else if (optionName %in% falseOptions) "FALSE"
    else option$default # as found in options.csv
}

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
    template
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

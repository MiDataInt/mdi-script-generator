#----------------------------------------------------------------------
# script option definitions
#----------------------------------------------------------------------

# input box placeholders
placeholders <- list(
    directory = "directory path",
    rVersion = "4.1.0",
    port = "port number"
)

# script options
scriptOptions <- list(

    # MDI run mode
    runMode = list(
        label = "MDI Run Mode",
        type = "select",
        choices = c(
            "Local" = "local",
            "Remote Server" = "remote",
            "Cluster Node" = "node" 
        )
    ),

    # R installation options
    rSource = list(
        label = "R Load Source",
        type = "text"
    ),
    # rLoadCommand = list(
    #     label = "R Load Command",
    #     type = "text"
    # ),
    # rDirectory = list(
    #     label = "R Installation Directory",
    #     type = "directory"
    # ),
    # rVersion = list(
    #     label = "R Version",
    #     type = "rVersion"
    # ),

    # mdi, host and data directories
    mdiDir = list(
        label = "Installation Directory",
        type = "directory",
        default = "~"
    ),
    hostDir = list(
        label = "Host Directory",
        type = "directory"
    ),    
    dataDir = list(
        label = "Data Directory",
        type = "directory"
    ),

    # server options
    serverUrl = list(
        label = "Server URL",
        type = "url"
    ),
    user = list(
        label = "Username on Server",
        type = "text"
    ),

    # installation options
    installPackages = list(
        label = "Install Packages",
        type = "checkbox",
        value = FALSE
    ),
    # addToPATH = list(
    #     label = "Add to PATH",
    #     type = "checkbox",
    #     value = FALSE
    # ),

    # port values
    shinyPort = list(
        label = "R Shiny Port",
        type = "port",
        default = 3838
    ),
    proxyPort = list(
        label = "Local Proxy Port",
        type = "port",
        default = 1080
    ),

    # cluster options
    account = list(
        label = "Cluster Account",
        type = "text"
    ),
    jobTimeMinutes = list(
        label = "Job Time Minutes",
        type = "text",
        default = 120
    ),
    cpusPerTask = list(
        label = "R Shiny Port",
        type = "text",
        default = 1
    ),
    memPerCpu = list(
        label = "RAM per CPU",
        type = "text",
        default = "4g"
    ),

    # developer flag
    developer = list(
        label = "Developer Mode",
        type = "checkbox"
    )
)

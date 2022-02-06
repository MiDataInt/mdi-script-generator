# ----------------------------------------------------------------
# launch the MDI web server and browser client in 'remote' mode
#     web server  runs on a remote server on the login node
#     web browser runs on a user's local desktop/laptop computer
#     communication from browser to server is via SSH local port forwarding
#     thus, address entered into web browser is "http://127.0.0.1:SHINY_PORT"
# -----------------------------------------------------------------------
# this script was generated by https://wilsonte-umich.shinyapps.io/mdi-script-generator/
# GitHub repository for script generator: https://github.com/MiDataInt/mdi-script-generator
# script template author: Thomas E. Wilson, https://wilsonte-umich.github.io/
# ----------------------------------------------------------------

# -----------------------------------------------------------------------
# set variable values
# -----------------------------------------------------------------------
MDI_DIRECTORY="__MDI_DIRECTORY__"
HOST_DIRECTORY="__HOST_DIRECTORY__"
DATA_DIRECTORY="__DATA_DIRECTORY__"
R_LOAD_COMMAND="__R_LOAD_COMMAND__"
R_LOAD_COMMAND_MASKED="__R_LOAD_COMMAND_MASKED__"
R_VERSION="__R_VERSION__"
INSTALL_PACKAGES="__INSTALL_PACKAGES__"
SERVER_URL="__SERVER_URL__"
USER="__USER__"
IDENTITY_FILE="__IDENTITY_FILE__"
SHINY_PORT=__SHINY_PORT__
DEVELOPER="__DEVELOPER__"

# -----------------------------------------------------------------------
# prompt the user for the requested action
# -----------------------------------------------------------------------
while true; do 
# -----------------------------------------------------------------------
ACTION_NUMBER=""
echo
echo "Welcome to the Michigan Data Interface."
echo
echo "  $USER""@""$SERVER_URL:$SHINY_PORT"
echo "  MDI_DIRECTORY    $MDI_DIRECTORY"
echo "  HOST_DIRECTORY   $HOST_DIRECTORY"
echo "  DATA_DIRECTORY   $DATA_DIRECTORY"
echo "  R_LOAD_COMMAND   $R_LOAD_COMMAND"
echo "  R_VERSION        $R_VERSION"
echo "  DEVELOPER        $DEVELOPER"
echo
echo "What would you like to do?"
echo
echo "  1 - use nano to edit one of the server configuration files"
echo "  2 - (re)install the MDI on the remote server via SSH"
echo "  3 - run the MDI web interface (local browser, remote server via SSH)"
echo "  4 - bring up an interactive bash terminal on the server"
echo "  5 - exit and do nothing"
echo
echo "Select an action by its number: "
read ACTION_NUMBER

# -----------------------------------------------------------------------
# request the server file to edit
# -----------------------------------------------------------------------
if [ "$ACTION_NUMBER" = "1" ]; then
    echo
    echo "Please select the server file you would like to edit."
    echo
    echo "  1 - suites.yml            pipelines and apps suites to install"
    echo "  2 - stage1-pipelines.yml  system defaults for pipeline execution"
    echo "  3 - stage2-apps.yml       access control options for the apps server"
    echo "  4 - singularity.yml       optional command to load Singularity"
    echo "  5 - exit and do nothing"
    echo
    echo "Select a file to edit by its number: "
    read FILE_NUMBER
    if [ "$FILE_NUMBER" = "1" ]; then
        FILE_NAME=suites.yml
    elif [ "$FILE_NUMBER" = "2" ]; then
        FILE_NAME=stage1-pipelines.yml
    elif [ "$FILE_NUMBER" = "3" ]; then
        FILE_NAME=stage2-apps.yml
    elif [ "$FILE_NUMBER" = "4" ]; then
        FILE_NAME=singularity.yml
    else
        exit
    fi
    ssh $IDENTITY_FILE -o "StrictHostKeyChecking no" $USER@$SERVER_URL -t nano $MDI_DIRECTORY/config/$FILE_NAME

# -----------------------------------------------------------------------
# act on a requested 'install' action
# -----------------------------------------------------------------------
elif [ "$ACTION_NUMBER" = "2" ]; then

    # prompt for installation permission
    IP_MESSAGE="-"
    if [ "$INSTALL_PACKAGES" = "TRUE" ]; then
        IP_MESSAGE="- install or update R packages"
    fi
    echo
    echo "------------------------------------------------------------------"
    echo "PLEASE CONFIRM MDI INSTALLATION ACTIONS"
    echo "------------------------------------------------------------------"
    echo
    echo "  - install the R MDI manager package"
    echo "  - populate $SERVER_URL directory $MDI_DIRECTORY"
    echo "  - clone or update MDI repositories from GitHub"
    echo "  - check out the most recent version of all definitive MDI repositories"
    echo "  $IP_MESSAGE"
    echo
    echo "Do you wish to continue? [type 'y' for 'yes']: "
    read CONFIRMATION

    # ssh into server and execute the installation
    if [ "$CONFIRMATION" = "y" ]; then
        IP_FLAG=""
        if [ "$INSTALL_PACKAGES" = "TRUE" ]; then 
            IP_FLAG=--install-packages
        fi
        FORKS_FLAG=""
        if [ "$DEVELOPER" = "TRUE" ]; then 
            FORKS_FLAG=--forks
        fi
        ssh $IDENTITY_FILE -o "StrictHostKeyChecking no" $USER@$SERVER_URL \
        $R_LOAD_COMMAND; \
        export MDI_R_VERSION=$R_VERSION; \
        export SUPPRESS_MDI_BASHRC=TRUE; \
        $MDI_DIRECTORY/mdi install $IP_FLAG $FORKS_FLAG \
        echo; \
        echo "Done"
    fi

# -----------------------------------------------------------------------
# act on a requested 'run' action
# executes script 'mdi/remote/mdi-remote-server.sh' on the server computer
# -----------------------------------------------------------------------
elif [ "$ACTION_NUMBER" = "3" ]; then

    # ssh into server, with local port forwarding
    # launch MDI web server if not already running and report it's access URL
    # await user input for how to close, including whether to leave the web server running after exit
    ssh $IDENTITY_FILE -o "StrictHostKeyChecking no" -L $SHINY_PORT:127.0.0.1:$SHINY_PORT $USER@$SERVER_URL \
    bash $MDI_DIRECTORY/remote/mdi-remote-server.sh \
    $SHINY_PORT $MDI_DIRECTORY $DATA_DIRECTORY $HOST_DIRECTORY $DEVELOPER $R_LOAD_COMMAND_MASKED $R_VERSION

# -----------------------------------------------------------------------
# ssh into the server as per normal
# -----------------------------------------------------------------------
elif [ "$ACTION_NUMBER" = "4" ]; then
    ssh $IDENTITY_FILE -o "StrictHostKeyChecking no" $USER@$SERVER_URL
else
    exit
fi

# -----------------------------------------------------------------------
# reset the prompt menu for all actions except 'run'
# -----------------------------------------------------------------------
if [ "$ACTION_NUMBER" = "3" ]; then
    exit 
fi
# -----------------------------------------------------------------------
done

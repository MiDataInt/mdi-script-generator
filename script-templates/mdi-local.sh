# -----------------------------------------------------------------------
# launch the Michigan Data Interface in local mode on Mac/Linux
#     web server  runs on a user's local desktop/laptop computer
#     web browser runs on a user's local desktop/laptop computer
# -----------------------------------------------------------------------
# this script was generated by https://wilsonte-umich.shinyapps.io/mdi-script-generator/
# GitHub repository for script generator: https://github.com/MiDataInt/mdi-script-generator
# script template author: Thomas E. Wilson, https://wilsonte-umich.github.io/
# -----------------------------------------------------------------------

# -----------------------------------------------------------------------
# set variable values
# -----------------------------------------------------------------------
MDI_DIRECTORY="__MDI_DIRECTORY__"
HOST_DIRECTORY="__HOST_DIRECTORY__"
DATA_DIRECTORY="__DATA_DIRECTORY__"
R_DIRECTORY="__R_DIRECTORY__"
INSTALL_PACKAGES="__INSTALL_PACKAGES__"
INSTALL_N_CPU=__INSTALL_N_CPU__
SHINY_PORT=__SHINY_PORT__
DEVELOPER="__DEVELOPER__"
export N_CPU=$INSTALL_N_CPU

# -----------------------------------------------------------------------
# prompt the user for the requested action
# -----------------------------------------------------------------------
while true; do 
# -----------------------------------------------------------------------
ACTION_NUMBER=""
echo
echo "Welcome to the Michigan Data Interface."
echo
echo "  MDI_DIRECTORY    $MDI_DIRECTORY"
echo "  HOST_DIRECTORY   $HOST_DIRECTORY"
echo "  DATA_DIRECTORY   $DATA_DIRECTORY"
echo "  R_DIRECTORY      $R_DIRECTORY"
echo "  INSTALL_N_CPU    $INSTALL_N_CPU"
echo "  DEVELOPER        $DEVELOPER"
echo
echo "What would you like to do?"
echo
echo "  1 - (re)install the MDI on your computer"
echo "  2 - run the MDI web interface locally"
echo "  3 - exit and do nothing"
echo
echo "Select an action by its number: "
read ACTION_NUMBER

# -----------------------------------------------------------------------
# parse and confirm the requested action
# -----------------------------------------------------------------------
if [ "$ACTION_NUMBER" = "1" ]; then
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
    echo "  - populate directory $MDI_DIRECTORY"
    echo "  - clone or update MDI repositories from GitHub"
    echo "  - check out the most recent version of all definitive MDI repositories"
    echo "  $IP_MESSAGE"
    echo
    echo "Do you wish to continue? [type 'y' for 'yes']: "
    read CONFIRMATION
    if [ "$CONFIRMATION" = "y" ]; then
        COMMAND="install"
        OPTIONS="installPackages=$INSTALL_PACKAGES, confirm=FALSE"
        MESSAGE="MDI installation complete"
    else
        exit
    fi
elif [ "$ACTION_NUMBER" = "2" ]; then
    COMMAND="run"
    OPTIONS="dataDir=$DATA_DIRECTORY, port=$SHINY_PORT, debug=$DEVELOPER, developer=$DEVELOPER"
    MESSAGE="MDI shutdown complete"
else
    exit
fi

# -----------------------------------------------------------------------
# parse the appropriate R command path
# -----------------------------------------------------------------------
if [ "$R_DIRECTORY" = "NULL" ]; then
    RSCRIPT=Rscript.exe
else
    RSCRIPT=$R_DIRECTORY/bin/Rscript.exe
fi

# -----------------------------------------------------------------------
# for an installation action, be sure the MDI manager is installed and up to date
# -----------------------------------------------------------------------
if [ "$ACTION_NUMBER" = "1" ]; then
    $RSCRIPT -e "if(!require('remotes', character.only = TRUE)) install.packages('remotes', repos = 'https://cloud.r-project.org', Ncpus=$INSTALL_N_CPU)"  
    $RSCRIPT -e "remotes::install_github('MiDataInt/mdi-manager')"  
fi

# -----------------------------------------------------------------------
# execute the requested MDI command in R
# -----------------------------------------------------------------------
$RSCRIPT -e "mdi::$COMMAND($MDI_DIRECTORY, hostDir=$HOST_DIRECTORY, $OPTIONS)"

# -----------------------------------------------------------------------
# provide feedback to user once R command exits
# -----------------------------------------------------------------------
echo
echo $MESSAGE
echo

# -----------------------------------------------------------------------
# reset the prompt menu for all actions except 'run'
# -----------------------------------------------------------------------
if [ "$ACTION_NUMBER" = "2" ]; then
    exit 
fi
# -----------------------------------------------------------------------
done

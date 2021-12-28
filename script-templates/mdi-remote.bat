ECHO OFF
SETLOCAL EnableDelayedExpansion
REM ----------------------------------------------------------------
REM launch the MDI web server and browser client in 'remote' mode
REM     web server  runs on a remote server on the login node
REM     web browser runs on a user's local desktop/laptop computer
REM     communication from browser to server is via SSH local port forwarding
REM     thus, address entered into web browser is "http://127.0.0.1:SHINY_PORT"
REM -----------------------------------------------------------------------
REM this script was generated by https://wilsonte-umich.shinyapps.io/mdi-script-generator/
REM GitHub repository for script generator: https://github.com/MiDataInt/mdi-script-generator
REM script template author: Thomas E. Wilson, https://wilsonte-umich.github.io/
REM ----------------------------------------------------------------

REM -----------------------------------------------------------------------
REM set variable values
REM -----------------------------------------------------------------------
SET MDI_DIRECTORY=__MDI_DIRECTORY__
SET HOST_DIRECTORY=__HOST_DIRECTORY__
SET DATA_DIRECTORY=__DATA_DIRECTORY__
SET R_LOAD_COMMAND=__R_LOAD_COMMAND__
SET R_LOAD_COMMAND_MASKED=__R_LOAD_COMMAND_MASKED__
SET INSTALL_PACKAGES=__INSTALL_PACKAGES__
SET ADD_TO_PATH=__ADD_TO_PATH__
SET SERVER_URL=__SERVER_URL__
SET USER=__USER__
SET IDENTITY_FILE=__IDENTITY_FILE__
SET SHINY_PORT=__SHINY_PORT__
SET DEVELOPER=__DEVELOPER__

REM -----------------------------------------------------------------------
REM prompt the user for the requested action
REM -----------------------------------------------------------------------
:USER_PROMPT
SET ACTION_NUMBER=
ECHO.
ECHO Welcome to the Michigan Data Interface.
ECHO.
ECHO   %USER%@%SERVER_URL%:%SHINY_PORT%
ECHO   MDI_DIRECTORY    %MDI_DIRECTORY%
ECHO   HOST_DIRECTORY   %HOST_DIRECTORY%
ECHO   DATA_DIRECTORY   %DATA_DIRECTORY%
ECHO   R_LOAD_COMMAND   %R_LOAD_COMMAND%
ECHO   DEVELOPER        %DEVELOPER%
ECHO.
ECHO What would you like to do?
ECHO.
ECHO   1 - run the MDI web interface (local browser, remote server via SSH)
ECHO   2 - use nano to edit one of the server configuration files
ECHO   3 - (re)install the MDI on the remote server via SSH
ECHO   4 - bring up an interactive bash terminal on the server
ECHO   5 - exit and do nothing
ECHO.
SET /p ACTION_NUMBER=Select an action by its number: 

REM -----------------------------------------------------------------------
REM act on a requested 'run' action
REM executes script 'mdi/remote/mdi-remote-server.sh' on the server computer
REM -----------------------------------------------------------------------
IF "!ACTION_NUMBER!"=="1" (

    REM ssh into server, with local port forwarding
    REM launch MDI web server if not already running and report it's access URL
    REM await user input for how to close, including whether to leave the web server running after exit
    ssh !IDENTITY_FILE! -o "StrictHostKeyChecking no" -L %SHINY_PORT%:127.0.0.1:%SHINY_PORT% %USER%@%SERVER_URL% ^
    bash %MDI_DIRECTORY%/remote/mdi-remote-server.sh ^
    %SHINY_PORT% %MDI_DIRECTORY% %DATA_DIRECTORY% %HOST_DIRECTORY% %DEVELOPER% %R_LOAD_COMMAND_MASKED%

REM -----------------------------------------------------------------------
REM request the server file to edit
REM -----------------------------------------------------------------------
) ELSE IF "!ACTION_NUMBER!"=="2" (
    ECHO.
    ECHO Please select the server file you would like to edit.
    ECHO.
    ECHO   1 - suites.yml            pipelines and apps suites to install
    ECHO   2 - stage1-pipelines.yml  system defaults for pipeline execution
    ECHO   3 - stage2-apps.yml       access control options for the apps server
    ECHO   4 - exit and do nothing
    ECHO.
    SET /p FILE_NUMBER=Select a file to edit by its number: 
    
    IF "!FILE_NUMBER!"=="1" (
        SET FILE_NAME=suites.yml
    ) ELSE IF "!FILE_NUMBER!"=="2" (
        SET FILE_NAME=stage1-pipelines.yml
    ) ELSE IF "!FILE_NUMBER!"=="3" (
        SET FILE_NAME=stage2-apps.yml
    ) ELSE (
        ENDLOCAL
        EXIT
    )
    ssh !IDENTITY_FILE! -o "StrictHostKeyChecking no" %USER%@%SERVER_URL% -t nano %MDI_DIRECTORY%/config/!FILE_NAME!

REM -----------------------------------------------------------------------
REM act on a requested 'install' action
REM -----------------------------------------------------------------------
) ELSE IF "!ACTION_NUMBER!"=="3" (

    REM prompt for installation permission
    SET IP_MESSAGE=-
    IF %INSTALL_PACKAGES%==TRUE (
        SET IP_MESSAGE=- install or update R packages
    )
    SET PATH_MESSAGE=-
    IF %ADD_TO_PATH%==TRUE (
        SET PATH_MESSAGE=- modify '~/.bashrc' to add the mdi executable to PATH
    )
    ECHO.
    ECHO ------------------------------------------------------------------
    ECHO PLEASE CONFIRM MDI INSTALLATION ACTIONS
    ECHO ------------------------------------------------------------------
    ECHO.
    ECHO   - install the R MDI manager package
    ECHO   - populate %SERVER% directory %MDI_DIRECTORY%
    ECHO   - clone or update MDI repositories from GitHub
    ECHO   - check out the most recent version of all definitive MDI repositories
    ECHO   !IP_MESSAGE!
    ECHO   !PATH_MESSAGE!
    ECHO.
    SET /p CONFIRMATION=Do you wish to continue? [type 'y' for 'yes']: 

    REM ssh into server and execute the installation
    IF "!CONFIRMATION!"=="y" (
        ssh !IDENTITY_FILE! -o "StrictHostKeyChecking no" %USER%@%SERVER_URL% ^
        %R_LOAD_COMMAND%; ^
        Rscript -e """install.packages('remotes', repos='https://cloud.r-project.org')"""; ^
        Rscript -e """remotes::install_github('MiDataInt/mdi-manager')"""; ^
        Rscript -e """mdi::install('%MDI_DIRECTORY%', hostDir = '%HOST_DIRECTORY%', installPackages = %INSTALL_PACKAGES%, confirm = FALSE, addToPATH = %ADD_TO_PATH%)"""; ^
        echo; ^
        echo "Done"
        REM 
        PAUSE
    )

REM -----------------------------------------------------------------------
REM ssh into the server as per normal
REM -----------------------------------------------------------------------
) ELSE IF "!ACTION_NUMBER!"=="4" (
    ssh !IDENTITY_FILE! -o "StrictHostKeyChecking no" %USER%@%SERVER_URL%
) ELSE (
    ENDLOCAL
    EXIT
)

REM -----------------------------------------------------------------------
REM reset the prompt menu for all actions except 'run'
REM -----------------------------------------------------------------------
IF "!ACTION_NUMBER!"=="1" (
    ENDLOCAL    
) ELSE (
    GOTO USER_PROMPT
)

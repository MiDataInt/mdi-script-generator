ECHO OFF
REM ----------------------------------------------------------------
REM launch the MDI web server and browser client in 'remote' mode
REM     web server runs on a remote server on the login node
REM     web browser runs on a user's local desktop/laptop computer
REM     communication from browser to server is via SSH local port forwarding
REM     thus, address entered into web browser is "http://127.0.0.1:SHINY_PORT"
REM ----------------------------------------------------------------

REM set variables
MDI_DIRECTORY=__MDI_DIRECTORY__
HOST_DIRECTORY=__HOST_DIRECTORY__
DATA_DIRECTORY=__DATA_DIRECTORY__
R_LOAD_COMMAND=__R_LOAD_COMMAND__
INSTALL_PACKAGES=__INSTALL_PACKAGES__
ADD_TO_PATH=__ADD_TO_PATH__
SERVER_URL=__SERVER_URL__
USER=__USER__
SHINY_PORT=__SHINY_PORT__
DEVELOPER=__DEVELOPER__

REM get action from user
ECHO.
ECHO Welcome to the Michigan Data Interface.
ECHO.
ECHO What would you like to do?
ECHO.
ECHO   1 - run the MDI web interface (local browser, remote server via SSH)
ECHO   2 - (re)install the MDI on the remote server via SSH
ECHO   3 - exit and do nothing
ECHO.
SET /p ACTION_NUMBER=Select an action by its number:

REM act on the requested action
IF "%ACTION_NUMBER%"=="1" (

    REM open a Chrome browser window at the appropriate url and port for the ssh tunnel to server
    START "Chrome" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" http://127.0.0.1:%SHINY_PORT%

REM TODO: is this handling R_LOAD_COMMAND? apparently not (would happen on the remote via mdi-remote-server.sh)

    REM ssh into server, with local port forwarding
    REM launch MDI web server if not already running and report it's access URL
    REM await user input for how to close, including whether or not to leave the web server running after exit
    ssh -L %SHINY_PORT%:127.0.0.1:%SHINY_PORT% %USER%@%SERVER_URL% ^
    bash %MDI_DIRECTORY%/remote/mdi-remote-server.sh ^
    %SHINY_PORT% %MDI_DIRECTORY% %DATA_DIRECTORY% %HOST_DIRECTORY% %DEVELOPER%

) ELSE IF "%ACTION_NUMBER%"=="2" (

    REM prompt for installation permission
    SET IP_MESSAGE=-(action suppressed)
    IF %INSTALL_PACKAGES%==TRUE (
        SET IP_MESSAGE=- install or update R packages
    )
    SET PATH_MESSAGE=-(action suppressed)
    IF %ADD_TO_PATH%==TRUE (
        SET PATH_MESSAGE=- modify '~/.bashrc' to add the mdi executable to PATH
    )
    ECHO.
    ECHO ------------------------------------------------------------------
    ECHO PLEASE CONFIRM MDI INSTALLATION ACTIONS
    ECHO ------------------------------------------------------------------
    ECHO.
    ECHO   - populate %SERVER% directory %MDI_DIRECTORY% or %MDI_DIRECTORY%/mdi (as appropriate)
    ECHO   - clone or update MDI repositories from GitHub
    ECHO   - check out the most recent version of all definitive MDI repositories
    ECHO   %IP_MESSAGE%
    ECHO   %PATH_MESSAGE%
    ECHO.
    SET /p CONFIRMATION=Do you wish to continue? (type 'y' for 'yes'):

    REM ssh into server and execute the installation
    IF "%CONFIRMATION%"=="y" (
        ssh %USER%@%SERVER_URL% ^
        %R_LOAD_COMMAND%; ^
        Rscript -e """install.packages('remotes', repos = 'https://cloud.r-project.org')"""; ^
        Rscript -e """gC <- '~/gitCredentials.R'; if(file.exists(gC)) {source(gC); do.call(Sys.setenv, gitCredentials)}; remotes::install_github('MiDataInt/mdi-manager')"""; ^
        Rscript -e """mdi::install(%MDI_DIRECTORY%, hostDir=%HOST_DIRECTORY%, installPackages = %INSTALL_PACKAGES%, confirm=FALSE, addToPATH = %ADD_TO_PATH%)"""; ^
        echo; ^
        echo "Done"
        REM 
        PAUSE
    )

) ELSE (
    EXIT
)

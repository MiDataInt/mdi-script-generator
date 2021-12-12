ECHO OFF
REM -----------------------------------------------------------------------
REM launch the MDI web server and browser client in local mode on Windows
REM -----------------------------------------------------------------------

REM set variables
SET MDI_DIRECTORY=__MDI_DIRECTORY__
SET HOST_DIRECTORY=__HOST_DIRECTORY__
SET DATA_DIRECTORY=__DATA_DIRECTORY__
SET R_DIRECTORY=__R_DIRECTORY__
SET INSTALL_PACKAGES=__INSTALL_PACKAGES__
SET SHINY_PORT=__SHINY_PORT__
SET DEVELOPER=__DEVELOPER__

REM get action from user
ECHO.
ECHO Welcome to the Michigan Data Interface.
ECHO.
ECHO What would you like to do?
ECHO.
ECHO   1 - run the MDI web interface
ECHO   2 - (re)install the MDI on your computer
ECHO   3 - exit and do nothing
ECHO.
SET /p ACTION_NUMBER=Select an action by its number:

REM parse the requested action
IF "%ACTION_NUMBER%"=="1" (
    SET COMMAND=run
    SET OPTIONS=dataDir=%DATA_DIRECTORY%, port=%SHINY_PORT%, debug=%DEVELOPER%, developer=%DEVELOPER%
    SET MESSAGE=MDI shutdown complete
) ELSE IF "%ACTION_NUMBER%"=="2" (
    SET COMMAND=install
    SET OPTIONS=installPackages=%INSTALL_PACKAGES%, confirm=FALSE, addToPATH=FALSE
    SET MESSAGE=MDI installation complete
) ELSE (
    EXIT
)

REM parse and execute the requested R command
IF "%R_DIRECTORY%"=="NULL" (
    SET RSCRIPT=Rscript.exe
) ELSE (
    SET RSCRIPT=%R_DIRECTORY%/bin/Rscript.exe
)

"%RSCRIPT%" -e "mdi::%COMMAND%(%MDI_DIRECTORY%, hostDir=%HOST_DIRECTORY%, %OPTIONS%)"

REM finish up
ECHO.
ECHO %MESSAGE%
ECHO.

PAUSE

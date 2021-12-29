### Add to PATH

If checked, the MDI installer will attempt to add the 'mdi'
command line tool to your PATH variable, which makes it easier
to run Stage 1 pipelines from within any folder.

This option defaults to FALSE because most often you will use
the launcher scripts to run Stage 2 apps servers, which do not need to modify PATH, but you may wish
to check this option if you will manually use your new installation 
from the server command line. 

This option is equivalent to the the 'addToPATH' argument
to <code>mdi::install()</code>.

### Add to PATH

If checked, the MDI manager will add the 'mdi'
command line tool to your <code>PATH</code> variable, which makes it easier
to run Stage 1 pipelines from any folder.

This option defaults to FALSE because most people use
batch scripts to run Stage 2 apps, but you may wish
to check this option if you will also use your new installation 
manually from a server command line. 

This option is equivalent to the 'addToPATH' argument
of <code>mdi::install()</code>.

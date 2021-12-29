### Install R Packages

If checked (the default), the MDI manager will install 
the R packages required by all requested Stage 2 apps. 

You may wish to uncheck this option if you
will only use Stage 1 pipelines, since R package installation 
can take a long time the first time you do it.

This option is equivalent to the 'installPackages' argument
of <code>mdi::install()</code>.

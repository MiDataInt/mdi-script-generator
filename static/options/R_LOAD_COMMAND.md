### R Load Command

MDI Stage 2 apps require that R be installed and available to run.

If provided, **R Load Command** will be called on a remote
server prior to attempting to launch the MDI. It is
expected that R Load Command will make 'Rscript' available 
via the system <code>PATH</code> environment variable.
If R Load Command is left blank, 'Rscript' must already be available via PATH.

**Examples**

- module load R/4.1.0 (e.g., on Great Lakes)
- export PATH=/path/to/R-4.1.0:$PATH

The R Load Command option also lets you create different scripts with 
different R paths to maintain multiple R versions on the same computer.

R Load Command can be left blank if you will use a system R installation
to run the apps server.

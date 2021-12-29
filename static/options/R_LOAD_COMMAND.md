### R Load Command

The MDI requires that R be installed and available to run. 

If provided, **R Load Command** will be called on a remote
server prior to attempting to launch the MDI. It is
expected that R Load Command will make 'Rscript' available 
via the system <code>PATH</code> environment variable.
If R Load Command is left blank, 'Rscript' must already be available via PATH.

**Examples**

- module load R/4.1.0 (e.g., on Great Lakes)
- export PATH=/path/to/R-4.1.0:$PATH

In addition to providing code access when Rscript is not set in PATH,
the R Source Directory option lets you create different scripts with 
different R paths, i.e., you can
maintain multiple R versions on the same computer.

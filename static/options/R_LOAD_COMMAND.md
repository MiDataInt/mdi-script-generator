### R Load Command

The MDI requires that R be installed and available to run. 

If provided, **R Load Command** is called on a remote
server prior to launching the MDI via a call to Rscript. It is
expected that R Load Command will make Rscript available via the system PATH environment variable.

If R Load Command is left blank, 'Rscript' or 'Rscript.exe' must already be available via PATH.

In addition to providing access to R when it is not already set in PATH,
the R Load Command option allows you to create different scripts that
use different R paths and thus R versions, i.e., it is possible
to maintain multiple R versions and launcher scripts on the same computer.

#### Examples

- module load R/4.1.0 (e.g., on Great Lakes)
- export PATH=/path/to/R-4.1.0:$PATH

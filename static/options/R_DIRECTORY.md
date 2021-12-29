### R Directory

The MDI requires that R be installed and available to run. 

If provided, **R Directory** must be a path to a folder where the MDI can find the file 'bin/Rscript' or 'bin/Rscript.exe'.

If R Directory is left blank, 'Rscript' or 'Rscript.exe' must already be available via the system PATH environment variable.

In addition to providing access to R when it is not set in PATH,
the R Directory option allows you to create different scripts that
use different R paths and thus R versions, i.e., it is possible
to maintain multiple R versions and launcher scripts on the same computer.

#### Example

- /path/to/R-4.1.0

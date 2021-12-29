### R Source Directory

The MDI requires that R be installed and available to run. 

If provided, **R Source Directory** must be a path to a folder 
where file 'bin/Rscript' or 'bin/Rscript.exe' can be found.
If left blank, 'Rscript' or 'Rscript.exe' must already be available 
via the system <code>PATH</code> environment variable.

**Example**

- /path/to/R-4.1.0

In addition to providing code access when Rscript is not set in PATH,
the R Source Directory option lets you create different scripts with 
different R paths, i.e., you can
maintain multiple R versions on the same computer.

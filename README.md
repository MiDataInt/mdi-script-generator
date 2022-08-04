# OBSOLETE

The mdi-script-generator is **largely obsolete as of August 2022**.
It has essentially been replaced by the MDI Desktop App pending
code signing.

- <https://github.com/MiDataInt/mdi-desktop-app>

The concepts behind the script generator and desktop app are
essentially the same - to create a convenience wrapper for users
to make calls to named MDI installations. The difference is
that the desktop app provides that wrapper access all within
a single, installable app, instead of a user having to download
and maintain potentially multiple unsignable batch scripts.

# mdi-script-generator

This repository carries the code that runs the MDI public script generator
app hosted at:

- <https://wilsonte-umich.shinyapps.io/mdi-script-generator/>

This repository is only intended for use by MDI project administrators.
The code is shared publicly for transparency about how batch scripts
are generated.

If desired, anyone could run the script generator app
locally, or on another shinyapps.io instance. Instructions for 
logging in and deploying Shiny apps to shinyapps.io can be found here:

- <https://shiny.rstudio.com/articles/shinyapps.html>

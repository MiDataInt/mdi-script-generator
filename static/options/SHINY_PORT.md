### R Shiny Port

Please provide the integer number of the port to which the
MDI web server should listen.

Most people can leave this as the R Shiny default value of <code>3838</code>,
but some users with port restrictions might need to to specify a value.

**R Shiny Port** must generally be free and accessible on both the 
local computer running the web browser as well as any remote computer
running the Shiny web server. It does _not_ need to
be exposed by a firewall, however, since
the connection from client to server is made via SSH on port 22
with tunneling used to access the remote Shiny port.

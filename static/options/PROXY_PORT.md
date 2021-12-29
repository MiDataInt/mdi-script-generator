### Local Proxy Port

Please provide the integer number of the port 
to use for dynamic port forwarding to the remote server.

Most people can leave this as the standard default value of <code>1080</code>,
but some users with competing installations or other port 
restrictions might need to to specify a different value.

**Local Proxy Port** must generally be free and accessible on both the 
local computer running the batch script as well as any remote computer. 
It does _not_ need to be exposed by a firewall, since
the connection from client to server is made via SSH on port 22
with dynamic port forwarding used to access the remote web server.

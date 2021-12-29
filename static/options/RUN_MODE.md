### MDI Run Modes

The MDI can be launched in various modes that differ 
in which computer runs the Stage 1 Pipelines, Stage 2 Apps server, 
and interactive web browser.
Critically, each run mode yields the same tools and interfaces. The proper
run mode selection thus depends on the usage considerations discussed below.

#### Local (desktop or laptop)

User running the MDI in **Local Mode** will install the R Shiny web server
on their desktop or laptop. Thus, the web browser and web
server both run on the same local computer.

Local mode is best when you wish to run interactive Stage 2 Apps 
on your computer to analyze data that was processed by pipelines on 
some other server. 

Local mode is generally very responsive and secure, but you 
usually need to manually transfer files from a server to your computer, or
someone else needs to provide processed data files to you, e.g., via email.

#### Remote Server

In **Remote Server Mode**, the R Shiny web server instead runs on a 
remote computer on its login host, often a high performance computing (HPC) server
suitable for running Stage 1 pipelines but sometimes a web server
housed in a research laboratory and dedicated to running the MDI. A web browser
running on the user's local computer connects to the web server via a secure SSH
tunnel; no one else on the internet can access the web tools.

In Remote Server Mode, a user can launch the Pipeline Runner app to configure, 
execute and monitor Stage 1 pipelines, as well as analyze output data from 
those pipelines using interactive Stage 2 apps running on the same HPC server.

Remote Server Mode is best for users with an HPC solution that can
be accessed via SSH and who are willing to trade a slightly more complex
installation for the flexibility afforded by running the MDI web server remotely.
Remote modes can also offer improved compute speeds relative to smaller desktop
or laptop computers (although high quality local computers will also perform very well).

#### Cluster Node

**Cluster Node Mode** is very similar to Remote Server Mode, above, except that now
the R Shiny web server runs on a worker node that is part of a remote server cluster 
using Slurm as its job scheduler. In this mode, the server login node proxies web
requests from the local web browser to the cluster node, again using a secure SSH connection.

Remote Server Mode is best for users wishing to exploit the advantages of a remote
server whose configuration demands that app server processes run on a dedicated node accessed via 
an authorized user account, e.g., the University of Michigan Great Lakes server cluster, given that cluster servers
often prohibit extensive computational work on login nodes.

#### AWS Public Server

In **Public Server Mode**, an administrator installs the MDI on a cloud
server running on an Amazon Web Services (AWS) instance. Such an installation
is facilitated by the following MDI repositories, which provide further documentation.

<https://github.com/MiDataInt/mdi-web-server.git>
<https://github.com/MiDataInt/mdi-aws-ami.git>

Public Server Mode is best when resource administrators wish to 
share MDI tools and data with many users with varying, often limited,
technical interest in installing the MDI themselves.

As the name suggests, public server launch pages can be loaded by anyone
with a web browser. However, public MDI servers demand login so that only authorized users can 
access the apps and other resources.

Similar to Local Mode, Public Server Mode is focused on providing
access to Stage 2 Apps, such that data packages must usually be uploaded or copied 
to the server.

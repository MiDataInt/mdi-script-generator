### MDI Run Modes

The MDI can be launched in various modes that differ 
in which computer runs the Stage 1 Pipelines, Stage 2 Apps server, 
and web browser. Critically, each mode yields the same tools and interfaces. 

---
**Local Mode** will install the web server
on a user's desktop or laptop, so that the web browser and web
server run on the same local computer.

<div class="entityBox outerBox">
    <p class='entityBoxLabel'>Local Desktop or Laptop Computer</p>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Web Browser</p>
        <p>Chrome, Firefox, etc.</p>
        <p>http://127.0.0.1:3838</p>
    </div>
    <div class="diagramArrow">&harr;</div>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Web Server</p>
        <p>launched by batch script</p>
    </div>
</div>

Local mode is best when you wish to run Stage 2 Apps 
on your computer to interact with data processed by pipelines on 
some other server. It is responsive and secure, but you must manually transfer 
processed data files to your computer, or a provider needs to share
such files with you, e.g., via email.

---
In **Remote Server Mode**, the server runs on a 
remote computer on its login host, either a high performance computing (HPC) resource
or a server dedicated to running the MDI. 
A web browser on the local computer connects to the server via a secure SSH
tunnel.

<div class="entityBox outerBox">
    <p class='entityBoxLabel'>Remote Server Configuration</p>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Desktop or Laptop</p>
        <div class="entityBox inlineBox">
            <p class='entityBoxLabel'>Web Browser</p>
            <p>Chrome, Firefox, etc.</p>
            <p>http://127.0.0.1:3838</p>
        </div>
    </div>
    <div class="inlineBox" style="text-align: center;">
        <div class="diagramArrow">&harr;</div>
        <div>SSH</div>
    </div>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Remote Server</p>
        <div class="entityBox inlineBox">
            <p class='entityBoxLabel'>Web Server</p>
            <p>runs on login node</p>
            <p>launched by batch script</p>
        </div>
    </div>
</div>

In Remote Server Mode, a user can launch the Pipeline Runner app to
execute Stage 1 pipelines and analyze their output using Stage 2 apps 
running on the same server. It is best for users with an HPC solution that can
be accessed via SSH willing to trade a slightly more complex
installation for the capabilities afforded by running the MDI remotely.
Remote modes may also offer improved compute speeds relative to smaller desktop
or laptop computers.

---
**Cluster Node Mode** is similar to Remote Server Mode except that now
the web server runs on a worker node that is part of a remote server cluster 
using Slurm as its job scheduler. The server login node proxies web
requests from the local web browser to the cluster node, again using SSH.

<div class="entityBox outerBox">
    <p class='entityBoxLabel'>Remote Node Configuration</p>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Desktop or Laptop</p>
        <div class="entityBox inlineBox">
            <p class='entityBoxLabel'>Web Browser</p>
            <p>Chrome, Firefox, etc.</p>
            <p>http://NODE:3838</p>
        </div>
    </div>
    <div class="inlineBox" style="text-align: center;">
        <div class="diagramArrow">&harr;</div>
        <div>SSH</div>
    </div>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Server Login Node</p>
        <div class="entityBox inlineBox">
            <p class='entityBoxLabel'>SSH proxy</p>
            <p>launch node job via Slurm</p>            
            <p>proxy to node via OpenSSH</p>
        </div>
    </div>
    <div class="inlineBox" style="text-align: center;">
        <div class="diagramArrow">&harr;</div>
        <div>SSH</div>
    </div>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Cluster Node</p>
        <div class="entityBox inlineBox">
            <p class='entityBoxLabel'>Web Server</p>
            <p>launched by batch script</p>
            <p>performs computations</p>
        </div>
    </div>
</div>

Cluster Node Mode is best for users wishing to exploit the advantages of a remote
server whose configuration demands that computational processes run on a dedicated node 
accessed via an authorized user account, e.g., the University of Michigan Great Lakes 
server cluster.

---
In **Public Server Mode**, an administrator installs the MDI on a cloud
server running on an Amazon Web Services (AWS) instance. 
Such an installation
is facilitated by the following MDI repositories, which provide further documentation.

<https://github.com/MiDataInt/mdi-web-server.git>  
<https://github.com/MiDataInt/mdi-aws-ami.git>

<div class="entityBox outerBox">
    <p class='entityBoxLabel'>Public Server Configuration</p>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Desktop or Laptop</p>
        <div class="entityBox inlineBox">
            <p class='entityBoxLabel'>Web Browser</p>
            <p>Chrome, Firefox, etc.</p>
            <p>https://my-mdi.io</p>
        </div>
    </div>
    <div class="inlineBox" style="text-align: center;">
        <div class="diagramArrow">&harr;</div>
        <div>internet</div>
    </div>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Public AWS Instance</p>
        <div class="entityBox inlineBox">
            <p class='entityBoxLabel'>Web Server</p>
            <p>launched by batch script</p>            
            <p>encrypted access and login</p>
        </div>
    </div>
</div>

Public Server Mode is best when resource providers wish to 
share MDI tools and data with many users who have limited
technical interest in installing the MDI themselves. Batch
scripts are for administrators; end users simply
point their web browser at your server. Indeed, anyone
with a web browser can access your public servers, which therefore
demand login authorization to protect their resources.

Similar to Local Mode, Public Server Mode mainly provides
access to Stage 2 Apps with data packages uploaded or copied 
to the server by users.

<br><br><br>
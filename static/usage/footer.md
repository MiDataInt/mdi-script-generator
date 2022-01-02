### Enter a number or type a command name

All batch scripts open a command window that presents:

- information summarizing the script targets and options
- a menu of action options

The details will depend on your
script, but in general you should first select an 
option to install the MDI, then an option to run it.
The actions taken by the script will be logged
in the command window until you close it.

### Load the MDI in your web browser

After launching the server, most often you will open 
a web browser to run the MDI apps. 
The MDI is developed using Chrome, but Safari, Firefox, and Edge should all 
give similar results.

The server log in the command window will tell you
what URL to enter into your browser. For local
and remote server modes it is usually:

<http://127.0.0.1:3838>

### Proxy to a Cluster Node using SwitchyOmega

When running the MDI on a remote cluster server node,
you need to install the SwitchyOmega proxy agent to help 
your browser route web requests to the appropriate node. 
It can be installed into Chrome here:

<https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif>

Once installed, navigate to the SwitchyOmega options settings page.
Click "New profile" and create a new profile with a helpful name
such as "MDI Proxy Port 1080" or similar. Set up a proxy server
with options:

- Protocol = SOCKS5
- Server = 127.0.0.1
- Port = 1080 (or, whatever port you chose to use)

Click "Apply changes" to save your new proxy configuration.

You will then enter a link like the following into your browser;
the exact address with the proper node name will be reported in the server log.

<http://NODE:3838>

It will fail to load on first attempt. To make it work, set the SwitchyOmega 
browser extension (find it in the upper right corner of Chrome) 
to use the proxy you created above.

### Security concerns

#### Batch script contents

All MDI code is fully open source. You can preview the contents
of a batch script when you download it, and can open the script in 
any text editor to verify that it doesn't contain 
any unexpected code. All scripts are extensively commented to guide you.

If you are still uncomfortable, all actions required to run the MDI
can be executed by direct calls such as <code>mdi::run()</code> in R - 
you do not need to use batch scripts to use the MDI, but they
make life easier.

#### Web site privacy, http vs. https

URLs to access local, remote, and node servers
begin with 'http', not 'https', as the browser itself does not enforce encryption. 
However, such servers are accessible to you alone because they are running
on your computer or being accessed via a secure SSH port tunnel. 
Thus, no one else on the internet can access your web server
and your connection is always secure and encrypted via SSH.

In contrast, public servers are freely accessible on the internet 
and must use SSL/TLS encryption, addresses starting with 'https',
and some form of login to ensure security and privacy.

<br><br><br><br>

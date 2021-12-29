### Host Directory

When used with default options, all of the code and data used by the MDI resides under the MDI Directory, e.g., /path/to/mdi.

However, sometimes developers pre-install a set of
data analysis pipelines and/or apps suites to make it easy for 
you to use their tools and data. You can access such a hosted
installation by providing a value for **Host Directory**, which
is simply the full path to a different, pre-existing MDI Directory.

When a Host Directory is provided, the Stage 1 pipelines **environments** and Stage 2 apps **library** code folders will be used from that directory instead of from the user's MDI Directory.
Additionally, users will have access to the **resources**
folder made available in the hosted directory.

Please consult with the tool provider for the proper path
for your computer server.

If you are not using a hosted MDI installation, simply leave this option blank.

#### Example
- /path/to/hosted/mdi


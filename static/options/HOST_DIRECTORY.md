### Host Directory

With default options, all the code and data used by the MDI 
resides under the Installation Directory, e.g., /path/to/mdi.

<div class="entityBox outerBox">
    <p class='entityBoxLabel'>Default Configuration</p>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Installation Directory</p>
        <p>/config</p>
        <p>/containers</p>
        <p>/data</p>
        <p>/environments</p>
        <p>/frameworks</p>
        <p>/library</p>
        <p>/resources</p>
        <p>/sessions</p>
        <p>/suites</p>
    </div>
</div>

Alternatively, developers may pre-install 
pipelines and/or apps suites to make them easy to use. 
You can access such hosted installations by providing a value for **Host Directory**, 
i.e., the full path to a different, pre-existing MDI Directory.
Stage 1 pipeline **containers**, **environments** and 
Stage 2 app **library** code folders will be used from that directory 
instead of from the Installation Directory.
Additionally, you will have access to the hosted **config** and **resources**
folders.

<div class="entityBox outerBox">
    <p class='entityBoxLabel'>Hosted Installation</p>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Installation Directory</p>
        <p>/data</p>
        <p>/frameworks</p>
        <p>/sessions</p>
        <p>/suites</p>
    </div>
    <div class="diagramArrow">&harr;</div>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Host Directory</p>
        <p>/config</p>
        <p>/containers</p>
        <p>/environments</p>
        <p>/library</p>
        <p>/resources</p>
    </div>
</div>

**Example**
- /path/to/hosted/mdi

Please consult with your provider for the proper path
to their installation on your server.

If you are not using a hosted MDI installation, simply leave this option blank.

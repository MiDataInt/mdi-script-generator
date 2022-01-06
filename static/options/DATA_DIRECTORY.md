### Data Directory

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

Alternatively, a laboratory or research group may wish
to share the data files produced by Stage 2 apps between multiple users. 
You can easily share data by providing a value for **Data Directory**, 
i.e., the full path to any valid shared directory.
When a Data Directory is provided, it replaces the Stage 2 apps **data** folder.

<div class="entityBox outerBox">
    <p class='entityBoxLabel'>Shared Data Folder</p>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Installation Directory</p>
        <p>/config</p>
        <p>/containers</p>
        <p>/environments</p>
        <p>/frameworks</p>
        <p>/library</p>
        <p>/resources</p>
        <p>/sessions</p>
        <p>/suites</p>
    </div>
    <div class="diagramArrow">&harr;</div>
    <div class="entityBox inlineBox">
        <p class='entityBoxLabel'>Data Directory</p>
        <p>session data folders populate here</p>
    </div>
</div>

**Example**
- /path/to/shared/mdi/data

Please consult with your research team leader to determine what path to enter here.

If you are not using a shared data folder, simply leave this option blank.

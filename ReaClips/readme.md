![ReaClippy2](https://user-images.githubusercontent.com/5218005/184808755-b5375b64-6c2f-4fe4-9380-b0a6d84b93aa.png)


# ReaClips

## Build and browse a personal sound/clip/loop library in REAPER

These scripts provide functionality for REAPER inspired by Ableton Live Clips and Studio One musicloops. Musical ideas and clips can be quickly saved from selected items, then browsed and organised in the Media Explorer, and loaded into an open project as exploded tracks or as subprojects. 

## Installation

1. Install ReaPack and import my repo: https://github.com/s0u7h/pcp/raw/master/index.xml
2. Also requires ReaPack repos from cfillion, JS_ReaScriptAPI (both installed by default) and [me2beats](https://github.com/me2beats/reapack/raw/master/index.xml)
3. Install [SWS](http://www.sws-extension.org/download/pre-release/)
4. Synchronize packages, Browse packages, Install ReaClips

## Usage

1. Select an item or items that you want to save, then run the action "Save ReaClip (selected items)"
2. This will prompt you to name the ReaClip (by default named and auto-saved with a time-stamp - thanks @paat!)
3. The script will create a folder called "ReaClips" under your default save path. You can change this name in the script user settings or use one of the other actions (e.g. "Save ReaClip to Beats folder").
4. There is an additional "save as" step due to limitations in REAPER's current API. When the dialog comes up, just hit OK. The option to include media should be enabled by default but maybe check this is the case on your system.
![image](https://user-images.githubusercontent.com/5218005/185297551-3954e201-e141-45db-b459-bb5cb174a514.png)

5.  The script will then render the ReaClip, taking into account any sends or receives that affect the sound, and then open the Media Explorer to show the most recent ReaClips.
6.  The "Open Media Explorer to ReaClips path" can be triggered from the Main section or from the Media Explorer, and is useful to put on a toolbar button. This is a super-handy Edgemeal snippet that uses JS_ReaScriptAPI. Edit the user settings inside to target different folders/databases. ALso if you don't want the "Save ReaClip" actions to open the media browser automatically, you can change this in the script's user settings.
7.  These are just project files so you can browse through them and either use the native actions to Open project / insert as subproject, or use the actions "Insert ReaClip at start" or "Insert ReaClip at edit cursor" to load and explode the file into your currently active project. Unlike other 'explode subproject' clips this will carry over everything including automation items. With one exception...
8.  If your clip contains Melodyne or other ARA edits then the ReaClip shoud keep your edits intact. However if you use the 'Insert ReaClip' actions it'll immediately reanalyze and lose the edits. In that case, use 'Insert as subproject' or 'Open project in new tab' instead.
9.  The "Open Media Explorer to ReaClips" action is useful to put on a toolbar button. This is a super-useful Edgemeal snippet, edit the user settings inside for different folders/databases. ALso if you don't want the "Save ReaClip" actions to open the media browser automatically, you can change this in the script's user settings.

### REQUIREMENTS

* SWS
* JS_ReaScriptAPI
* ReaPack repos: cfillion for selecting send and receive tracks of selected tracks, and me2beats for his save/restore active project tabs.
* Reaper 6.58+ - may work weirdly or not at all on older versions, as uses recent API.


### What are ReaClips?

They're just project files, with automatically generated audio previews, that the 'Save ReaClip' action automatically saves in a specific folder under your default save path. Once saved, you don't require these scripts to access or edit them. They can be browsed in the media explorer and opened as projects, inserted as subprojects, or exploded onto tracks using one of the 'Load ReaClip' scripts.

### Why not track templates?

Track templates still don't offer as much functionality as projects for this type of workflow. With ReaClips, you can do everything you can do with a project, such as preview in the Media Explorer at different tempos and pitches, and have more useful ways to insert into an active project. And unlike track templates, ReaClips store the project-wide like tempo/time signature changes, and ARA data. If you use ARA plugins like Melodyne, you're probably familiar with the necessity to render stems/takes after making edits, in case the plugin reanalyses the source media. ReaClips for the most part work well with Melodyne, so this script can be used to 'archive' Melodyned clips. 

### BONUS HORRIFYING TOOLBAR ICONS

if you add the Load/Save/Browse Reaclip actions to your Main or Media Explorer toolbar, you can use these horrifying icons, which should be installed by ReaPack.

![ReaClips](https://user-images.githubusercontent.com/5218005/179659715-15ef399c-73a9-49c0-a5a3-bfbf1b1b0229.png)

![Save ReaClip](https://user-images.githubusercontent.com/5218005/179659718-79197ad4-7f59-4320-8a4d-d8353e91ead2.png)

![Load ReaClip](https://user-images.githubusercontent.com/5218005/179659714-cba24e72-1821-45d2-9936-3e113da4ad6e.png)

![Load ReaClip at Edit Cursor](https://user-images.githubusercontent.com/5218005/179659712-593dca72-80ff-4a03-8db1-0199e984bccd.png)


Thanks to @paat for the auto-name-and-save script snippet and for suggesting this type of project-based workflow, Edgemeal for the media explorer script and BirdBird and Lemerchand for Discord advice on exploding projects. Plus all the other awesome scripters whose code makes up the bulk of this script's functionality.

### TODO
Clean-up for ReaPack, find a workaround to the additional 'save as' dialog.

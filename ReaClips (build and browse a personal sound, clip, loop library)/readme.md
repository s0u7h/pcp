![ReaClippy2](https://user-images.githubusercontent.com/5218005/184808755-b5375b64-6c2f-4fe4-9380-b0a6d84b93aa.png)


# ReaClips

## Build and browse a personal sound/clip/loop library in REAPER

These scripts provide functionality for REAPER inspired by Ableton Live Clips and Studio One musicloops. Musical ideas and clips can be quickly saved, then browsed and organised in the Media Explorer, and loaded into an open project as exploded tracks or as subprojects. 


### REQUIREMENTS

* SWS
* JS_ReaScriptAPI
* ReaPack repos: cfillion  for selecting send and receive tracks of selected tracks, and me2beats for his save/restore active project tabs.
* Reaper 6.58+ - may work weirdly or not at all on older versions, as uses recent API.


### What are ReaClips?

They're just project files, with automatically generated audio previews, that the 'Save ReaClip' action automatically saves in a specific folder under your default save path. Once saved, you don't require these scripts to access or edit them. They can be browsed in the media explorer and opened as projects, inserted as subprojects, or exploded onto tracks using one of the 'Load ReaClip' scripts.

### Why not track templates?

Track templates still don't offer all the functionality for this type of workflow. With ReaClips, you can do everything you can do with a project. Preview in the Media Explorer, at different tempos and pitches. More useful ways to insert into an active project. And unlike track templates, ReaClips store the project-wide like tempo/time signature changes, and ARA data. If you use ARA plugins like Melodyne, you're probably familiar with the necessity to render stems/takes after making edits,, in case plugin reanalyses the source media. ReaClips for the most part work well with Melodyne, so this script can be used to 'archive' melodyned clips. 

### BONUS HORRIFYING TOOLBAR ICONS

if you add the Load/Save/Browse Reaclip actions to your Main or Media Explorer toolbar, you can use these horrifying icons, which should be installed by ReaPack.

![ReaClips](https://user-images.githubusercontent.com/5218005/179659715-15ef399c-73a9-49c0-a5a3-bfbf1b1b0229.png)

![Save ReaClip](https://user-images.githubusercontent.com/5218005/179659718-79197ad4-7f59-4320-8a4d-d8353e91ead2.png)

![Load ReaClip](https://user-images.githubusercontent.com/5218005/179659714-cba24e72-1821-45d2-9936-3e113da4ad6e.png)

![Load ReaClip at Edit Cursor](https://user-images.githubusercontent.com/5218005/179659712-593dca72-80ff-4a03-8db1-0199e984bccd.png)


Thanks to @paat for the auto-save script snippet and for suggesting this type of project-based workflow, Edgemeal for the media explorer script and BirdBird and Lemerchand for Discord advice. Plus all the other awesome scripters whose code makes up the bulk of this script's functionality.

### TODO
Documentation, clean-up for ReaPack, find a workaround to the additional 'save as' dialog.

# LET IT KEY

## Global scale and key tool for REAPER

![monkey_plays_piano_3](https://user-images.githubusercontent.com/5218005/184811078-c238d209-8ba3-46e1-90e2-57d6a27b8f20.gif)


Play in key across all your tracks. This bundle lets you monitor and control the key of your project from the master track. Set the key in Master Track Controls ("Show FX parameters in panel" will make these visible).
Ride or automate the root and scale and play in key throughout a project, playing the scale degrees on white keys (or use chromatic option for pads).

This forks scripts from [IX](https://forum.cockos.com/showthread.php?t=6632) (Snap to Key and Global Sliders) and the [Easy Scale](https://forum.cockos.com/showthread.php?t=253198) mod by baldo, and relies on their great work. 

What this adds is the ability to control any track's input key from a global control in the master track, which controls individual instances of Let It Key elsewhere in your project.


## Usage

![Let-It-Key-smaller](https://user-images.githubusercontent.com/5218005/184857600-98704322-8f4d-4581-86de-43b835c1866c.gif)


The easiest way to use it is with the accompanying scripts.

- pcp_Add Let It Key to all tracks with instruments.lua
- pcp_Add Let It Key to all tracks.lua
- pcp_Add Let It Key to selected tracks.lua
- pcp_Remove Let It Key from all non-instrument tracks.lua
- pcp_Remove Let It Key from all tracks.lua
- pcp_Remove Let It Key from selected tracks.lua

The scripts will only add Let It Key to tracks that don't already have it, so no need to worry about adding duplicates. And the Add scripts will check to see if there's a Let It Key on the Master and will create one there if not.

The bank control gives you four separate syncs, so e.g. if you want different controllers to play in different octaves, or if you have a MIDI pad controller that you want to remain in chromatic scale mode and a keyboard that you want to use white keys, you can set the keyboard's input FX 'Let It Key Syncer' instance to Bank 0 and the pad track one to Bank 1, and on the Let It Key Master FX set Bank 0 to White Keys and Bank 1 to Chromatic. Each track will sync only with other instances in their bank.

To access more parameters in the Master track, right-click on the effect and "Show FX Parameters in Panel". The default chain shows Root, Scale and On/Off. Optionally you can show Octave Transpose, Input Channel, Bank, Remap Mode (White Keys/Pads) and Start Note. Or just open the FX to change these.

## How to install

### The Easy Way 
1. Import my repo in Reapack: https://github.com/s0u7h/pcp/raw/master/index.xml
2. Synchronize packages, Browse packages, Install **Let It Key (global scale tool)**


### The Hard Way
1. Copy the three JSFX/JSFX-inc files to REAPER/Effects/
2. Copy the two FX Chains and six lua scripts to <REAPER HOME DIR>\Scripts\pcp\Let It Key (global scale tool)
3. Note they have to go to this exact location as the paths are hardcoded. The FX Chains do not go in the FX Chains folder.
4. In the FX browser, load the six scripts.
5. Run one of the Add Let It Key... scripts and Let It Key will be added to your master track and to the input FX  of your selected tracks.


## NOTES
The "Add Let It Key to all tracks" (and Remove counterpart) should bee the default, as the resource usage is so minimal and if you throw this on the input fx of an audio track it won't even process anything until you're arming that track, and even then the CPU usage is vanishingly small. I've put the 'add  to selected tracks' and 'apply to tracks with instruments' more for completeness/OCD reasons.

You can change the IX_Scales file at REAPER\Data\ix_scales - other files are available in the REAPER Stash.
Or use **Lokasenna_Convert current scale to ix_scale **(in Reapack) to add the current key-snap scale in the midi editor to the scale bank used here.

I changed the behaviour of the Easy Scale mod as it has a bug with 5 and 6 note scales. I like baldo's 'white keys' mode  as I find thinking in scale degrees more useful and musically relevant. This uses some of that code, but changed to allow playing scales like pentatonic and hexatonic with the root scale degree always on the C key, this means that e.g. for a five-note scale, the A and B white keys will be blocked along with the black keys.

Don't add the Input FX JSFX directly yourself, it needs to be added as part of the FX chain, which includes prerolled parameter modulation with the syncer JSFX, otherwise it'll not update in real time (I mean, it will actually work like this but you'll have to start transport after every change).

One interesting thing I discovered working around this is that you **can** actually have parameter modulation in the Input FX slots (at least for MIDI, and between Input FX... haven't tried audio). You just need to create an FX Chain in the regular Track FX slots and load that chain into I-FX.

Unfortunately there's no way to save Input FX as the default for new tracks or change the "double click in empty TCP context to add new track" behaviour to launch a different track template, so the best way to add this automatically to a new track is to create track templates, and assign them shortcuts (SWS Resources makes it easy to add particular track templates with a shortcut)



## TODO
Include the original Snap to Key modes (Remap/Block) as additional options
Maybe a chorder
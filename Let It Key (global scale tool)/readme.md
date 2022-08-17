# LET IT KEY

## Global scale and key tool for REAPER

![monkey_plays_piano_3](https://user-images.githubusercontent.com/5218005/184811078-c238d209-8ba3-46e1-90e2-57d6a27b8f20.gif)


Play in key across all your tracks. This bundle lets you monitor and control the key of your project from the master track. Set the key in Master Track Controls. 
Ride or automate the root and scale and play in key throughout a project, playing the scale degrees on white keys (or use chromatic option for pads).

This forks scripts from [IX](https://forum.cockos.com/showthread.php?t=6632) (Snap to Key and Global Sliders) with the [Easy Scale](https://stash.reaper.fm/v/41954/easy%20scale.jpg) mod by dissofiddle, and totally depends on their great work.

What this adds is the ability to control your track's input key from a global control in the master track, which controls individual instances of Let It Key elsewhere in your project.


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

The bank control gives you four separate syncs, so e.g. if you have a MIDI pad controller that you want to remain in chromatic scale mode and a keyboard that you want to use white keys, you can set the keyboard's input FX Let It Key instance to Bank 0 and the pad track to Bank 1, and run two separate instances each of which sync only with other instances in their bank.

You can manually add the FX Chains as an alternative to running the scripts. There's one for Master, and one for tracks that can go on Input FX or as a regular Track FX.

To access more parameters in the Master track, right-click on the effect and "Show FX Parameters in Panel". The defaultt chain shows Root, Scale and On/Off. Optionally you can show Octave Transpose, Input Channel, Bank, Remap Mode (White Keys/Pads) and Start Note. Or just open the FX to change these.

## How to install

### The Easy Way (once I've got ReaPack working...)

1. Import this repo to Reapack and install the Let It Key bundle. (Not yet ReaPack compatible)
2. Run the action "pcp_Add Let It Key to all tracks"

### The Hard Way

1. Copy the three JSFX files to REAPER/Effects/
2. Copy the two FX Chains "Let_It_Key_(Input_FX).RfxChain" and "Let_It_Key_(Master)" to REAPER/FXChains/
3. Copy the six lua scripts to REAPER/Scripts/
4. In the FX browser, load the six scripts.
5. Run one of the Add Let It Key... scripts and Let It Key will be added to your master track and to the input FX  of your selected tracks.


## NOTES

You can add scales to the IX_Scales file directly at (DATA/CHECK)
Or use Lokasenna_Convert current scale to ix_scale (in Reapack) to add the current key-snap scale in the midi editor to the scale bank used here.

Don't add the Input FX JSFX directly yourself, it needs to be added as part of the FX chain, which includes prerolled parameter modulation with the syncer JSFX, otherwise it'll not update in real time (I mean, it will actually work like this but you'll have to start transport after every change).

Unfortunately there's no way to save Input FX as the default for new tracks or change the "double click in empty TCP context to add new track" behaviour to launch a different track template, so the best way to add this automatically to a new track is to create track templates, and assign them shortcuts (SWS Resources makes it easy to add particular track templates with a shortcut)

## TODO
Include the original Snap to Key modes (Remap/Block) as additional options

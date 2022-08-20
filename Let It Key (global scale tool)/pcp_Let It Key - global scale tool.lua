--[[
@description Let It Key (global scale tool)
@author pcp
@about 
  Play in key across all your tracks. This bundle lets you monitor and control the key of your project from the master track. Set the key in Master Track Controls ("Show FX parameters in panel" will make these visible). Ride or automate the root and scale and play in key throughout a project, playing the scale degrees on white keys (or use chromatic option for pads).
  This forks scripts from IX (Snap to Key and Global Sliders) and the Easy Scale mod by baldo, and relies on their work.
  Let It Key provides the ability to control any track's input key from a global control in the master track, which controls individual instances of Let It Key elsewhere in your project.
  [License: GPL](http://www.gnu.org/licenses/gpl.html)
@links Repository https://github.com/s0u7h/pcp/
@version 1.60
@metapackage
@provides [nomain] .
  [main] pcp_Remove Let It Key from all non-instrument tracks.lua
  [main] pcp_Remove Let It Key from all tracks.lua
  [main] pcp_Remove Let It Key from selected tracks.lua
  [main] pcp_Add Let It Key to all tracks with instruments.lua
  [main] pcp_Add Let It Key to all tracks.lua
  [main] pcp_Add Let It Key to selected tracks.lua
  Let-It-Key-Master.RfxChain
  Let-It-Key-IFX.RfxChain 
  [jsfx] Let_It_Key_(Input_FX).jsfx-inc
  [jsfx] Let_It_Key_Syncer.jsfx-inc
  [jsfx] Let_It_Key_(Master).jsfx
--]]
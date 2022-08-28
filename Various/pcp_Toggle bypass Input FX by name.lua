
--[[
@description pcp_Toggle bypass Input FX by name
@author pcp
@about 
  adds the named FX in Input FX if it doesn't exist, otherwise toggles bypass
  modded version of cfillion's actions as there's no bypass input fx by name action in his bundle
@links Repository https://github.com/s0u7h/pcp/
@version 1.60
--]]


-------------------------------
-------- USER SETTING ---------

local fxname = "NAME OF FX AS DISPLAYED IN FX BROWSER"
  
-------------------------------

reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()

for i = 0, reaper.CountSelectedTracks(0)-1 do
  local trk = reaper.GetSelectedTrack(0,i)
  local FX_here = -1 
  FX_here = reaper.TrackFX_AddByName(trk, fxname, true, 0) --get fx index in IFX
  
    if  FX_here > -1  -- check if step sequencer is in input fx 
     then 
         reaper.TrackFX_SetEnabled(trk, 0x1000000 + FX_here,
         not reaper.TrackFX_GetEnabled(trk, 0x1000000 + FX_here))
  end
end

            
reaper.Undo_EndBlock("Toggle bypass Input FX by name", -1)
reaper.PreventUIRefresh(-1)





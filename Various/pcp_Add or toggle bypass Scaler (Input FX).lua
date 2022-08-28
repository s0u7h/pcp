
--[[
@description pcp_Add or toggle bypass Scaler (Input FX)
@author pcp
@about 
  adds Scaler 2 in Input FX if it doesn't exist, otherwise toggles bypass
  modded version of cfillion's actions as there's no bypass input fx by name action in his bundle
@links Repository https://github.com/s0u7h/pcp/
@version 1.02
--]]


-------------------------------
-------- USER SETTING ---------

local fxname = "Scaler 2 (Plugin Boutique)"
  
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
         
     else 
        FX_here = reaper.TrackFX_AddByName(trk, fxname, true, 1)
    
  end
    if reaper.TrackFX_GetEnabled(trk, 0x1000000 + FX_here) == true then
        reaper.TrackFX_Show(trk, 0x1000000 + FX_here, 3)
       else  reaper.TrackFX_Show(trk, 0x1000000 + FX_here, 2)
    end
end

            
reaper.Undo_EndBlock("Add or toggle bypass and float Scaler by name on Input FX", -1)
reaper.PreventUIRefresh(-1)





-- @noindex


reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()


reaper.Main_OnCommand(40296, 0) -- Select all tracks

for i = 0, reaper.CountSelectedTracks(0)-1 do
  local trk = reaper.GetSelectedTrack(0,i)
  
  local inst = reaper.TrackFX_GetInstrument(trk)
    if inst == -1 then
    
    
  local syncer_here = -1 
  syncer_here = reaper.TrackFX_AddByName(trk, "JS:Let It Key Syncer", true, 0)
   
  
    if  syncer_here > -1  -- check if jsfx let it key is in input fx 
     then 
      reaper.TrackFX_Delete(trk, 0x1000000 + syncer_here + 1)
      reaper.TrackFX_Delete(trk, 0x1000000 + syncer_here)
    end
end


            
reaper.Undo_EndBlock("Remove Let It Key from all non-instrument tracks", -1)
reaper.PreventUIRefresh(-1)


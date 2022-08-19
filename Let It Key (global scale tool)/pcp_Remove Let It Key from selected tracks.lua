-- @noindex

reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()

for i = 0, reaper.CountSelectedTracks(0)-1 do
  local trk = reaper.GetSelectedTrack(0,i)
  local syncer_here = -1 
  syncer_here = reaper.TrackFX_AddByName(trk, "JS:pcp/Let_It_Key_Syncer.jsfx-inc", true, 0)
   
  
    if  syncer_here > -1  -- check if jsfx let it key is in input fx 
     then 
      reaper.TrackFX_Delete(trk, 0x1000000 + syncer_here + 1)
      reaper.TrackFX_Delete(trk, 0x1000000 + syncer_here)
    end
end


            
reaper.Undo_EndBlock("Remove Let It Key from selected tracks", -1)
reaper.PreventUIRefresh(-1)


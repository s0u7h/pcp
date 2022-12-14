-- @noindex

reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()

for i = 0, reaper.CountSelectedTracks(0)-1 do
  local trk = reaper.GetSelectedTrack(0,i)
  local there_already = -1 
  there_already = reaper.TrackFX_AddByName(trk, "JS:pcp/Let_It_Key_Syncer.jsfx-inc", true, 0)
   
   -- reaper.ShowMessageBox(there_already, "there?", 0)
    if  there_already == -1  -- check if jsfx let it key is in input fx 
     then 
      reaper.TrackFX_AddByName(trk, "../Scripts/pcp/Let It Key (global scale tool)/Let-It-Key-IFX.RfxChain", true, -1000)
      
      local IFXCount = reaper.TrackFX_GetRecCount(trk)
                     for j = 1,IFXCount do
                         local OpenFx = reaper.TrackFX_GetOpen(trk,0x1000000+j-1)
                         if OpenFx then
                          
                             reaper.TrackFX_Show(trk,0x1000000+j-1,2)
                             reaper.TrackFX_Show(trk,0x1000000+j-1,0)
                         end
                     end
                    
    end
end


local mstr = reaper.GetMasterTrack(0)
local on_mstr_already = -1
on_mstr_already = reaper.TrackFX_AddByName(mstr, "JS:Let It Key", false, 0) -- returns -1 if JS not found on mastre
--reaper.ShowMessageBox(on_mstr_already, "master?", 0)
if on_mstr_already == -1 -- check if Let It Key master is on the chain
 then
 -- need to hardcode location of rfxchain to distribute it on reapack. keep fx chain in this location
  reaper.TrackFX_AddByName(mstr, "../Scripts/pcp/Let It Key (global scale tool)/Let-It-Key-Master.RfxChain", false, 1) 
end


            
reaper.Undo_EndBlock("Add Let It Key to selected tracks", -1)
reaper.PreventUIRefresh(-1)



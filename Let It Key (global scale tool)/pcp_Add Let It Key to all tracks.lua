-- @noindex


reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()

--alt for add to all tracks with a virtual instrument
--use reaper.TrackFX_GetInstrument(MediaTrack track)
--Get the index of the first track FX insert that is a virtual instrument, or -1 if none

reaper.Main_OnCommand(40296, 0) -- Select all tracks

for i = 0, reaper.CountSelectedTracks(0)-1 do
  local trk = reaper.GetSelectedTrack(0,i)
  local there_already = -1 
  there_already = reaper.TrackFX_AddByName(trk, "JS:Let It Key Syncer", true, 0)
   
   -- reaper.ShowMessageBox(there_already, "there?", 0)
    if  there_already == -1  -- check if jsfx let it key is in input fx 
     then 
      reaper.TrackFX_AddByName(trk, "../Scripts/pcp_scripts/Let It Key (global scale tool)/Let-It-Key-IFX.RfxChain", true, -1000)
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
on_mstr_already = reaper.TrackFX_AddByName(mstr, "JS:Let It Key (MASTER)", false, 0)
--reaper.ShowMessageBox(on_mstr_already, "master?", 0)
if on_mstr_already == -1 -- check if Let It Key master is on the chain
 then
  reaper.TrackFX_AddByName(mstr, "../Scripts/pcp_scripts/Let It Key (global scale tool)/Let-It-Key-Master.RfxChain", false, -1000)
end

            
reaper.Undo_EndBlock("Add Let It Key to all tracks", -1)
reaper.PreventUIRefresh(-1)



-- @noindex


reaper.Undo_BeginBlock()


reaper.Main_OnCommand(40296, 0) -- Select all tracks

for i = 0, reaper.CountSelectedTracks(0)-1 do
  local trk = reaper.GetSelectedTrack(0,i)
  
  local inst = reaper.TrackFX_GetInstrument(trk)
  if inst > -1 then
  
  
  
  local there_already = -1 
  there_already = reaper.TrackFX_AddByName(trk, "JS:Let It Key Syncer", true, 0)
   
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
end

local mstr = reaper.GetMasterTrack(0)
local on_mstr_already = -1
on_mstr_already = reaper.TrackFX_AddByName(mstr, "JS:Let It Key (MASTER)", false, 0)
--reaper.ShowMessageBox(on_mstr_already, "master?", 0)
if on_mstr_already == -1 -- check if Let It Key master is on the chain
 then
  reaper.TrackFX_AddByName(mstr, "../Scripts/pcp/Let It Key (global scale tool)/Let-It-Key-Master.RfxChain", true, -1000)
end

            
reaper.Undo_EndBlock("Add Let It Key to all tracks with instruments", -1)
reaper.PreventUIRefresh(-1)



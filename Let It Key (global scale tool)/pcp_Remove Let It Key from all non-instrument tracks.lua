-- @noindex


reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()

-- UNSELECT ALL TRACKS
function UnselectAllTracks()
	first_track = reaper.GetTrack(0, 0)
	reaper.SetOnlyTrackSelected(first_track)
	reaper.SetTrackSelected(first_track, false)
end

-- SAVE INITIAL TRACKS SELECTION
init_sel_tracks = {}
local function SaveSelectedTracks(table)
  for m = 0, reaper.CountSelectedTracks(0)-1 do
    table[m+1] = reaper.GetSelectedTrack(0, m)
  end
end

-- RESTORE INITIAL TRACKS SELECTION
function RestoreSelectedTracks(table)
  UnselectAllTracks()
  for _, track in ipairs(table) do
    reaper.SetTrackSelected(track, true)
  end
end


SaveSelectedTracks(init_sel_tracks)

reaper.Main_OnCommand(40296, 0) -- Select all tracks

for i = 0, reaper.CountSelectedTracks(0)-1 do
  local trk = reaper.GetSelectedTrack(0,i)
  
  local inst = reaper.TrackFX_GetInstrument(trk)
    if inst == -1 then
    
    
  local syncer_here = -1 
  syncer_here = reaper.TrackFX_AddByName(trk, "JS:pcp/Let_It_Key_Syncer.jsfx-inc", true, 0)
   
  
    if  syncer_here > -1  -- check if jsfx let it key is in input fx 
     then 
      reaper.TrackFX_Delete(trk, 0x1000000 + syncer_here + 1)
      reaper.TrackFX_Delete(trk, 0x1000000 + syncer_here)
    end
end

RestoreSelectedTracks(init_sel_tracks)
            
reaper.Undo_EndBlock("Remove Let It Key from all non-instrument tracks", -1)
reaper.PreventUIRefresh(-1)


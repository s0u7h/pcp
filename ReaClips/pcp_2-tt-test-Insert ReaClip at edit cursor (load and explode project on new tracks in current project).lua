-- @noindex

----USER SETTINGS----

temp_folder = "Temp"
-- You can change the name of the temp folder here.
-- This is just a place for the script to dump unsaved imported project files.
-- The temp folder can be safely deleted as it only contains minimal projects for the temporary imported projects
-- The temp folder allows the script to run without prompts

---------------------


reaper.Main_OnCommand(40289, 0) -- unselect all items
me = reaper.JS_Window_Find("Media Explorer", true)

function bla() end
function nothing() reaper.defer(bla) end

function error_exit(message)
  reaper.ShowMessageBox(message, "Error", 0)
  os.exit()
end


function SaveTempProject()
-- this adds a Temp folder to the default save path for the imported subprojects (which can then be trashed.)
-- no audio is copied so the folder should be pretty tiny anyway.
-- this snippet is adapted from @paat's auto-save script 
  retval, savepath = reaper.get_config_var_string("defsavepath")
  if savepath == "" then
    error_exit("Cannot save file - no default save path")
  end
  filename = os.date("%Y-%m-%d-%H_%M_%S")
  new_dir = savepath .. "/" .. temp_folder .. "/" .. filename 
  new_path = new_dir .. "/" .. filename .. ".RPP"
  if reaper.file_exists(new_path) then
   error_exit("File already exists: \n" .. new_path)
  end
  if reaper.RecursiveCreateDirectory(new_dir, 0) == 0 then
    error_exit("Unable to create dir: \n" .. new_dir)
  end
  reaper.Main_SaveProjectEx(proj, new_path, 0) 
  reaper.Main_openProject("noprompt:" .. new_path)
end

function InsertMediaItemAndExplodeInNewTab()
  local curpos = reaper.GetCursorPosition()-- get the edit cursor position 
  reaper.JS_WindowMessage_Send(me, "WM_COMMAND", 41001, 0, 0, 0) -- Media: Insert on a new track
 reaper.Main_OnCommand(40433, 0)  --Item properties: Set item timebase to time
 reaper.Undo_EndBlock("Insert ReaClip at Edit Cursor(a)", -1) 
  
  
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_RS1ad9b3e745ad836bebeee40ba9e7a5279a356ea8'), 0) -- Script: me2beats_Save active project tab, slot 1.lua
  reaper.Main_OnCommand(41816, 0) -- Item: Open associated project in new tab
  
  
   
  reaper.SetCurrentBPM( 0, bpm, 1 )
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_AWTBASETIME'), 0) -- SWS/AW: Set project timebase to time
  --reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_AWITEMTBASETIME'), 0)  --SWS/AW: Set selected items timebase to time
  reaper.Main_OnCommand(40433, 0)  --Item properties: Set item timebase to time
 reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_MIDI_PROJ_TEMPO_ENB'), 0)  --SWS/BR: Enable "Ignore project tempo" for selected MIDI items (use tempo at item's start)



  reaper.Main_OnCommand(40296, 0) -- Track: Select all tracks

 
  SaveTempProject()
  
  
  --reaper.Main_OnCommand(40860, 0) --Close current project tab
  
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_RSc4b08953457ee0ea58cc55d5ccce70175d05f0c5'), 0) -- Script: me2beats_Restore saved project tab, slot 1.lua
  
  
  
  reaper.Undo_BeginBlock()
  reaper.Main_OnCommand(40005, 0) --Track: Remove tracks
  reaper.Main_OnCommand(40286, 0) -- Track: Go to previous track
  reaper.Main_OnCommand(42398, 0) -- Item: Paste items/tracks
 -- reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_AWITEMTBASEPROJ'), 0)  --SWS/AW: Set selected items timebase to project/track default
  reaper.Main_OnCommand(40380, 0)  --Item properties: Set item timebase to proj/track default
  reaper.SetEditCurPos(curpos, 0, 0)
end



reaper.PreventUIRefresh(1) -- Prevent UI refreshing. Uncomment it only if the script works.
reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
InsertMediaItemAndExplodeInNewTab()

reaper.Undo_EndBlock("Insert ReaClip at Edit Cursor", -1) -- End of the undo block. Leave it at the bottom of your main function.

reaper.PreventUIRefresh(-1) -- Restore UI Refresh. Uncomment it only if the script works.

reaper.UpdateArrange() -- Update the arrangement (often needed)

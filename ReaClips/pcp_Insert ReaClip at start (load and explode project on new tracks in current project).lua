-- @noindex
    
----USER SETTINGS----

temp_folder = "Temp"
-- You can change the name of the temp folder here.
-- This is just a place for the script to dump unsaved imported project files.
-- The temp folder can be safely deleted as it only contains minimal projects for the temporary imported projects
-- The temp folder allows the script to run without prompts

---------------------


function error_exit(message)
  reaper.ShowMessageBox(message, "Error", 0)
  os.exit()
end

function SaveTempProject()
-- this adds a Temp folder to the default save path for the imported subprojects (which can then be trashed.)
-- no audio is copied so the folder should be pretty tiny anyway.
-- this just allows for saving silently
-- the data-and-time auto-save snippet is adapted from @paat's auto-save script 
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
  
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_RS1ad9b3e745ad836bebeee40ba9e7a5279a356ea8'), 0) -- Script: me2beats_Save active project tab, slot 1.lua
  reaper.Main_OnCommand(40289, 0) -- unselect all items
  me = reaper.JS_Window_Find("Media Explorer", true)

  reaper.JS_WindowMessage_Send(me, "WM_COMMAND", 41001, 0, 0, 0) -- Media: Insert into project on new track
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVESEL'), 0) --SWS: Save current track selection
  reaper.Undo_EndBlock("Insert ReaClip(a)", -1) 
  reaper.Main_OnCommand(41816, 0) -- Item: Open associated project in new tab
  reaper.Main_OnCommand(40296, 0) -- Track: Select all tracks
  reaper.Main_OnCommand(40210, 0) --Track: Copy tracks
  SaveTempProject()
  reaper.Main_OnCommand(40860, 0) --Close current project tab
  reaper.Undo_BeginBlock()
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_RSc4b08953457ee0ea58cc55d5ccce70175d05f0c5'), 0) -- Script: me2beats_Restore saved project tab, slot 1.lua
  reaper.Main_OnCommand(40005, 0) --Track: Remove tracks
  reaper.Main_OnCommand(40286, 0) -- Track: Go to previous track
  reaper.Main_OnCommand(42398, 0) -- Item: Paste items/tracks
end

-- function RemoveImportedItem()
--   reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTORESEL'), 0) --SWS: Restore saved track selection
--   reaper.Main_OnCommand(40005, 0) --Track: Remove tracks
-- end

reaper.PreventUIRefresh(1) -- Prevent UI refreshing. Uncomment it only if the script works.
reaper.Undo_BeginBlock()

InsertMediaItemAndExplodeInNewTab()
-- RemoveImportedItem()

reaper.Undo_EndBlock("Insert Reaclip at start (load and explode project on new tracks in current project", -1)
reaper.PreventUIRefresh(-1) -- Restore UI Refresh. Uncomment it only if the script works.

reaper.UpdateArrange() -- Update the arrangement (often needed)



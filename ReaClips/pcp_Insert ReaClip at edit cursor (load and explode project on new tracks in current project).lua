-- @noindex

----USER SETTINGS----

temp_folder = "Temp"
-- You can change the name of the temp folder here.
-- This is just a place for the script to dump unsaved imported project files.
-- The temp folder can be safely deleted as it only contains minimal projects for the temporary imported projects
-- The temp folder allows the script to run without prompts

---------------------

reaper.Main_OnCommand(reaper.NamedCommandLookup('_RS1ad9b3e745ad836bebeee40ba9e7a5279a356ea8'), 0) -- Script: me2beats_Save active project tab, slot 1.lua
reaper.Main_OnCommand(40289, 0) -- unselect all items
me = reaper.JS_Window_Find("Media Explorer", true)

function bla() end
function nothing() reaper.defer(bla) end

function error_exit(message)
  reaper.ShowMessageBox(message, "Error", 0)
  os.exit()
end


-- function find_melodyne_number_in_item(take, number_melodyne) --yannick snippet


--   for i=0, reaper.TakeFX_GetCount(take) - 1 do
--     local retval, buf = reaper.TakeFX_GetNamedConfigParm( take, i, 'fx_ident' )
--     if buf:find("{5653544D6C70676D656C6F64796E6520") then
--       number_melodyne = i
--     end
--   end
--   if number_melodyne == nil then
--     number_melodyne = 'no number'
--   end
--   return number_melodyne
-- end

-- function CheckMelodyne() -- using yannick snippet. if there are any Melodyne items in the ReaClip then flash a message box warning the user

--   reaper.Main_OnCommand(40182, 0) -- select all items
--   local count_sel_items = reaper.CountSelectedMediaItems(0)
--   if reaper.CountSelectedMediaItems(0) == 0 then
--     nothing() return
--   end

 
--   for i=0, count_sel_items-1 do
  

--     local number_melodyne = 'no number'
--     local item = reaper.GetSelectedMediaItem(0,i)
--     local take = reaper.GetActiveTake(item)
--     local number_melodyne = find_melodyne_number_in_item(take, number_melodyne)
--     -- if number_melodyne == 'no number' then
--     --   reaper.TakeFX_AddByName( take, user_name_melodyne, -1000)
      
--     --   number_melodyne = find_melodyne_number_in_item(take, number_melodyne)
--     -- end
--     if number_melodyne == 'no number' then
--       nothing()
--     else
--       local ok = reaper.ShowMessageBox('ReaClip contains Melodyne, edits may be lost if you load as a ReaClip. Load as subproject instead?', 'Melodyne Warning', 3)
--       reaper.ShowMessageBox(ok, "message box output", 0)  -- Yes == 6, No == 7, Cancel == 2
--     --if not ok then
--       break
--     end

--   end

-- end


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
  reaper.JS_WindowMessage_Send(me, "WM_COMMAND", 41001, 0, 0, 0) -- Media: Insert on a new track
  --reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVESEL'), 0) --SWS: Save current track selection
  reaper.Main_OnCommand(41816, 0) -- Item: Open associated project in new tab
  reaper.Main_OnCommand(40296, 0) -- Track: Select all tracks
  --CheckMelodyne() -- to write. if there's ARA info in the project then could give user the option to leave the ReaClp loaded as a subproject, where Melodyne should work.
  reaper.Main_OnCommand(40210, 0) --Track: Copy tracks
  SaveTempProject()
  reaper.Main_OnCommand(40860, 0) --Close current project tab
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_RSc4b08953457ee0ea58cc55d5ccce70175d05f0c5'), 0) -- Script: me2beats_Restore saved project tab, slot 1.lua
  reaper.Main_OnCommand(40005, 0) --Track: Remove tracks
  reaper.Main_OnCommand(42398, 0) -- Item: Paste items/tracks
end

function MoveItemsEnvelopesToEditCursor()
  reaper.Main_OnCommand(40289, 0) --Item: Unselect (clear selection of) all items
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_TOGITEMSEL'), 0) --SWS: Toggle selection of items on selected track(s)
  -- following needs 'envelope poitns move with media items enabled'
  -- chould check if it's on and if not, turn it off after moving
  
  local ra = reaper.GetToggleCommandState(41991) -- get ripple all state
  local rt = reaper.GetToggleCommandState(41990) -- get ripple per-track state

  reaper.Main_OnCommand(40310, 0) -- Set ripple editing per-track
  reaper.Main_OnCommand(40699, 0)-- Edit: Cut items
  reaper.Main_OnCommand(42398, 0)-- Item: Paste items/tracks
  
  if ra == 1 then -- if ripple editing (all) was originally on
  reaper.Main_OnCommand(40311, 0) -- set ripple editing (all tracks) on
  end
  if rt + ra == 0 then-- if ripple editing per track was also off before we temporarily set it on
  reaper.Main_OnCommand(40309, 0) -- set ripple editing off
  end
end

-- function RemoveImportedItem()
--   reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTORESEL'), 0) --SWS: Restore saved track selection
--   reaper.Main_OnCommand(40005, 0) --Track: Remove tracks
-- end


reaper.PreventUIRefresh(1) -- Prevent UI refreshing. Uncomment it only if the script works.
reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

InsertMediaItemAndExplodeInNewTab()
-- RemoveImportedItem()MoveItemsEnvelopesToEditCursor()
MoveItemsEnvelopesToEditCursor()

reaper.Undo_EndBlock("Insert ReaClip at Edit Cursor", -1) -- End of the undo block. Leave it at the bottom of your main function.

reaper.PreventUIRefresh(-1) -- Restore UI Refresh. Uncomment it only if the script works.

reaper.UpdateArrange() -- Update the arrangement (often needed)
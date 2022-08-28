--[[
@description ReaClips (build and browse a personal sound/clip/loop library)
@author pcp
@about 
  These scripts provide functionality for REAPER inspired by Ableton Live Clips and Studio One musicloops. Musical ideas and clips can be quickly saved from selected items, then browsed and organised in the Media Explorer, and loaded into an open project as exploded tracks or as subprojects.
  [License: GPL](http://www.gnu.org/licenses/gpl.html)
@links Repository https://github.com/s0u7h/pcp/
@version 1.09
@licence
@metapackage
@provides [nomain] .
  [main=main,mediaexplorer] pcp_Insert ReaClip at edit cursor (load and explode project on new tracks in current project).lua
  [main=main,mediaexplorer] pcp_Insert ReaClip at start (load and explode project on new tracks in current project).lua
  [main] pcp_Save ReaClip (selected items).lua
  [main] pcp_Save ReaClip to Beats folder (selected items).lua
  [main] pcp_Save ReaClip to FX Presets folder (selected items).lua
  [main] pcp_Save ReaClip to Melodyned Clips folder (selected items).lua
  [main] pcp_Save ReaClip to SFX folder (selected items).lua
  [main] pcp_Save ReaClip to user-defined folder (selected items).lua
  [main=main,mediaexplorer] pcp_Open Media Explorer to ReaClips path (edgemeal snippet).lua
  [data] toolbar_icons/Load ReaClip at Edit Cursor.png
  [data] toolbar_icons/Load ReaClip.png
  [data] toolbar_icons/ReaClips.png
  [data] toolbar_icons/Save ReaClip.png

Requires SWS, JS_ReaScriptAPI and ReaPack (for me2beats and cfillion repos)

This script creates a folder under the default save path called "ReaClips". 
To change the folder that this script saves to, use one of the "Save Reaclip - Preset X" scripts and
change the "path" name in user settings. The preset script will create a different ReaClip directory, 
e.g. path = "Synth Presets" or "Beats" or "Guitar Riffs" or "Melodyned Vocals"
The script will create this subdirectory under your Default Save Path (set in Prefs) if it doesn't exist.

Running the preset scripts rather than duplicating this script and changing the 'path' value below means
that if and when this script gets updated, the user settings will not be overwritten, as
the preset scripts simply call the main parent script. (Thanks X-Raym for preset script template!)

--]]

-----------------------
-- USER CONFIG AREA

-- best not to directly run this function, use one of the 'Save ReaClip'
-- actions instead
reaclips_path = "ReaClips"
open_in_mx = true

--END OF USER CONFIG AREA
----------------------



function SaveReaClipAndOpenMX()

  
-- check items are selected before executing script
sel_items = reaper.CountSelectedMediaItems(0)

if sel_items == 0 then
  reaper.ShowMessageBox('You must select item(s) before you can save a ReaClip', "No items selected", 0)
else

  --prompt to save open project first if dirty
  project_dirty = reaper.IsProjectDirty(proj)
  if project_dirty == 1 then 
    SaveCurrentProject()
  end
  SaveReaClip()
  if open_in_mx == true then
    reaper.defer(open_mx_to_reaclips_path())
  end
end
end

function error_exit(message)
  reaper.ShowMessageBox(message, "Error", 0)
  os.exit()
end

function retry_save()
  reaper.ShowMessageBox("ReaClip exists, try another file name", "File Exists", 5)
  retry = true
  if retry == true then
     SaveReaClip()
  end
end

function cancel()
  reaper.ShowMessageBox("Cancelled", "Save Cancelled", 0)
  os.exit()
end

function SaveCurrentProject()
  project_name = reaper.GetProjectName(0)
  -- show ok/cancel dialog
  local ok = reaper.ShowMessageBox("Save current project first", project_name, 1)
  if not ok then -- user pressed cancel in dialog
    cancel() 
  end
  if ok==1 then
    reaper.Main_OnCommand(40026, 0) --File: Save project // saves original project
  end
end

function SaveSelTracksSlot1()
  --me2beats snippet
  sel_tracks_str = ''
  for i = 0, reaper.CountSelectedTracks()-1 do
    sel_tracks_str = sel_tracks_str..reaper.GetTrackGUID(reaper.GetSelectedTrack(0,i))
  end

  reaper.DeleteExtState('me2beats_save-restore', 'sel_tracks_1', 0)
  reaper.SetExtState('me2beats_save-restore', 'sel_tracks_1', sel_tracks_str, 0)
end

function SaveSelTracksSlot2()
  --me2beats snippet
 sel_tracks_str = ''
  for i = 0, reaper.CountSelectedTracks()-1 do
    sel_tracks_str = sel_tracks_str..reaper.GetTrackGUID(reaper.GetSelectedTrack(0,i))
  end

  reaper.DeleteExtState('me2beats_save-restore', 'sel_tracks_2', 0)
  reaper.SetExtState('me2beats_save-restore', 'sel_tracks_2', sel_tracks_str, 0)

end

function RestoreSelTracksSlot1()
    --me2beats snippet
  local function nothing() end; local function bla() reaper.defer(nothing) end

  local sel_tracks_str = reaper.GetExtState('me2beats_save-restore', 'sel_tracks_1')
  if not sel_tracks_str or sel_tracks_str == '' then bla() return end

  reaper.Main_OnCommand(40297,0) -- unselect all tracks

  for guid in sel_tracks_str:gmatch'{.-}' do
    local tr = reaper.BR_GetMediaTrackByGUID(0, guid)
    if tr then reaper.SetTrackSelected(tr,1) end
  end
end

function RestoreSelTracksSlot12()
  --me2beats snippet
local function nothing() end; local function bla() reaper.defer(nothing) end

local sel_tracks_str_1 = reaper.GetExtState('me2beats_save-restore', 'sel_tracks_1')
local sel_tracks_str_2 = reaper.GetExtState('me2beats_save-restore', 'sel_tracks_2')

if not (sel_tracks_str_1 or sel_tracks_str_2) or (sel_tracks_str_1 == '' and sel_tracks_str_1 == '') then bla() return end

for guid in sel_tracks_str_1:gmatch'{.-}' do
  local tr = reaper.BR_GetMediaTrackByGUID(0, guid)
  if tr then reaper.SetTrackSelected(tr,1) end
end

for guid in sel_tracks_str_2:gmatch'{.-}' do
  local tr = reaper.BR_GetMediaTrackByGUID(0, guid)
  if tr then reaper.SetTrackSelected(tr,1) end
end
end

function SaveProjectTab()

  local cur_p = reaper.EnumProjects(-1, 0)
  local cur_p_str = tostring(cur_p):sub(-16)
  
  local ext_sec, ext_key = 'reaclip_og_save-restore', 'active_proj_tab'
  
  reaper.DeleteExtState(ext_sec, ext_key, 0)
  reaper.SetExtState(ext_sec, ext_key, cur_p_str, 0)

end

function RestoreProjectTab()
    --me2beats snippet
 local function nothing() end; local function bla() reaper.defer(nothing) end

  function get_cur_proj_tab_number()
    retval = nil
    for p = 1, 1000 do
      retval = reaper.EnumProjects(p, '')
      if not retval then projects = p break end
    end
    local retval_0  = reaper.EnumProjects(-1, '')
    for p = 1, projects do
      retval  = reaper.EnumProjects(p-1, '')
      if retval == retval_0 then cur_proj_tab = p break end
    end
    retval = nil; return cur_proj_tab-1, projects
  end


  local ext_sec, ext_key = 'reaclip_og_save-restore', 'active_proj_tab'
  saved_p_str = reaper.GetExtState(ext_sec, ext_key)
  if not saved_p_str or saved_p_str == '' then bla() return end


  cur_p_iter, projects = get_cur_proj_tab_number()


  for i = 0, projects-1 do
    local p = reaper.EnumProjects(i, 0)
    if saved_p_str == tostring(p):sub(-16) then iter = i break end
  end

  if not iter or iter == cur_p_iter then bla() return end

  d = math.abs(iter-cur_p_iter)-1
  d2 = projects-d

  if iter > cur_p_iter then if d < d2 then a = 40861 else d = d2 -2 a = 40862 end
  else if d < d2 then a = 40862 else d = d2 -2 a = 40861 end end

  for i = 0,d do reaper.Main_OnCommand(a,0) end -- prev/next project tab

end


function SaveReaClip()
-- this code adapted from paat's auto-save script, adding a user prompt and a default ReaClips subdirectory
  retval, savepath = reaper.get_config_var_string("defsavepath")
  if savepath == "" then
    error_exit("Cannot save file - no default save path")
  end
  osdate =  os.date("%Y-%m-%d-%H_%M_%S")
  filename = osdate
  local rv, rv_str = reaper.GetUserInputs("Save ReaClip as..", 1, "ReaClip Name: ,extrawidth=250", filename)
  if rv==true then
    filename = rv_str
  end
  if not rv then
    cancel()
  end

  new_dir = savepath .. "/" .. reaclips_path .. "/" .. filename
  new_path = new_dir .. "/" .. filename .. ".RPP"
  
  if reaper.file_exists(new_path) then
   retry_save("ReaClip already exists: \n" .. new_path)
   if retry == false then
      os.exit()
   else return
   end
  end
  
  if reaper.RecursiveCreateDirectory(new_dir, 0) == 0 then
    error_exit("Unable to create dir: \n" .. new_dir)
  end
 
  SaveProjectTab()
  reaper.Main_SaveProjectEx(proj, new_path, 0) --silently saves to temp folder without copying audio files - still atlased to the original
 
 -- reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_WNCLS3'), 0) -- close all floating fx windows
 -- reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_WNCLS4'), 0) -- close all  fx chain windows
 
  reaper.Main_OnCommand(41929, 0)   -- New project tab (ignore default template)
  reaper.Main_openProject("noprompt:" .. new_path)
  
  -- this section crops to the selected items and gets rid of extraneous tracks
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SELTRKWITEM'), 0) -- SWS: Select only track(s) with selected item(s)
  reaper.Main_OnCommand(40290, 0)-- Time selection: Set time selection to items
  reaper.Main_OnCommand(40049, 0) -- Time selection: Crop project to time selection
  reaper.Main_OnCommand(40289, 0) --Item: Unselect (clear selection of) all items
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_TRACKS'), 0) --SWS/BR: Focus tracks
 reaper.Main_OnCommand(40340, 0)  --Track: Unsolo all tracks
 reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SELROUTED'), 0) -- SWS: Select tracks with active routing to selected track(s)  
  SaveSelTracksSlot1()
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_RS07454ab62d927454fdbf507028b3e5299d3619dd'), 0) -- Script: cfillion_Select source tracks of selected tracks receives recursively.lua
  SaveSelTracksSlot2()
  RestoreSelTracksSlot1()
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_RS442c61972c3d71aaa886a5a47d809df69645bffa'), 0) -- Script: cfillion_Select destination tracks of selected tracks sends recursively.lua
  RestoreSelTracksSlot12()
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_TOGTRACKSEL'), 0) --SWS: Toggle (invert) track selection
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_REMOVE_TR_GRP'), 0) --SWS/S&M: Remove track grouping for selected tracks // otherwise it could delete the tracks we want to save
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_TRACKS'), 0) --SWS/BR: Focus tracks
  reaper.Main_OnCommand(40184, 0) -- Remove items/tracks/envelope points (depending on focus) - no prompting
  
  -- auto-save it to the reaclips folder and render a proxy, then close the tab silently: 
  -- still no way to set an option to save media with the file and set save path with Main_SaveProjectEx
   
 reaper.Main_OnCommand(42332, 0) -- File: Save project and render RPP-PROX - shouldn't prompt after last save.
 reaper.Main_SaveProject(0, true) -- *now* the project is saved with any remaining source media.  the boolean true forces a 'save as', and user *should* just have to hit enter (i.e. click OK) but if any issues then check that 'copy media' is selected (should be default) as there's no way in REAPER to specify saving copies of source audio. the boolean true forces a 'save as'
 reaper.Main_openProject("noprompt:" .. new_path) -- again, stops the prompt after rendering rpp-prox
 reaper.Main_OnCommand(40860, 0)  --Close current project tab
 
 
 RestoreProjectTab()
 
end


function open_mx_to_reaclips_path()
  --Open Media Explorer to Reaclips path - search rpp - sort last modified (modified edgemeal)
  
  -- Show Media Explorer, set path, search and sort last modified
  -- v1.03 - Edgemeal - Mar 22, 2021
  -- Donate: https://www.paypal.me/Edgemeal
  --
  -- Tested: Win10/x64, REAPER v6.51+dev0318/x64, js_ReaScriptAPI v1.301
  -- v1.03... Wait time set in seconds, added delay before scrolling to top.
  -- v1.02.1. Scroll list to top after sort.
  -- v1.02... Make filelist global, unselect files in list before sorting.
  
  -- USER SETTINGS -- USER SETTINGS -- USER SETTINGS -- USER SETTINGS --
  local search = ".rpp"
  local wait = 0.600 -- Explorer needs time to update/populate, set Time in seconds to wait between actions.
  local reaclips_folder = savepath .. "/" .. reaclips_path
  
  -- setup >>
  if not reaper.APIExists('JS_Window_SetTitle') then
    reaper.MB('js_ReaScriptAPI extension is required for this script.', 'Missing API', 0)
    return
  end
  -- open explorer/make visible/select it
  local explorer = reaper.OpenMediaExplorer("", false)
  if not explorer then
    reaper.Main_OnCommand(50124, 0) -- Media explorer: Show/hide media explorer
    explorer = reaper.OpenMediaExplorer("", false)
  end
  -- get search combobox, show explorer if docked and not visible
  local cbo_search = reaper.JS_Window_FindChildByID(explorer, 0x3F7)
  if not cbo_search then return end
  if not reaper.JS_Window_IsVisible(cbo_search) then reaper.Main_OnCommand(50124, 0) end
  -- get file list
  local filelist = reaper.JS_Window_FindChildByID(explorer, 0x3E9)
  -- variable for wait timer
  local init_time = reaper.time_precise()
  --<< setup
  
  function PostKey(hwnd, vk_code) -- https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
    reaper.JS_WindowMessage_Post(hwnd, "WM_KEYDOWN", vk_code, 0,0,0)
    reaper.JS_WindowMessage_Post(hwnd, "WM_KEYUP", vk_code, 0,0,0)
  end
  
  function PostText(hwnd, str) -- https://docs.microsoft.com/en-us/windows/win32/inputdev/wm-char
    for char in string.gmatch(str, ".") do
      local ret = reaper.JS_WindowMessage_Post(hwnd, "WM_CHAR", string.byte(char),0,0,0)
      if not ret then break end
    end
  end
  
  function SetExplorerPath(hwnd, folder)
    local cbo = reaper.JS_Window_FindChildByID(hwnd, 0x3EA)
    local edit = reaper.JS_Window_FindChildByID(cbo, 0x3E9)
    if edit then
      reaper.JS_Window_SetTitle(edit, "")
      PostText(edit, folder)
      PostKey(edit, 0xD)
    end
  end
  
  function SetExplorerSearch(hwnd, text)
    local cbo = reaper.JS_Window_FindChildByID(hwnd, 0x3F7)
    local edit = reaper.JS_Window_FindChildByID(cbo, 0x3E9)
    if edit then
      reaper.JS_Window_SetTitle(edit, "")
      PostText(edit, text)
      PostKey(edit, 0xD)
    end
  end
  
  
  function SortDateModified()
    if reaper.time_precise() < init_time then
      reaper.defer(SortDateModified)
    else
      reaper.JS_Window_SetFocus(filelist) -- Set focus on Media Explorer file list.
      reaper.JS_ListView_SetItemState(filelist, -1, 0x0, 0x2) -- unselect items in file list
      reaper.JS_WindowMessage_Send(explorer, "WM_COMMAND", 42256,0,0,0) -- "sort title" list
      reaper.JS_WindowMessage_Send(explorer, "WM_COMMAND", 42085,0,0,0) -- rescan database for new files    
      reaper.JS_WindowMessage_Send(explorer, "WM_COMMAND", 42254,0,0,0) -- "sort modified file" list
      reaper.JS_WindowMessage_Send(explorer, "WM_COMMAND", 42254,0,0,0) -- "sort modified file" list
      init_time = reaper.time_precise() + wait
      ScrollToTop()
    end
  end
  
  function ScrollToTop()
    if reaper.time_precise() < init_time then
      reaper.defer(ScrollToTop)
    else
      reaper.JS_WindowMessage_Send(filelist, "WM_VSCROLL", 6,0,0,0) -- scroll list to top
    end
  end
  
  function Main() 
    SetExplorerPath(explorer, reaclips_folder)       -- set path field // this is by default the "ReaClips" folder defined at the top of the script
    SetExplorerSearch(explorer, search)   -- set search field 
    init_time = reaper.time_precise() + wait
    SortDateModified()
    reaper.JS_WindowMessage_Send(explorer, "WM_COMMAND", 40018,0,0,0) -- refresh MX browser (PCP Nb - this seems necessary for folders but not databases)
  end
  
  function Initalize() 
    if reaper.time_precise() < init_time then
      reaper.defer(Initalize)
    else
      Main()
    end
  end
  
  init_time = reaper.time_precise() + wait
  Initalize()

end

function CheckSWS()
  local SWS_installed
  if not reaper.BR_SetMediaTrackLayouts then
    local retval = reaper.ShowMessageBox("SWS extension is required by this script.\nHowever, it doesn't seem to be present for this REAPER installation.\n\nDo you want to download it now ?", "Warning", 1)
    if retval == 1 then
      Open_URL("http://www.sws-extension.org/download/pre-release/")
    end
  else
    SWS_installed = true
  end
  return SWS_installed
end


--reaper.PreventUIRefresh(1) -- Prevent UI refreshing. Uncomment it only if the script works.



if not preset_file_init then -- If the file is run directly, it will execute SaveReaClipAndOpenMX(), else it will wait for Init() to be called explicitely from the preset scripts (usually after having modified some global variable states).
  -- TODO - add checks for cfillion and me2beats repos in reapack and for js_reascript api
  CheckSWS()
  if SWS_installed == true then
    SaveReaClipAndOpenMX()
 end
end



--reaper.PreventUIRefresh(-1) -- Restore UI Refresh. Uncomment it only if the script works.

reaper.UpdateArrange() -- Update the arrangement (often needed)



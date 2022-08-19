--Open Media Explorer to ReaClips database - search rpp - sort last modified (edgemeal)
--=Edgemeals script from the forum
-- Need to load this script separately in both the Media Explorer and Main contexts

-- Show Media Explorer, set path, search and sort last modified
-- v1.03 - Edgemeal - Mar 22, 2021
-- Donate: https://www.paypal.me/Edgemeal
--
-- Tested: Win10/x64, REAPER v6.51+dev0318/x64, js_ReaScriptAPI v1.301
-- v1.03... Wait time set in seconds, added delay before scrolling to top.
-- v1.02.1. Scroll list to top after sort.
-- v1.02... Make filelist global, unselect files in list before sorting.



-- USER SETTINGS -- USER SETTINGS -- USER SETTINGS -- USER SETTINGS --
local folder = "90pc"
local search = ".rpp"
local wait = 0.400 -- Explorer needs time to update/populate, set Time in seconds to wait between actions.
-- USER SETTINGS -- USER SETTINGS -- USER SETTINGS -- USER SETTINGS --


-- setup >>
retval, savepath = reaper.get_config_var_string("defsavepath")
if savepath == "" then
  error_exit("no default save path")
end

local path = savepath .. folder
 
function error_exit(message)
  reaper.ShowMessageBox(message, "Error", 0)
  os.exit()
end  
 

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
  SetExplorerPath(explorer, path)       -- set path field
  SetExplorerSearch(explorer, search)   -- set search field 
  init_time = reaper.time_precise() + wait
  SortDateModified()
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

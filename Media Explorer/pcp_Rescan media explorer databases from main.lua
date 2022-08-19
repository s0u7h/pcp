-- @noindex


local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(reaper.NamedCommandLookup"40289", 1) -- unselect all items

me = reaper.JS_Window_Find("Media Explorer", true)
reaper.JS_WindowMessage_Send(me, "WM_COMMAND", 42085, 0, 0, 0) -- Scan all databases for new files
reaper.JS_WindowMessage_Send(me, "WM_COMMAND", 42255, 0, 0, 0) -- Sort file list by column: 'File Type'
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)

reaper.Undo_EndBlock("Rescan media explorer databases from main", -1) 

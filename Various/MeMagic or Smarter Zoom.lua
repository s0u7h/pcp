



function check_mouse_cursor()
local window, segment, details = reaper.BR_GetMouseCursorContext()
local item = reaper.BR_GetMouseCursorContext_Item()
local in_midi = reaper.BR_GetMouseCursorContext_MIDI()

if in_midi ~= nil then -- if  midi editor active then

  reaper.Main_OnCommand(reaper.NamedCommandLookup('_RSae160f9c0e4ed7ccbb6edc5d7a57d1a54a28168a'), 0) -- Script: FTC_MeMagic.lua
  
return
end

if item == null then
curpos = reaper.GetCursorPosition()-- save edit cursor position
reaper.Main_OnCommand(40513, 0) -- View: Move edit cursor to mouse cursor
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_HSCROLL50'), 0)  -- SWS: Horizontal scroll to put edit cursor at 50%
 reaper.Main_OnCommand(reaper.NamedCommandLookup('_RS878c1e78000ce6097f5dd5ac2589c29987089cd5'), 0) --Script: amagalma_Load horizontal zoom preset 3.lua
 reaper.SetEditCurPos(curpos, false, false)-- restore edit cursor position
 
return
end

-- local take = reaper.GetMediaItemTake(item,0)

--local MediaItemIsMIDI = reaper.TakeIsMIDI(take)
--if MediaItemIsMIDI ~= nil then 

      reaper.Main_OnCommand(reaper.NamedCommandLookup('_RSae160f9c0e4ed7ccbb6edc5d7a57d1a54a28168a'), 0) -- Script: FTC_MeMagic.lua
--else

 reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_ITEMZOOM'), 0) -- SWS Zoom to selected items
 
--end
end


check_mouse_cursor()





-- USER CONFIG AREA ---------------------------------------------------------

console = true -- true/false: display debug messages in the console

----------------------------------------------------- END OF USER CONFIG AREA


-- Display a message in the console for debugging
function Msg(value)
  if console then
    reaper.ShowConsoleMsg(tostring(value) .. "\n")
  end
end


-- Main function
function main()
 -- local retval,tracknumber,fxnumber,paramnumber = reaper.GetLastTouchedFX();
 -- if retval == false then return end;
 -- local envelope =  reaper.GetFXEnvelope(Track,fxnumber,paramnumber,true);
  -- Check the user has a CC lane selected (e.g. CC21)
  reaper.MIDIEditor_OnCommand(reaper.MIDIEditor_GetActive(), 40668) -- Select all CC events in last clicked lane
 reaper.Main_OnCommand(reaper.NamedCommandLookup('_RS57e8e8d2bf0343d80a486312a05f3e64bca05791'), 0)  --  Script: Archie_Env; Show track envelope last touched FX parameter(add point in start of time selection)(`).lua
  --reaper.Main_OnCommand(41142, 0) -- FX: Show/hide track envelope for last touched FX parameter
  -- link it to the fx parameter that's being modulated (how?)
  -- maybe on clicking a control and F1 to show envelope in lane for last touched parameter, can compuund that action, create/show the envelope and copy the cc from last touched lane to it?

 reaper.MIDIEditor_OnCommand(reaper.MIDIEditor_GetActive(), reaper.NamedCommandLookup('_BR_ME_CC_TO_ENV_SQUARE')) -- SWS/BR: Convert selected CC events in active item to square envelope points in selected envelope
  reaper.MIDIEditor_OnCommand(reaper.MIDIEditor_GetActive(), 40667) -- Edit: Delete events

end


-- Here: your conditions to avoid triggering main without reason.

reaper.PreventUIRefresh(1)

reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

main()

reaper.Undo_EndBlock("Script: pcp_Convert last touched MIDI CC lane to track envelope lane for last-touched FX parameter.lua", -1) -- End of the undo block. Leave it at the bottom of your main function.

reaper.UpdateArrange()

reaper.PreventUIRefresh(-1)

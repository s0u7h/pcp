-- @noindex
-- USER CONFIG AREA 1/2 ------------------------------------------------------

-- Dependency Name
local script = "pcp_Reaclip_core.lua" -- 1. The target script path relative to this file. If no folder, then it means preset file is right to the target script.

-------------------------------------------------- END OF USER CONFIG AREA 1/2

-- PARENT SCRIPT CALL --------------------------------------------------------

-- Get Script Path
local script_folder = debug.getinfo(1).source:match("@?(.*[\\|/])")
local script_path = script_folder .. script -- This can be erased if you prefer enter absolute path value above.

-- Prevent Init() Execution
preset_file_init = true

-- Run the Script
if reaper.file_exists( script_path ) then
  dofile( script_path )
else
  reaper.MB("Missing parent script.\n" .. script_path, "Error", 0)
  return
end

---------------------------------------------------- END OF PARENT SCRIPT CALL

-- USER CONFIG AREA 2/2 ------------------------------------------------------

reaclips_path = "Beats"
open_in_mx = true

-------------------------------------------------- END OF USER CONFIG AREA 2/2

-- RUN -------------------------------------------------------------------

SaveReaClipAndOpenMX() -- run the function of the target script.

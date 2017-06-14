local map = ...
local game = map:get_game()

local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)

function map:on_started(destination)

  if destination == from_1f_n then
    map:set_doors_open("auto_door_c")
  elseif destination == from_1f_w or destination == from_1f_sw then
    map:set_doors_open("auto_door_d")
  end
end
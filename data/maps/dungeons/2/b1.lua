local map = ...
local game = map:get_game()

local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)

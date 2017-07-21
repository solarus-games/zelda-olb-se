local map = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

function map:on_started(destination)

  if game:get_value("dungeon_2_b1_prison_npc_key_1") then
    prison_npc_1:remove()
  end
  if game:get_value("dungeon_2_b1_prison_npc_key_2") then
    prison_npc_2:remove()
  end
  if game:get_value("dungeon_2_b1_prison_npc_key_3") then
    prison_npc_3:remove()
  end
end

-- Lua script of map houses/pit_house.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

function pit:on_interaction()

  if not game:is_dungeon_finished(1) then
    game:start_dialog("houses.pit_house.go_dungeon_1")
    game:set_value("pit_house_talked", true)
  end
end

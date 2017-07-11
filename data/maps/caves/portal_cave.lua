-- Lua script of map caves/portal_cave.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

end

function map:on_opening_transition_finished(destination)

  if destination == from_intro then
    if not game:get_value("portal_cave_tutorial_1") then
      game:start_dialog("caves.portal_cave.help")
      game:set_value("portal_cave_tutorial_1", true)
    end
  end
end

function tutorial_sensor:on_activated()

  if not game:get_value("portal_cave_tutorial_2") then
    game:start_dialog("caves.portal_cave.tutorial", game:get_command_keyboard_binding("action"))
    game:set_value("portal_cave_tutorial_2", true)
  end
end

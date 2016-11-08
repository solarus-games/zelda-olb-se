-- This script initializes game values for a new savegame file.
-- You should modify the initialize_new_savegame() function below
-- to set values like the initial life and equipment
-- as well as the starting location.
--
-- Usage:
-- local initial_game = require("scripts/initial_game")
-- initial_game:initialize_new_savegame(game)

local initial_game = {}

-- Sets initial values to a new savegame file.
function initial_game:initialize_new_savegame(game)

  game:set_starting_location("caves/portal_cave")  -- TODO intro
  game:set_max_money(999)  -- TODO check this
  game:set_max_life(6)
  game:set_life(game:get_max_life())
  game:set_value("force", 0)
  game:set_value("defense", 0)
  game:set_value("time_played", 0)
  game:get_item("bombs_counter"):set_variant(1)  -- TODO check this
  game:set_value("keyboard_commands", "f1")
  game:set_value("keyboard_look", "left control")
  game:set_value("keyboard_map", "p")
  game:set_value("keyboard_monsters", "m")
  game:set_value("keyboard_run", "left shift")
  game:set_value("keyboard_save", "escape")
end

return initial_game

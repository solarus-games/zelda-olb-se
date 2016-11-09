-- This script manages the transformation of the hero into Oni-Link.

-- When the hero is transformed, his sprites are changed as follows:
-- Tunic sprite: Oni-Link
-- Sword sprite: Oni-Link Sword 1, or 2 if Spirit Mask possessed variant is 2
-- Shield sprite: Oni-Link Shield 1, or 2 if Spirit Mask possessed variant is 2
-- Force and defense changes are handled in hero.lua.

require("scripts/multi_events")

local function initialize_onilink_features(game)

  function game:is_onilink()
    return game:get_value("onilink")
  end

  function game:start_onilink()
    game:set_value("onilink", true)
    -- TODO when Oni-Link, change the tunic, sword and shield sprites
  end

  function game:stop_onilink()
    game:set_value("onilink", false)
  end

end

-- Set up Oni-Link features on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", initialize_onilink_features)

return true

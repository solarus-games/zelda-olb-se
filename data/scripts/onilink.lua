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

    if game:is_onilink() then
      return
    end

    game:set_value("onilink", true)

    -- TODO different sword and shield sprites if the player
    -- has the Fierce Deity Mask
    local hero = game:get_hero()
    hero:set_tunic_sprite_id("hero/tunic_onilink")
    hero:set_sword_sprite_id("hero/sword_onilink1")
    hero:set_shield_sprite_id("hero/shield_onilink1")

    if not game:get_value("onilink_tutorial") then
      game:set_value("onilink_tutorial", true)
      game:start_dialog("onilink_tutorial")
    end
  end

  function game:stop_onilink()

    if not game:is_onilink() then
      return
    end

    game:set_value("onilink", false)

    local hero = game:get_hero()
    hero:set_tunic_sprite_id("hero/tunic" .. game:get_ability("tunic"))
    hero:set_sword_sprite_id("hero/sword" .. game:get_ability("sword"))
    hero:set_shield_sprite_id("hero/shield" .. game:get_ability("shield"))
  end

  function game:get_anger()
    return game:get_value("anger") or 0
  end

  function game:set_anger(anger)

    local old_anger = game:get_anger()
    if anger == old_anger then
      return
    end

    local max_anger = game:get_max_anger()
    if anger < 0 then
      anger = 0
    end
    if anger > max_anger then
      anger = max_anger
    end

    game:set_value("anger", anger)

    if anger == max_anger then
      game:start_onilink()
    elseif anger == 0 then
      game:stop_onilink()
    end
  end

  function game:add_anger(anger)
    game:set_anger(game:get_anger() + anger)
  end

  function game:remove_anger(anger)
    game:set_anger(game:get_anger() - anger)
  end

  function game:get_max_anger()
    return 5 + game:get_num_graals() * 5
  end
end

-- Set up Oni-Link features on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", initialize_onilink_features)

return true

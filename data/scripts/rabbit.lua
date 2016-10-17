-- Adds rabbit transformation features to games.
-- The following functions are provided:
-- - game:is_rabbit():      Returns whether the hero is currently turned into a rabbit.
-- - game:start_rabbit():   Turns the hero into a rabbit until he gets hurt.
-- - game:stop_rabbit():    Stops the rabbit transformation.

-- Usage:
-- require("scripts/rabbit")

require("scripts/multi_events")

local function initialize_rabbit_features(game)

  -- Returns whether the hero is currently turned into a rabbit.
  function game:is_rabbit()
    return game:get_value("rabbit")
  end

  -- Turns the hero into a rabbit until he gets hurt.
  function game:start_rabbit()

    if game:is_rabbit() then
      return
    end

    local map = game:get_map()
    local hero = map:get_hero()
    local x, y, layer = hero:get_position()
    local rabbit_effect = map:create_custom_entity({
      x = x,
      y = y - 5,
      layer = layer,
      width = 16,
      height = 16,
      direction = 0,
      sprite = "hero/rabbit_explosion",
    })
    sol.timer.start(hero, 500, function()
      rabbit_effect:remove()
    end)

    game:set_value("rabbit", true)

    hero:freeze()
    hero:unfreeze()  -- Get back to walking normally before changing sprites.

    -- Temporarily remove the equipment and block using items.
    local tunic = game:get_ability("tunic")
    game:set_ability("tunic", 1)
    hero:set_tunic_sprite_id("hero/rabbit_tunic")

    local sword = game:get_ability("sword")
    game:set_ability("sword", 0)

    local shield = game:get_ability("shield")
    game:set_ability("shield", 0)

    local keyboard_item_1 = game:get_command_keyboard_binding("item_1")
    game:set_command_keyboard_binding("item_1", nil)
    local joypad_item_1 = game:get_command_joypad_binding("item_1")
    game:set_command_joypad_binding("item_1", nil)

    local keyboard_item_2 = game:get_command_keyboard_binding("item_2")
    game:set_command_keyboard_binding("item_2", nil)
    local joypad_item_2 = game:get_command_joypad_binding("item_2")
    game:set_command_joypad_binding("item_2", nil)

    -- Write the previous equipement to the game in case of game-over or save/quit as a rabbit.
    game:set_value("rabbit_saved_tunic", tunic)
    game:set_value("rabbit_saved_sword", sword)
    game:set_value("rabbit_saved_shield", shield)
    game:set_value("rabbit_saved_keyboard_item_1", keyboard_item_1)
    game:set_value("rabbit_saved_joypad_item_1", joypad_item_1)
    game:set_value("rabbit_saved_keyboard_item_2", keyboard_item_2)
    game:set_value("rabbit_saved_joypad_item_2", joypad_item_2)
  end

  -- Stops the rabbit transformation.
  function game:stop_rabbit()

    if not game:is_rabbit() then
      return
    end
    local hero = game:get_hero()
    hero:set_tunic_sprite_id("hero/tunic" .. game:get_value("rabbit_saved_tunic"))
    game:set_ability("tunic", game:get_value("rabbit_saved_tunic"))
    game:set_ability("sword", game:get_value("rabbit_saved_sword"))
    game:set_ability("shield", game:get_value("rabbit_saved_shield"))
    game:set_command_keyboard_binding("item_1", game:get_value("rabbit_saved_keyboard_item_1"))
    game:set_command_joypad_binding("item_1", game:get_value("rabbit_saved_joypad_item_1"))
    game:set_command_keyboard_binding("item_2", game:get_value("rabbit_saved_keyboard_item_2"))
    game:set_command_joypad_binding("item_2", game:get_value("rabbit_saved_joypad_item_2"))
    game:set_value("rabbit", false)
  end

  game:stop_rabbit()  -- In case the game was saved as a rabbit.
end

-- Set up rabbit features on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", initialize_rabbit_features)

-- Stop rabbit mode on game-over.
game_meta:register_event("on_game_over_started", function(game)
  game:stop_rabbit()
end)

-- Stop rabbit mode when entering some hero states.
local hero_meta = sol.main.get_metatable("hero")
hero_meta:register_event("on_state_changed", function(hero, state)
  if state == "hurt" or state == "treasure" then
    hero:get_game():stop_rabbit()
  end
end)

return true

-- Adds a game-over animation to games.

-- Usage:
-- require("scripts/menus/game_over")

require("scripts/multi_events")

-- Starts the game-over animation.
local function start_game_over(game)

  sol.audio.play_sound("hero_dying")
  local map = game:get_map()
  local hero = game:get_hero()
  local death_count = game:get_value("death_count") or 0
  game.lit_torches_by_map = nil  -- See entities/torch.lua
  game:set_value("death_count", death_count + 1)
  hero:set_visible(false)
  local x, y, layer = hero:get_position()

  -- Use a fake hero entity for the animation because
  -- the one of the hero is suspended.
  local fake_hero = map:create_custom_entity({
    x = x,
    y = y,
    layer = layer,
    width = 16,
    height = 16,
    direction = 0,
    sprite = hero:get_tunic_sprite_id(),
  })
  fake_hero:get_sprite():set_animation("dying")
  fake_hero:get_sprite():set_ignore_suspend(true)  -- Cannot be done on the hero (yet). TODO since 1.5 it should now be possible
  local timer = sol.timer.start(game, 3000, function()
    -- Restart the game.
    game:start()
  end)
end

-- Set up game-over features on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_game_over_started", start_game_over)

return true

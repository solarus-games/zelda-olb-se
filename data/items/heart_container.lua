local item = ...
local game = item:get_game()

function item:on_created()

  item:set_sound_when_picked(nil)
  item:set_sound_when_brandished("heart_container")
end

function item:on_obtained(variant, savegame_variable)

  game:add_max_life(2)
  game:set_life(game:get_max_life())
end


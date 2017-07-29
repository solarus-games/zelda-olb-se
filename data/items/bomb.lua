local item = ...
local game = item:get_game()

function item:on_created()

  item:set_can_disappear(true)
  item:set_brandish_when_picked(false)

  local possession_bombs_counter = game:get_value("possession_bombs_counter") or 0
  item:set_obtainable(possession_bombs_counter > 0)
end

function item:on_obtaining(variant, savegame_variable)

  -- Obtaining bombs increases the bombs counter.
  local amounts = {1, 3, 8}
  local amount = amounts[variant]
  if amount == nil then
    error("Invalid variant '" .. variant .. "' for item 'bomb'")
  end
  game:get_item("bombs_counter"):add_amount(amount)
end


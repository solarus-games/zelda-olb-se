local item = ...
local game = item:get_game()

function item:on_created()

  item:set_shadow("small")
  item:set_can_disappear(true)
  item:set_brandish_when_picked(false)

  local possession_bow = game:get_value("possession_bow") or 0
  item:set_obtainable(possession_bow > 0)

end

function item:on_obtaining(variant, savegame_variable)
  -- This function can also be called by silver arrows.

  -- Obtaining arrows increases the counter of the bow.
  local amounts = { 1, 5, 10 }
  local amount = amounts[variant]
  if amount == nil then
    error("Invalid variant '" .. variant .. "' for item 'arrow'")
  end

  game:get_item("bow"):add_amount(amount)
end

function item:on_pickable_created(pickable)

  if game:has_item("bow_silver") then
    -- Automatically replace the normal arrow by a silver one.
    local _, variant, savegame_variable = pickable:get_treasure()
    local map = pickable:get_map()
    local x, y, layer = pickable:get_position()
    map:create_pickable{
      layer = layer,
      x = x,
      y = y,
      treasure_name = "arrow_silver",
      treasure_variant = variant,
      treasure_savegame_variable = savegame_variable,
    }
    pickable:remove()
  end
end

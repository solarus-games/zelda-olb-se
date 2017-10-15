-- Initialize hero behavior specific to this quest.

require("scripts/multi_events")
require("scripts/onilink")

local hero_meta = sol.main.get_metatable("hero")

-- Returns the force of attacking with the sword.
-- Depends on the current sword and on the Oni-Link state.
function hero_meta:get_force()

  local game = self:get_game()
  local force = game:get_item("sword"):get_variant()
  if game:is_onilink() then
    force = force + 1
  end
  return force
end

-- Returns the defense of the hero.
-- Depends on the current shield, tunic and on the Oni-Link state.
function hero_meta:get_defense()

  local game = self:get_game()
  local defense = game:get_item("shield"):get_variant() + game:get_item("tunic"):get_variant() - 1
  if defense > 0 and game:is_onilink() then
    defense = defense - 1
  end
  return defense
end

-- Redefine how to calculate the damage received by the hero.
function hero_meta:on_taking_damage(damage)

  -- In the parameter, the damage unit is 1/2 of a heart.
  local game = self:get_game()
  local defense = self:get_defense()
  if defense <= 0 then
    -- Multiply the damage by two if the hero has no defense at all.
    damage = damage * 2
  else
    damage = math.floor(damage / defense)
    if damage <= 0 then
      damage = 1
    end
  end

  game:remove_life(damage)

  -- Increase anger
  game:add_anger(1)  -- TODO check if it is always 1
end

-- Detect the position of the hero to mark visited rooms in dungeons.
hero_meta:register_event("on_position_changed", function(hero)

  local map = hero:get_map()
  local game = map:get_game()
  local dungeon = game:get_dungeon()

  if dungeon == nil then
    return
  end

  local map_width, map_height = map:get_size()
  local room_width, room_height = 320, 240  -- TODO don't hardcode these numbers
  local num_columns = math.floor(map_width / room_width)

  local hero_x, hero_y = hero:get_center_position()
  local column = math.floor(hero_x / room_width)
  local row = math.floor(hero_y / room_height)
  local room = row * num_columns + column + 1

  game:set_explored_dungeon_room(nil, nil, room)
end)

return true

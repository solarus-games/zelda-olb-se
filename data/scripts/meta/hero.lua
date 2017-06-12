-- Initialize hero behavior specific to this quest.

require("scripts/multi_events")
require("scripts/onilink")

local hero_meta = sol.main.get_metatable("hero")

-- Returns the force of attacking with the sword.
-- Depends on the current sword and on the Oni-Link state.
function hero_meta:get_force()

  local game = self:get_game()
  local force = get_item("sword"):get_variant()
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
end

return true

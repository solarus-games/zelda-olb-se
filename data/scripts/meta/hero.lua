-- Initialize hero behavior specific to this quest.

local hero_meta = sol.main.get_metatable("hero")

-- Redefine how to calculate the damage received by the hero.
function hero_meta:on_taking_damage(damage)

  -- Here, self is the hero.
  local game = self:get_game()

  -- In the parameter, the damage unit is 1/2 of a heart.

  local defense = game:get_value("defense")
  if defense == 0 then
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

-- Stop rabbit mode when entering some states.
function hero_meta:on_state_changed(state)

  if state == "hurt" or state == "treasure" then
    local game = self:get_game()
    if game:is_rabbit() then
      game:stop_rabbit()
    end
  end
end

return true

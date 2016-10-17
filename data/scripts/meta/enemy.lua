-- Initialize enemy behavior specific to this quest.

local enemy_meta = sol.main.get_metatable("enemy")

-- Redefine how to calculate the damage inflicted by the sword.
function enemy_meta:on_hurt_by_sword(hero, enemy_sprite)

  local force = hero:get_game():get_value("force")
  local reaction = self:get_attack_consequence_sprite(enemy_sprite, "sword")
  -- Multiply the sword consequence by the force of the hero.
  local life_lost = reaction * force
  if hero:get_state() == "sword spin attack" then
    -- And multiply this by 2 during a spin attack.
    life_lost = life_lost * 2
  end
  self:remove_life(life_lost)
end

-- When an enemy is killed, add it to the encyclopedia.
function enemy_meta:on_removed()

  if self:get_life() <= 0 then
    local breed = self:get_breed()
    local game = self:get_game()
    game:get_item("monsters_encyclopedia"):add_monster_type_killed(breed)
  end
end

-- Helper function to inflict an explicit reaction from a scripted weapon.
-- TODO this should be in the Solarus API one day
function enemy_meta:receive_attack_consequence(attack, reaction)

  if type(reaction) == "number" then
    self:hurt(reaction)
  elseif reaction == "immobilized" then
    self:immobilize()
  elseif reaction == "protected" then
    sol.audio.play_sound("sword_tapping")
  elseif reaction == "custom" then
    if self.on_custom_attack_received ~= nil then
      self:on_custom_attack_received(attack)
    end
  end

end

return true

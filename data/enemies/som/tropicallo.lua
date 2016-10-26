-- Tropicallo boss.

local enemy = ...

function enemy:on_created()

  self:set_life(8)
  self:set_damage(1)
  self:create_sprite("enemies/" .. enemy:get_breed())
  self:set_hurt_style("boss")
  self:set_pushed_back_when_hurt(false)
end

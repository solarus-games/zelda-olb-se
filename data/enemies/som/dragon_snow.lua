-- Snow Dragon boss.

local enemy = ...

function enemy:on_created()

  enemy:set_life(90)
  enemy:set_damage(24)
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_hurt_style("boss")
  enemy:set_pushed_back_when_hurt(false)

  enemy:set_invincible()
  enemy:set_fire_reaction(3)
end

-- TODO lose 8 life points when hit by the fireball from the red dragon

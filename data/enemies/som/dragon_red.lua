-- Red Dragon boss.

local enemy = ...

function enemy:on_created()

  enemy:set_life(60)
  enemy:set_damage(24)
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_hurt_style("boss")
  enemy:set_pushed_back_when_hurt(false)

  enemy:set_invincible()
  enemy:set_ice_reaction(3)
end

-- TODO lose 6 life points when hit by the iceball from the snow dragon

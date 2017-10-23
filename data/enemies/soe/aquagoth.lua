-- Aquagoth boss.

local enemy = ...

function enemy:on_created()

  enemy:set_life(50)
  enemy:set_damage(8)
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_hurt_style("boss")
  enemy:set_pushed_back_when_hurt(false)

  enemy:set_invincible()
end

local enemy = ...

function enemy:on_created()

  enemy:set_life(999)
  enemy:set_damage(1)
  enemy:set_pushed_back_when_hurt(false)
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_invincible()
  enemy:set_attack_consequence("sword", "protected")
  enemy:set_attack_consequence("thrown_item", "protected")
end

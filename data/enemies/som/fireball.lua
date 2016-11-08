local enemy = ...

function enemy:on_created()

  enemy:set_life(1)
  enemy:set_damage(8)  -- Same damage on the hero and on the Snow Dragon.
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_invincible()
end

-- TODO the snow dragon loses 8 life points when getting the fireball back

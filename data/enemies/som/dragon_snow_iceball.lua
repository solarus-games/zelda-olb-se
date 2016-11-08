local enemy = ...

function enemy:on_created()

  enemy:set_life(1)
  enemy:set_damage(6)  -- Same damage on the hero and on the Red Dragon.
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_invincible()
end

-- TODO the red dragon loses 6 life points when getting the iceball back

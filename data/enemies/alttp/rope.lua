local enemy = ...
local game = enemy:get_game()

-- Rope: a snake that follows the hero.
-- Sets the hero's life to 1 when hurting him.

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 1,
  damage = 0,
  normal_speed = 64,
  faster_speed = 64,
}

behavior:create(enemy, properties)

-- Set the life to 1.
function enemy:on_attacking_hero(hero, enemy_sprite)

  hero:start_hurt(enemy, 0)
  if game:get_life() == 1 then
    game:set_life(0)
  else
    game:set_life(1)
  end
end

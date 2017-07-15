local enemy = ...
local game = enemy:get_game()

-- Rope: a snake that follows the hero.
-- Sets the hero's life to 1 when hurting him.

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 1,
  damage = 0,
  normal_speed = 40,
  faster_speed = 40,
}

behavior:create(enemy, properties)

enemy:set_life(3)
enemy:set_damage(2)
enemy:set_random_treasures(
  { "rupee", 1 },
  { "bomb", 1 },
  { "rupee", 3 }
)

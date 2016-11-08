local enemy = ...
local game = enemy:get_game()

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 10,
  damage = 10,
  normal_speed = 64,
  faster_speed = 64,
}

behavior:create(enemy, properties)

-- Only sensible to arrows.
enemy:set_invincible()
enemy:set_arrow_reaction(game:get_arrow_force())

enemy:set_random_treasures(
  { "rupee", 3 },
  { "rupee", 3 },
  { "rupee", 3 }
)

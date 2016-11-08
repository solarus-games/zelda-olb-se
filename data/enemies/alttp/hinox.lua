local enemy = ...

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 7,
  damage = 4,
  normal_speed = 64,
  faster_speed = 64,
}

behavior:create(enemy, properties)

enemy:set_random_treasures(
  { "bomb", 1 },
  { "rupee", 3 },
  { "heart", 1 }
)

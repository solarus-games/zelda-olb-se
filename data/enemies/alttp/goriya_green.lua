local enemy = ...

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 10,
  damage = 6,
  normal_speed = 64,
  faster_speed = 64,
}

behavior:create(enemy, properties)

enemy:set_random_treasures(
  { "rupee", 2 },
  { "magic_flask", 1 },
  { "arrow", 2 }
)

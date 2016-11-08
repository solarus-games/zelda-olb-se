local enemy = ...

-- Chasupa: a flying eye that sleeps until the hero gets close.

local behavior = require("enemies/lib/waiting_for_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 2,
  damage = 6,
  normal_speed = 64,
  faster_speed = 64,
  ignore_obstacles = true,
  obstacle_behavior = "flying",
  waking_distance = 220,
}

behavior:create(enemy, properties)

enemy:set_random_treasures(
  { "rupee", 3 },
  { "magic_flask", 1 },
  { "heart", 1 }
)

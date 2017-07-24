-- Tropicallo boss.

local enemy = ...
local map = enemy:get_map()
local hero = map:get_hero()
local sprite

function enemy:on_created()

  enemy:set_life(15)  -- Each skull removes 2 points, the sword removes 1 point.
  enemy:set_damage(1)
  enemy:set_hurt_style("boss")
  enemy:set_pushed_back_when_hurt(false)
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
end

function enemy:on_restarted()

  sol.timer.start(enemy, 100, function()
    local angle = enemy:get_angle(hero)
    local direction4
    if angle > math.pi / 2 and angle <= 3 * math.pi / 2 then
      direction4 = 2
    else
      direction4 = 0
    end
    sprite:set_direction(direction4)
    return true
  end)
end

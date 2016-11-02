local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprite
local movement

function enemy:on_created()

  enemy:set_size(128, 16)
  enemy:set_origin(64, 13)
  enemy:set_life(1)
  enemy:set_damage(1)
  enemy:set_invincible()

  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
end

function enemy:on_restarted()

  movement = sol.movement.create("straight")
  movement:set_angle(3 * math.pi / 2)
  movement:set_speed(64)
  movement:set_smooth(false)

  function movement:on_obstacle_reached()
    movement:set_angle(2 * math.pi - movement:get_angle())
  end

  movement:start(enemy)
end

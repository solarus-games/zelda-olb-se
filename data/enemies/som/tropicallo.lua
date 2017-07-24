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

  -- Look towards the hero.
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

  -- Shoot Zols sometimes.
  sol.timer.start(enemy, 7000, function()

    sprite:set_animation("shooting", function()

      sprite:set_animation("walking")

      local hero_x, hero_y, hero_layer = hero:get_position()
      local enemy_x, enemy_y, enemy_layer = enemy:get_position()
      local fake_zol = map:create_custom_entity({
        direction = 0,
        x = hero_x,
        y = enemy_y - 160,
        width = 16,
        height = 16,
        layer = hero_layer + 1,
        sprite = "enemies/alttp/zol_green",
      })
      local shadow = map:create_custom_entity({
        direction = 0,
        layer = hero_layer,
        x = hero_x,
        y = hero_y,
        width = 16,
        height = 16,
        sprite = "entities/shadow",
      })
      shadow:get_sprite():set_animation("big")

      sol.audio.play_sound("jump")

      local movement = sol.movement.create("target")
      movement:set_target(shadow)
      movement:set_ignore_obstacles(true)
      movement:set_speed(192)
      movement:start(fake_zol, function()

        local x, y = fake_zol:get_position()
        map:create_enemy({
          direction = 0,
          x = x,
          y = y,
          layer = hero_layer,
          breed = "alttp/zol_green",
        })

        fake_zol:remove()
        shadow:remove()
      end)
    end)

    return true
  end)
end

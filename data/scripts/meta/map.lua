-- Initialize map features specific to this quest.

local map_meta = sol.main.get_metatable("map")

function map_meta:move_camera(x, y, speed, callback, delay_before, delay_after)

  local camera = self:get_camera()
  local game = self:get_game()
  local hero = self:get_hero()

  delay_before = delay_before or 1000
  delay_after = delay_after or 1000

  local back_x, back_y = camera:get_position_to_track(hero)
  game:set_suspended(true)
  camera:start_manual()

  local movement = sol.movement.create("target")
  movement:set_target(camera:get_position_to_track(x, y))
  movement:set_ignore_obstacles(true)
  movement:set_speed(speed)
  movement:start(camera, function()
    local timer_1 = sol.timer.start(self, delay_before, function()
      if callback ~= nil then
        callback()
      end
      local timer_2 = sol.timer.start(self, delay_after, function()
        local movement = sol.movement.create("target")
        movement:set_target(back_x, back_y)
        movement:set_ignore_obstacles(true)
        movement:set_speed(speed)
        movement:start(camera, function()
          game:set_suspended(false)
          camera:start_tracking(hero)
          if self.on_camera_back ~= nil then
            self:on_camera_back()
          end
        end)
      end)
      timer_2:set_suspended_with_map(false)
    end)
    timer_1:set_suspended_with_map(false)
  end)
end

function map_meta:open_doors_until_world_changes(door_prefix)

  local map = self
  local game = map:get_game()
  local map_id = map:get_id()

  map:open_doors(door_prefix)
  game.world_persistent_doors = game.world_persistent_doors or {}
  game.world_persistent_doors[map_id] = game.world_persistent_doors[map_id] or {}
  local prefixes = game.world_persistent_doors[map_id]
  prefixes[door_prefix] = true
end

-- Reset world local doors states if the world changes.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("notify_world_changed", function(game, previous_world, new_world)
  game.world_persistent_doors = nil
end)

game_meta:register_event("on_map_changed", function(game, map)

  if game.world_persistent_doors == nil then
    return
  end

  local map_id = map:get_id()
  if game.world_persistent_doors[map_id] == nil then
    return
  end

  for prefix in pairs(game.world_persistent_doors[map_id]) do
    map:set_doors_open(prefix, true)
  end
end)

return true

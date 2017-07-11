local map = ...
local game = map:get_game()

function map:on_started(destination)

  if game:get_value("out_e4_pit_first_dialog") then
    pit:remove()
  end
end

function map:on_opening_transition_finished(destination)

  if destination == from_portal_cave then
    if not game:get_value("out_e4_pit_first_dialog") then
      game:set_value("out_e4_pit_first_dialog", true)
      game:start_dialog("out.e4.pit_hello", function()
        hero:freeze()
        local movement = sol.movement.create("straight")
        movement:set_angle(0)
        movement:set_speed(64)
        movement:set_max_distance(176)
        movement:set_ignore_obstacles(true)
        movement:start(pit, function()
          pit:remove()
          hero:unfreeze()
        end)
      end)
    end
  end
end

function go_pit_house_sensor:on_activated()

  if not game:get_value("pit_house_talked") then
    game:start_dialog("out.e4.go_pit_house", function()
      hero:walk("22")
    end)
  end
end
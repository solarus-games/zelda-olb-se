local map = ...
local game = map:get_game()

local cutscene = require("scripts/maps/cutscene")

local function start_pit_initial_cutscene()

  cutscene.builder(game, map, hero)
  .dialog("out.e4.pit_hello")
  .exec(function()
      hero:freeze()
    end)
  .movement({
    type = "straight",
    entity = pit,
    properties = {
      angle = 0,
      speed = 64,
      max_distance = 176,
      ignore_obstacles = true,
    },
  })
  .exec(function()
      pit:remove()
      hero:unfreeze()
    end)
  .start()

end

function map:on_started(destination)

  if game:get_value("out_e4_pit_first_dialog") then
    pit:remove()
  end
end

function map:on_opening_transition_finished(destination)

  if destination == from_portal_cave then
    if not game:get_value("out_e4_pit_first_dialog") then
      game:set_value("out_e4_pit_first_dialog", true)

      start_pit_initial_cutscene()
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
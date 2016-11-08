local map = ...
local game = map:get_game()

function map:on_opening_transition_finished()

  if not game:get_value("portal_cave_help_done") then
    game:start_dialog("caves.portal_cave.help")
    game:set_value("portal_cave_help_done", true)
  end
end

function auto_separator_1:on_activated()

  if not game:get_value("portal_cave_tutorial_done") then
    local key = game:get_command_keyboard_binding("action")
    game:start_dialog("caves.portal_cave.tutorial", key)
    game:set_value("portal_cave_tutorial_done", true)
  end
end

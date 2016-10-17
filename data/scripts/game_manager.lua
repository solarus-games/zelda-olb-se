-- Script that creates a game ready to be played.

-- Usage:
-- local game_manager = require("scripts/game_manager")
-- local game = game_manager:create("savegame_file_name")
-- game:start()

require("scripts/multi_events")

require("scripts/equipment")
require("scripts/dungeons")
require("scripts/menus/dialog_box")
require("scripts/menus/pause")
require("scripts/menus/game_over")
require("scripts/hud/hud")
require("scripts/rabbit")
require("scripts/chronometer")
require("scripts/walking_speed")

local initial_game = require("scripts/initial_game")

local game_manager = {}

-- Creates a game ready to be played.
function game_manager:create(file)

  -- Create the game (but do not start it).
  local exists = sol.game.exists(file)
  local game = sol.game.load(file)
  if not exists then
    -- This is a new savegame file.
    initial_game:initialize_new_savegame(game)
  end
 
  local previous_world

  -- Function called when the player presses a key during the game.
  game:register_event("on_key_pressed", function(game, key)

    if game.customizing_command then
      -- Don't treat this input normally, it will be recorded as a new command binding
      -- by the commands menu.
      return false
    end

    local handled = false
    if game:is_pause_allowed() then  -- Keys below are menus.
      if key == game:get_value("keyboard_map") then
        -- Map.
        if not game:is_suspended() or game:is_paused() then
          game:switch_pause_menu("map")
          handled = true
        end

      elseif key == game:get_value("keyboard_monsters") then
        -- Monsters.
        if not game:is_suspended() or game:is_paused() then
          if game:has_item("monsters_encyclopedia") then
            game:switch_pause_menu("monsters")
            handled = true
          end
        end

      elseif key == game:get_value("keyboard_commands") then
        -- Commands.
        if not game:is_suspended() or game:is_paused() then
          game:switch_pause_menu("commands")
          handled = true
        end

      elseif key == game:get_value("keyboard_save") then
        if not game:is_paused() and
            not game:is_dialog_enabled() and
            game:get_life() > 0 then
          game:start_dialog("save_quit", function(answer)
            if answer == 2 then
              -- Continue.
              sol.audio.play_sound("danger")
            elseif answer == 3 then
              -- Save and quit.
              sol.audio.play_sound("quit")
              game:save()
              sol.main.reset()
            else
              -- Quit without saving.
              sol.audio.play_sound("quit")
              sol.main.reset()
            end
          end)
          handled = true
        end
      end
    end

    return handled
  end)

  -- Function called when the player presses a joypad button during the game.
  game:register_event("on_joypad_button_pressed", function(game, button)

    if game.customizing_command then
      -- Don't treat this input normally, it will be recorded as a new command binding.
      return false
    end

    local handled = false

    local joypad_action = "button " .. button
    if game:is_pause_allowed() then  -- Keys below are menus.
      if joypad_action == game:get_value("joypad_map") then
        -- Map.
        if not game:is_suspended() or game:is_paused() then
          game:switch_pause_menu("map")
          handled = true
        end

      elseif joypad_action == game:get_value("joypad_monsters") then
        -- Monsters.
        if not game:is_suspended() or game:is_paused() then
          if game:has_item("monsters_encyclopedia") then
            game:switch_pause_menu("monsters")
            handled = true
          end
        end

      elseif joypad_action == game:get_value("joypad_commands") then
        -- Commands.
        if not game:is_suspended() or game:is_paused() then
          game:switch_pause_menu("commands")
          handled = true
        end

      elseif joypad_action == game:get_value("joypad_save") then
        if not game:is_paused() and
            not game:is_dialog_enabled() and
            game:get_life() > 0 then
          game:start_dialog("save_quit", function(answer)
            if answer == 2 then
              -- Continue.
              sol.audio.play_sound("danger")
            elseif answer == 3 then
              -- Save and quit.
              sol.audio.play_sound("quit")
              game:save()
              sol.main.reset()
            else
              -- Quit without saving.
              sol.audio.play_sound("quit")
              sol.main.reset()
            end
          end)
          handled = true
        end
      end
    end

    return handled
  end)

  return game
end

return game_manager


-- Script that creates a pause menu for a game.

-- Usage:
-- require("scripts/menus/pause")

require("scripts/multi_events")

-- Creates a pause menu for the specified game.
local function initialize_pause_features(game)

  if game.pause_menu ~= nil then
    -- Already done.
    return
  end

  local inventory_builder = require("scripts/menus/pause_inventory")
  local map_builder = require("scripts/menus/pause_map")
  local monsters_builder = require("scripts/menus/pause_monsters")
  local commands_builder = require("scripts/menus/pause_commands")

  local pause_menu = {}
  game.pause_menu = pause_menu
  local pause_submenus
  local submenu_index

  local function set_submenu_index(index)

    if pause_submenus[submenu_index] ~= nil then
      sol.menu.stop(pause_submenus[submenu_index])
    end
    submenu_index = index
    game:set_value("pause_last_submenu", index)
    sol.menu.start(pause_menu, pause_submenus[index], false)
  end

  local function get_submenus_order()

    local order = {
      inventory = 1,
      map = 2,
      monsters = 3,
      commands = 4,
    }
    if not game:has_item("monsters_encyclopedia") then
      order.monsters = nil
      order.commands = 3
    end
    return order
  end

  function pause_menu:on_started()

    -- Define the available submenus and their order.
    local submenus_order = get_submenus_order()

    -- Array of submenus (inventory, map, etc.).
    pause_submenus = {}
    pause_submenus[submenus_order.inventory] = inventory_builder:new(game)
    pause_submenus[submenus_order.map] = map_builder:new(game)
    if submenus_order.monsters ~= nil then
      pause_submenus[submenus_order.monsters] = monsters_builder:new(game)
    end
    pause_submenus[submenus_order.commands] = commands_builder:new(game)

    -- Play the sound of pausing the game.
    sol.audio.play_sound("pause_open")

    -- Show the inventory initially.
    set_submenu_index(submenus_order.inventory)
  end

  function pause_menu:on_finished()
    pause_submenus = nil
  end

  function pause_menu:next_submenu()

    sol.audio.play_sound("pause_closed")
    set_submenu_index((submenu_index % #pause_submenus) + 1)
  end

  function pause_menu:previous_submenu()

    sol.audio.play_sound("pause_closed")
    set_submenu_index((submenu_index - 2) % #pause_submenus + 1)
  end

  function pause_menu:switch_submenu(submenu_name)

    local submenus_order = get_submenus_order()
    local index = submenus_order[submenu_name]
    if index == nil then
      return
    end
    if game:is_paused() and submenu_index == index then
      -- Already the active one: close it.
        sol.audio.play_sound("pause_closed")
        game:set_paused(false)
    else
      -- Open the specified submenu.
      if not game:is_paused() then
        game:set_paused(true)
      else
        sol.audio.play_sound("pause_closed")
      end
      if submenu_index ~= index then
        set_submenu_index(index)
      end
    end
  end

  function pause_menu:open()
    sol.menu.start(game, pause_menu)
  end

  function pause_menu:close()
    sol.menu.stop(pause_menu)
  end

  function pause_menu:on_command_pressed(command)

    local handled = false
    if command == "left" then
      pause_menu:previous_submenu()
      handled = true
    elseif command == "right" then
      pause_menu:next_submenu()
      handled = true
    elseif command == "pause" then
      sol.audio.play_sound("pause_closed")
      game:set_paused(false)
      handled = true
    end
    return handled
  end

  -- Pauses the game with the specified pause submenu,
  -- or unpauses the game if this submenu is already active.
  function game:switch_pause_menu(submenu_name)
    pause_menu:switch_submenu(submenu_name)
  end

  game:register_event("on_paused", function(game)
    pause_menu:open()
  end)
  game:register_event("on_unpaused", function(game)
    pause_menu:close()
  end)

end

-- Set up the pause menu on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", initialize_pause_features)

return true

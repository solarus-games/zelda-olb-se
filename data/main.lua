-- Main Lua script of the quest.

require("scripts/features")
local game_manager = require("scripts/game_manager")
local language_menu = require("scripts/menus/language")
local solarus_logo = require("scripts/menus/solarus_logo")
local presentation_screen = require("scripts/menus/presentation_screen")
local title_screen = require("scripts/menus/title_screen")
local savegames_menu = require("scripts/menus/savegames")

function sol.main:on_started()

  math.randomseed(os.time())

  -- Load built-in settings (audio volume, video mode, etc.).
  sol.main.load_settings()

  -- Show the Solarus logo initially.
  sol.menu.start(self, solarus_logo)

  function solarus_logo:on_finished()
    sol.menu.start(sol.main, language_menu)
  end

  function language_menu:on_finished()
    sol.menu.start(sol.main, presentation_screen)
  end

  function presentation_screen:on_finished()
    sol.menu.start(sol.main, title_screen)
  end

  function title_screen:on_finished()
    sol.menu.start(sol.main, savegames_menu)
  end

end

-- Event called when the program stops.
function sol.main:on_finished()

  sol.main.save_settings()
end

-- Event called when the player pressed a keyboard key.
function sol.main:on_key_pressed(key, modifiers)

  local handled = false
  if key == "f11" or
    (key == "return" and (modifiers.alt or modifiers.control)) then
    -- F11 or Ctrl + return or Alt + Return: switch fullscreen.
    sol.video.set_fullscreen(not sol.video.is_fullscreen())
    handled = true
  elseif key == "f4" and modifiers.alt then
    -- Alt + F4: stop the program.
    sol.main.exit()
    handled = true
  elseif key == "escape" and sol.main.game == nil then
    -- Escape in title screens: stop the program.
    sol.main.exit()
    handled = true
  end

  return handled
end

-- Starts a game.
function sol.main:start_savegame(game)

  -- Skip initial menus if any.
  sol.menu.stop(solarus_logo)
  sol.menu.stop(presentation_screen)
  sol.menu.stop(title_screen)
  sol.menu.stop(savegames_menu)

  sol.main.game = game
  game:start()
end

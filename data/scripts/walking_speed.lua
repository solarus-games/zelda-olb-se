-- Manages the walking speed of the hero.
require("scripts/multi_events")

-- Hero constants.
local normal_walking_speed = 96
local fast_walking_speed = 192

-- Changes the walking speed of the hero depending on whether
-- run is pressed or caps lock is active.
local function update_walking_speed(game)

  local hero = game:get_hero()
  local speed = normal_walking_speed
  local modifiers = sol.input.get_key_modifiers()
  local keyboard_run_pressed = sol.input.is_key_pressed(game:get_value("keyboard_run")) or modifiers["caps lock"]
  local joypad_run_pressed = false
  local joypad_action = game:get_value("joypad_run")
  if joypad_action ~= nil then
    local button = joypad_action:match("^button (%d+)$")
    if button ~= nil then
      joypad_run_pressed = sol.input.is_joypad_button_pressed(button)
    end
  end
  if keyboard_run_pressed or
      joypad_run_pressed then
    speed = fast_walking_speed
  end
  if hero:get_walking_speed() ~= speed then
    hero:set_walking_speed(speed)
  end
end

local function game_on_key_pressed_or_released(game, key)

  if game.customizing_command then
    -- Don't treat this input normally, it will be recorded as a new command binding
    -- by the commands menu.
    return false
  end

  if not game:has_item("pegasus_shoes") then
    return false
  end

  local handled = false
  if key == game:get_value("keyboard_run")
      or key == "caps lock" then
    -- Run.
    update_walking_speed(game)
    handled = true
  end

  return handled
end

local function game_on_joypad_button_pressed_or_released(game, button)

  if game.customizing_command then
  -- Don't treat this input normally, it will be recorded as a new command binding
  -- by the commands menu.
    return false
  end

  if not game:has_item("pegasus_shoes") then
    return false
  end

  local handled = false
  local joypad_action = "button " .. button
  if joypad_action == game:get_value("joypad_run") then
    -- Stop running.
    update_walking_speed(game)
    handled = true
  end

  return handled
end


local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", update_walking_speed)
game_meta:register_event("on_key_pressed", game_on_key_pressed_or_released)
game_meta:register_event("on_key_released", game_on_key_pressed_or_released)
game_meta:register_event("on_joypad_button_pressed", game_on_joypad_button_pressed_or_released)
game_meta:register_event("on_joypad_button_released", game_on_joypad_button_pressed_or_released)

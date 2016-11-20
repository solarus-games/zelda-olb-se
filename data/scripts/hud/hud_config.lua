-- Defines the elements to put in the HUD
-- and their position on the game screen.

-- You can edit this file to add, remove or move some elements of the HUD.

-- Each HUD element script must provide a method new(game, config)
-- that creates the element as a menu.
-- See for example scripts/hud/hearts.lua.

-- Negative x or y coordinates mean to measure from the right or bottom
-- of the screen, respectively.

local hud_config = {

  -- Hearts meter.
  {
    menu_script = "scripts/hud/hearts",
    x = -88,
    y = 0,
  },

  -- Rupee counter.
  {
    menu_script = "scripts/hud/rupees",
    x = 121,
    y = 10,
  },

  -- Bomb counter.
  {
    menu_script = "scripts/hud/bombs",
    x = 153,
    y = 10,
  },

  -- Arrow counter.
  {
    menu_script = "scripts/hud/arrows",
    x = 178,
    y = 10,
  },

  -- Item assigned to slot 1.
  {
    menu_script = "scripts/hud/item",
    x = 27,
    y = 15,
    slot = 1,  -- Item slot (1 or 2).
  },

  -- Magic bar.
  {
    menu_script = "scripts/hud/magic_bar",
    x = 10,
    y = 8,
  },

  -- Small key counter.
  {
    menu_script = "scripts/hud/small_keys",
    x = 88,
    y = 10,
  },

  -- Boss life bar.
  {
    menu_script = "scripts/hud/boss_life",
    x = 110,
    y = 220,
  },

  -- Floor.
  {
    menu_script = "scripts/hud/floor",
    x = 280,
    y = 40,
  },

}

return hud_config

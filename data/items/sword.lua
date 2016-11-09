-- 5 variants of the Sword:
-- #1 (Termina Sword): Dungeon 1 (Faron Temple)
-- #2 (Master Sword): Talk to Zelda in Pit's house after getting 5 graals
-- #3 (Master Sword level 1): Dungeon 10 (Din Temple) after boss
-- #4 (Master Sword level 2): Dungeon 11 (Nayru Temple) after boss
-- #5 (Master Sword level 3): Dungeon 12 (Farore Temple) after boss

-- The force is the sword variant, plus 1 when the hero is transformed into Oni-Link
-- (see scripts/meta/hero.lua).

-- When the hero is transformed into Oni-Link, the sprite of the sword changes
-- but not his possessed variant.

local item = ...
local game = item:get_game()

function item:on_created()

  item:set_savegame_variable("possession_sword")
  item:set_sound_when_brandished(nil)
  item:set_sound_when_picked(nil)
  item:set_shadow(nil)
end

function item:on_variant_changed(variant)
  -- The possession state of the sword determines the built-in ability "sword".
  game:set_ability("sword", variant)
end

function item:on_obtaining(variant)

  sol.audio.play_sound("treasure")
end

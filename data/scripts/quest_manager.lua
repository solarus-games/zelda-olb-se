-- This script handles global behavior of this quest,
-- that is, things not related to a particular savegame.
local quest_manager = {}

require("scripts/meta/map")
require("scripts/meta/dynamic_tile")
require("scripts/meta/enemy")
require("scripts/meta/hero")
require("scripts/meta/npc")
require("scripts/meta/sensor")

-- Returns the id of the font and size to use for the dialog box
-- depending on the current language.
function quest_manager:get_dialog_font()

  -- This quest uses the "alttp" bitmap font (and therefore no size)
  -- no matter the current language.
  return "alttp", nil
end

-- Returns the id of the font and size to use in menus
-- depending on the current language.
function quest_manager:get_menu_font()

  -- This quest uses the "alttp" bitmap font (and therefore no size)
  -- no matter the current language.
  return "alttp", nil
end

return quest_manager

local map = ...
local game = map:get_game()

function map:on_started()

  if game:has_item("pegasus_shoes") then
    pegasus_shoes_chest:set_enabled(false)
  end
end

local map = ...
local game = map:get_game()

function map:on_started()

  if game:has_item("bombs_counter") then
    final_npc:remove()
  end
end

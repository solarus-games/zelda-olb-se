local map = ...
local game = map:get_game()

function map:on_started(destination)

  if game:get_value("d2_b1_prison_npc_key_1") then
    prison_npc_1:remove()
  end
  if game:get_value("d2_b1_prison_npc_key_2") then
    prison_npc_2:remove()
  end
  if game:get_value("d2_b1_prison_npc_key_3") then
    prison_npc_3:remove()
  end
end

-- Initialize NPC behavior specific to this quest.

local npc_meta = sol.main.get_metatable("npc")

-- Make signs hooks for the hookshot.
function npc_meta:is_hookable()

  local sprite = self:get_sprite()
  if sprite == nil then
    return false
  end

  return sprite:get_animation_set() == "entities/sign"
end

return true

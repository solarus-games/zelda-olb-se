-- Sets the ground below it to "low_wall".
-- Useful if tiles don't have the appropriate ground.

local entity = ...

function entity:on_created()
  entity:set_modified_ground("low_wall")
end

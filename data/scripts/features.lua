-- Sets up all non built-in gameplay features specific to this quest.

-- Usage: require("scripts/features")

-- Features can be enabled to disabled independently by commenting
-- or uncommenting lines below.

require("scripts/debug")
require("scripts/equipment")
require("scripts/dungeons")
require("scripts/maps/door_manager.lua")
require("scripts/maps/separator_manager.lua")
require("scripts/menus/alttp_dialog_box")
require("scripts/menus/pause")
require("scripts/menus/game_over")
require("scripts/hud/hud")
require("scripts/onilink")
require("scripts/rabbit")
require("scripts/chronometer")
require("scripts/walking_speed")
require("scripts/meta/map")
require("scripts/meta/camera")
require("scripts/meta/dynamic_tile")
require("scripts/meta/enemy")
require("scripts/meta/hero")
require("scripts/meta/npc")
require("scripts/meta/sensor")

return true

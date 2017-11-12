-- Defines the dungeon information of a game.

-- Usage:
-- require("scripts/dungeons")

require("scripts/multi_events")

local function initialize_dungeon_features(game)

  if game.get_dungeon ~= nil then
    -- Already done.
    return
  end

  -- Define the existing dungeons and their floors for the minimap menu.
  local dungeons_info = {
    [1] = {
      lowest_floor = -1,
      highest_floor = 0,
      boss = {
        floor = 0,
        x = 640 + 1440,
        y = 720 + 365,
        savegame_variable = "d1_boss",
      },
    },
    [2] = {
      lowest_floor = -2,
      highest_floor = 0,
      boss = {
        floor = -2,  -- TODO
        x = 640 + 800,
        y = 240 + 1312,
        savegame_variable = "d2_boss",
      },
    },
    [3] = {
      lowest_floor = -1,
      highest_floor = 1,
      boss = {
        floor = 1,
        x = 320 + 1120,
        y = 240 + 557,
        savegame_variable = "d3_boss",
      },
    },
    [4] = {
      lowest_floor = -1,
      highest_floor = 2,
      boss = {
        floor = -1,
        x = 640 + 800,
        y = 480 + 360,
        savegame_variable = "d4_boss",
      },
    },
    [5] = {
      lowest_floor = -1,
      highest_floor = 0,
      boss = {
        floor = 0,
        x = 640 + 1280,
        y = 480 + 480,
        savegame_variable = "d5_boss",
      },
    },
    [6] = {
      lowest_floor = -1,
      highest_floor = 1,
      boss = {
        floor = 0,
        x = 320 + 160,
        y = 480 + 360,
        savegame_variable = "d6_boss",
      },
    },
    [7] = {
      lowest_floor = -2,
      highest_floor = 0,
      boss = {
        floor = -2,
        x = 640 + 800,
        y = 720 + 360,
        savegame_variable = "d7_boss",
      },
    },
    [8] = {
      lowest_floor = -1,
      highest_floor = 1,
      boss = {
        floor = 0,
        x = 960 + 160,
        y = 480 + 360,
        savegame_variable = "d8_boss",
      },
    },
    [10] = {
      lowest_floor = -2,
      highest_floor = 2,
      boss = {
        floor = 0,
        x = 640 + 800,
        y = 480 + 600,
        savegame_variable = "d10_boss",
      },
    },
    [11] = {
      lowest_floor = -1,
      highest_floor = 0,
      boss = {
        floor = 0,
        x = 640 + 800,
        y = 480 + 360,
        savegame_variable = "d11_boss",
      },
    },
    [12] = {
      lowest_floor = -2,
      highest_floor = 2,
      -- No boss on the minimap (the boss is on the roof).
    },
    [13] = {
      lowest_floor = -2,
      highest_floor = 0,
      -- No boss on the minimap (the floor is not on the map).
    },
    [14] = {
      lowest_floor = 0,
      highest_floor = 0,
      boss = {
        floor = 0,
        x = 320 + 480,
        y = 0 + 840,
        savegame_variable = "d14_boss",
      },
    },
    [15] = {
      lowest_floor = 0,
      highest_floor = 2,
      -- No boss on the minimap (the boss is on the roof).
    },
  }

  -- Returns the index of the current dungeon if any, or nil.
  function game:get_dungeon_index()

    local world = game:get_map():get_world()
    if world == nil then
      return nil
    end
    local index = tonumber(world:match("^dungeon_([0-9]+)$"))
    return index
  end

  -- Returns the current dungeon if any, or nil.
  function game:get_dungeon()

    local index = game:get_dungeon_index()
    return dungeons_info[index]
  end

  function game:is_dungeon_finished(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    return game:get_value("dungeon_" .. dungeon_index .. "_finished")
  end

  function game:set_dungeon_finished(dungeon_index, finished)
    if finished == nil then
      finished = true
    end
    dungeon_index = dungeon_index or game:get_dungeon_index()
    game:set_value("dungeon_" .. dungeon_index .. "_finished", finished)
  end

  function game:has_dungeon_map(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    return game:get_value("dungeon_" .. dungeon_index .. "_map")
  end

  function game:has_dungeon_compass(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    return game:get_value("dungeon_" .. dungeon_index .. "_compass")
  end

  function game:has_dungeon_boss_key(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    return game:get_value("dungeon_" .. dungeon_index .. "_boss_key")
  end

  function game:get_dungeon_name(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    return sol.language.get_string("dungeon_" .. dungeon_index .. ".name")
  end

  function game:get_dungeon_map_ids(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    local map_ids = {}
    local dungeon = game:get_dungeon(dungeon_index)
    assert(dungeon ~= nil)
    for floor = dungeon.lowest_floor, dungeon.highest_floor do
      map_ids[#map_ids + 1] = "dungeons/" .. dungeon_index .. "/" .. game:get_floor_name(floor)
    end
    return map_ids
  end

  function game:get_dungeon_lowest_floor(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    local dungeon = game:get_dungeon(dungeon_index)
    assert(dungeon ~= nil)
    return dungeon.lowest_floor
  end

  function game:get_dungeon_highest_floor(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    local dungeon = game:get_dungeon(dungeon_index)
    assert(dungeon ~= nil)
    return dungeon.highest_floor
  end

  function game:get_dungeon_room_size(dungeon_index)
    return 320, 240
  end

  local function compute_merged_rooms(game, dungeon_index, floor)

    assert(game ~= nil)
    assert(dungeon_index ~= nil)
    assert(floor ~= nil)

    local map = game:get_map()
    local map_width, map_height = map:get_size()
    local room_width, room_height = game:get_dungeon_room_size(dungeon_index)
    local num_columns = math.floor(map_width / room_width)
    -- TODO limitation: assumes that all maps of the dungeon have the same size

    -- Use the minimap sprite to deduce merged rooms.
    local sprite = sol.sprite.create("menus/dungeon_maps/map_" .. dungeon_index)
    local animation = tostring(floor)
    local merged_rooms = {}

    if not sprite:has_animation(animation) then
      -- Missing sprite or animation: avoid repeated errors.
      return merged_rooms
    end

    for room = 1, sprite:get_num_directions(animation) - 1 do
      local width, height = sprite:get_size(floor, room)
      local room_rows, room_columns = height / 16, width / 16  -- TODO don't hardcode these numbers
      local current_room = room

      if room_rows ~= 1 or room_columns ~= 1 then

        for i = 1, room_rows do
          for j = 1, room_columns do
            if current_room ~= room then
              merged_rooms[current_room] = room
            end
            current_room = current_room + 1
          end
          current_room = current_room + num_columns - room_columns
        end
      end
    end
    return merged_rooms
  end

  -- Returns the name of the boolean variable that stores the exploration
  -- of a dungeon room, or nil.
  -- If dungeon_index and floor are nil, the current dungeon and current floor are used.
  function game:get_explored_dungeon_room_variable(dungeon_index, floor, room)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    room = room or 1
    if floor == nil then
      if game:get_map() ~= nil then
        floor = game:get_map():get_floor()
      else
        floor = 0
      end
    end

    local dungeon = game:get_dungeon(dungeon_index)

    -- If it is a merged room, get the upper-left part.
    -- Lazily compute merged rooms for this floor.
    dungeon.merged_rooms = dungeon.merged_rooms or {}
    dungeon.merged_rooms[floor] = dungeon.merged_rooms[floor] or compute_merged_rooms(game, dungeon_index, floor)
    room = dungeon.merged_rooms[floor][room] or room

    local floor_name = game:get_floor_name(floor)
    local room_name = floor_name .. "_" .. room

    return "d" .. dungeon_index .. "_explored_" .. room_name
  end

  -- Returns whether a dungeon room has been explored.
  -- If dungeon_index and floor are nil, the current dungeon and current floor are used.
  function game:has_explored_dungeon_room(dungeon_index, floor, room)

    return self:get_value(
      self:get_explored_dungeon_room_variable(dungeon_index, floor, room)
    )
  end

  -- Changes the exploration state of a dungeon room.
  -- If dungeon_index and floor are nil, the current dungeon and current floor are used.
  -- explored is true by default.
  function game:set_explored_dungeon_room(dungeon_index, floor, room, explored)

    if explored == nil then
      explored = true
    end

    self:set_value(
      self:get_explored_dungeon_room_variable(dungeon_index, floor, room),
      explored
    )
  end

  function game:get_floor_name(floor)

    local map = game:get_map()
    floor = floor or tonumber(map:get_floor())
    if floor == nil then
      return nil
    end

    if floor >= 0 then
      return (floor + 1) .. "f"
    else
      return "b" .. (-floor)
    end
  end

  -- Show the dungeon name when entering a dungeon.
  game:register_event("notify_world_changed", function()
    local dungeon_index = game:get_dungeon_index()
    if dungeon_index ~= nil then
      local map = game:get_map()
      local timer = sol.timer.start(map, 10, function()
        game:start_dialog("dungeons." .. dungeon_index .. ".welcome")
      end)
      timer:set_suspended_with_map(true)
    end
  end)

end

-- Set up dungeon features on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", initialize_dungeon_features)

return true

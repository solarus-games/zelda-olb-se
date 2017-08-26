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
      maps = { "dungeons/1/b1", "dungeons/1/1f" },
      boss = {
        floor = 0,
        x = 640 + 1440,
        y = 720 + 365,
        savegame_variable = "dungeon_1_boss",
      },
    },
    [2] = {
      lowest_floor = -2,
      highest_floor = 0,
      maps = { "dungeons/2/b2", "dungeons/2/b1", "dungeons/2/1f" },
      boss = {
        floor = -2,  -- TODO
        x = 0,
        y = 0,
        savegame_variable = "dungeon_2_boss",
      },
    },
    [3] = {
      lowest_floor = -1,
      highest_floor = 1,
      maps = { "dungeons/3/b1", "dungeons/3/1f", "dungeons/3/2f" },
      boss = {
        floor = 1,
        x = 320 + 1120,
        y = 240 + 557,
        savegame_variable = "dungeon_3_boss",
      },
    },
    [4] = {
      lowest_floor = -1,
      highest_floor = 2,
      maps = { "dungeons/4/b1", "dungeons/4/1f", "dungeons/4/2f", "dungeons/4/3f" },
      boss = {
        floor = -1,
        x = 640 + 800,
        y = 640 + 360,
        savegame_variable = "dungeon_4_boss",
      },
    },
    [5] = {
      lowest_floor = -1,
      highest_floor = 0,
      maps = { "dungeons/5/b1", "dungeons/5/1f" },
      boss = {
        floor = 0,
        x = 640 + 1280,
        y = 640 + 480,
        savegame_variable = "dungeon_5_boss",
      },
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

  -- Returns the name of the boolean variable that stores the exploration
  -- of a dungeon room, or nil.
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

    local room_name
    if floor >= 0 then
      room_name = tostring(floor + 1) .. "f_" .. room
    else
      room_name = math.abs(floor) .. "b_" .. room
    end

    return "dungeon_" .. dungeon_index .. "_explored_" .. room_name
  end

  -- Returns whether a dungeon room has been explored.
  function game:has_explored_dungeon_room(dungeon_index, floor, room)

    return self:get_value(
      self:get_explored_dungeon_room_variable(dungeon_index, floor, room)
    )
  end

  -- Changes the exploration state of a dungeon room.
  function game:set_explored_dungeon_room(dungeon_index, floor, room, explored)

    if explored == nil then
      explored = true
    end

    self:set_value(
      self:get_explored_dungeon_room_variable(dungeon_index, floor, room),
      explored
    )
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

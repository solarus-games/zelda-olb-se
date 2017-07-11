-- Converts C++ code fragments from ROTH/OLB/3T to Solarus entities.

-- This script is useful to reproduce entities that are not in map data files
-- but only specified in the C++ code in the original game.
-- This is the case of enemies and treasures, destructible objects
-- chests and blocks for example.

-- This script currently handles the following types of entities:
-- - Enemies
-- - Destructibles

-- TODO:
-- - check enemy offsets
-- - add support of destructibles other than vases
-- - add support of chests and blocks
-- - test outside maps

-- The input code is read from stdin and should contain some
-- ajouteEnnemi/ajouteObjet lines from Monde.cpp of the original game.
-- You are supposed to only provide the ones from the map you are interested in.

-- The output is written to stdout. It can be directly pasted to a map
-- open in Solarus Quest Editor.

local src = io.read("*a")

local enemy_breeds = {
  ["3"] = "alttp/tektite_blue",
  ["4"] = "alttp/popo",
  ["8"] = "alttp/pikku",
  ["18"] = "alttp/keese",
  -- TODO
}

local breeds_on_high_layer = {
  ["alttp/keese"] = true,
  -- TODO
}

local treasures = {

  ["1"] = {
    treasure_name = "rupee",
    treasure_variant = 1,
  },
  ["4"] = {
    treasure_name = "heart",
    treasure_variant = 1,
    offset_x = 0,
    offset_y = 4,
  },
  -- TODO
}

-- Converts an enemy number from ROTH/OLB/3T to an enemy breed for a
-- Solarus quest.
local function enemy_id_to_breed(enemy_id)

  assert(enemy_id ~= nil)
  local breed = enemy_breeds[enemy_id]
  assert(breed ~= nil)
  return breed
end

local function get_enemy_layer(breed)

  if breeds_on_high_layer[breed] then
    return 2
  end
  return 0
end

local function evaluate_math(expression)
  
  local code = loadstring("return " .. expression)
  return code()
end

-- Returns a table of enemy descriptions with their properties.
local function parse_enemies(src)
  local enemies = {}
  for enemy_id, x, y in src:gmatch("ajouteEnnemi%(([0-9]*), *([-+*0-9]*), *([-+*0-9]*)%)") do
    local enemy = {}
    enemy.name = "auto_enemy_" .. (#enemies + 1)
    enemy.x = evaluate_math(x)
    enemy.y = evaluate_math(y)
    enemy.layer = get_enemy_layer(enemy.breed)
    enemy.direction = 3
    enemy.breed = enemy_id_to_breed(enemy_id)
    enemies[#enemies + 1] = enemy
  end
  return enemies
end

-- Write enemies in Solarus format.
local function write_enemies(enemies)

  for _, entity in ipairs(enemies) do
    io.write("enemy{\n")
    io.write("  name = \"" .. entity.name .. "\",\n")
    io.write("  layer = " .. entity.layer .. ",\n")
    io.write("  x = " .. entity.x .. ",\n")
    io.write("  y = " .. entity.y .. ",\n")
    io.write("  direction = " .. entity.direction .. ",\n")
    io.write("  breed = \"" .. entity.breed .. "\",\n")
    io.write("}\n")
    io.write("\n")
  end
end

-- Converts an item type from ROTH/OLB/3T to a treasure name and variant for a
-- Solarus quest.
local function pickable_id_to_treasure(pickable_id)

  assert(pickable_id ~= nil)
  local treasure = treasures[pickable_id]
  assert(treasure ~= nil)
  return treasure
end

-- Converts textual coordinate expressions to Solarus coordinates for a destructible object.
local function get_destructible_coords(src_x, src_y, treasure)

  local x, y = evaluate_math(src_x), evaluate_math(src_y)
  x, y = x + 8, y + 13  -- Add Solarus origin point.
  local offset_x, offset_y = treasure.offset_x or 0, treasure.offset_y or 0
  x, y = x + offset_x, y + offset_y  -- Add item-dependent offset.
  return x, y
end

-- Returns a table of destructible descriptions with their properties.
local function parse_destructibles(src)
  local entities = {}
  for pickable_id, x, y in src:gmatch("ajouteObjet%(([0-9]*), *([-+*0-9]*), *([-+*0-9]*),") do
    local entity = {}
    local treasure = pickable_id_to_treasure(pickable_id)
    entity.name = "auto_destructible_" .. (#entities + 1)
    entity.x, entity.y = get_destructible_coords(x, y, treasure)
    entity.layer = 0
    entity.sprite = "entities/vase"
    entity.destruction_sound = "stone"
    entity.damage_on_enemies = 0
    entity.treasure_name, entity.treasure_variant = treasure.treasure_name, treasure.treasure_variant
    entities[#entities + 1] = entity
  end
  return entities
end

-- Write desctructibles in Solarus format.
local function write_destructibles(destructibles)

  for _, entity in ipairs(destructibles) do
    io.write("destructible{\n")
    io.write("  name = \"" .. entity.name .. "\",\n")
    io.write("  layer = " .. entity.layer .. ",\n")
    io.write("  x = " .. entity.x .. ",\n")
    io.write("  y = " .. entity.y .. ",\n")
    io.write("  sprite = \"" .. entity.sprite .. "\",\n")
    io.write("  destruction_sound = \"" .. entity.destruction_sound .. "\",\n")
    io.write("  damage_on_enemies = " .. entity.damage_on_enemies .. ",\n")
    io.write("  treasure_name = \"" .. entity.treasure_name .. "\",\n")
    if entity.treasure_variant ~= nil and entity.treasure_variant ~= 1 then
      io.write("  treasure_variant = " .. entity.treasure_variant .. ",\n")
    end
    io.write("}\n")
    io.write("\n")
  end
end


local enemies = parse_enemies(src)
write_enemies(enemies)

local destructibles = parse_destructibles(src)
write_destructibles(destructibles)


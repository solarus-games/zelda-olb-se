-- Converts C++ code fragments from ROTH/OLB/3T to Solarus entities.

-- This script is useful to reproduce entities that are not in map data files
-- but only specified in the C++ code in the original game.
-- This is the case of enemies and treasures, destructible objects
-- chests and blocks for example.

-- This script currently handles the following types of entities:
-- - Enemies
-- - Destructibles
-- - Blocks

-- TODO:
-- - check offsets of enemies
-- - add support of enemy treasures
-- - add support of destructibles other than vases
-- - add support of pickables without destructibles
-- - test outside maps

-- The input code is read from stdin and should contain some
-- ajouteEnnemi/ajouteObjet lines from Monde.cpp of the original game.
-- You are supposed to only provide the ones from the map you are interested in.

-- The output is written to stdout. It can be directly pasted to a map
-- open in Solarus Quest Editor.

local enemy_breeds = {
  ["1"] = "alttp/stalfos_blue",
  ["2"] = "alttp/zazak_blue",
  ["3"] = "alttp/tektite_blue",
  ["4"] = "alttp/popo",
  ["5"] = "alttp/moblin",
  ["6"] = "alttp/armos",
  ["7"] = "alttp/rope",
  ["8"] = "alttp/pikku",
  ["9"] = "alttp/zora_feet",
  ["10"] = "alttp/zora_water",
  ["11"] = "alttp/stal",
  ["12"] = "alttp/poe",
  ["13"] = "alttp/vulture",
  ["14"] = "alttp/geldman",
  ["15"] = "alttp/lynel",
  ["16"] = "alttp/wizzrobe_blue",
  ["17"] = "alttp/pike_auto",
  ["18"] = "alttp/keese",
  ["19"] = "alttp/mothula",
  -- 20: crystal
  ["21"] = "alttp/hover",
  ["22"] = "alttp/bari_blue",
  ["23"] = "alttp/sand_crab",
  ["24"] = "alttp/arrghus",
  ["25"] = "alttp/hinox",
  ["26"] = "alttp/chasupa",
  ["27"] = "alttp/octorok",
  ["28"] = "alttp/armos_knight",
  ["29"] = "alttp/gibdo",
  ["30"] = "alttp/wizzrobe_white",
  ["31"] = "alttp/agahnim",
  ["32"] = "alttp/ropa",
  ["33"] = "alttp/goriya_green",
  ["34"] = "alttp/eyegore_green",
  ["35"] = "alttp/vitreous",
  ["36"] = "alttp/medusa",
  ["37"] = "alttp/stalfos_red",
  ["38"] = "alttp/goriya_red",
  ["39"] = "alttp/eyegore_red",
  ["40"] = "alttp/blind",
  ["41"] = "alttp/pengator",
  ["42"] = "alttp/freezor",
  ["43"] = "alttp/kholdstare",
  ["44"] = "alttp/tarosu_red",
  ["45"] = "alttp/helmasaur_king",
  ["46"] = "alttp/sword_soldier_green",
  ["47"] = "alttp/sword_soldier_blue",
  ["48"] = "alttp/sword_soldier_red",
  ["49"] = "alttp/medusa_purple",
  ["50"] = "alttp/ganon",
  ["51"] = "alttp/wallmaster",
  ["52"] = "alttp/chicken",
  ["53"] = "alttp/zol_green",
  ["54"] = "alttp/crow",
  ["55"] = "alttp/tarosu_blue",
  ["56"] = "alttp/hyu",
  ["57"] = "som/tropicallo",
  ["58"] = "alttp/zol_green",
  ["59"] = "som/brambler",
  ["60"] = "som/kilroy",
  ["61"] = "alttp/rolling_spike_trap",
  ["62"] = "alttp/stalfos_knight",
  ["63"] = "som/vampire",
  ["64"] = "som/ghoul",
  ["65"] = "alttp/medusa_blue",
  ["66"] = "soe/aquagoth",
  -- 70: moving walls
  ["71"] = "som/minotaur",
  ["72"] = "alttp/stalfos_grey",
  ["73"] = "som/dragon_red",
  ["74"] = "som/dragon_snow",
  ["75"] = "alttp/onilink",
  ["76"] = "som/spikey_tiger",
}

local breeds_on_high_layer = {
  ["alttp/crow"] = true,
  ["alttp/keese"] = true,
  ["alttp/vulture"] = true,
}

local pickable_id_to_treasure_map = {  -- enum Type_Items

  ["1"] = {
    treasure_name = "rupee",
    treasure_variant = 1,
  },
  ["2"] = {
    treasure_name = "rupee",
    treasure_variant = 2,
  },
  ["3"] = {
    treasure_name = "rupee",
    treasure_variant = 3,
  },
  ["4"] = {
    treasure_name = "heart",
    offset_x = 0,
    offset_y = 4,
  },
  ["5"] = {
    treasure_name = "arrow",
  },
  ["6"] = {
    treasure_name = "bomb",
  },
  ["7"] = {
    treasure_name = "magic_flask",
    treasure_variant = 1,
    offset_x = 0,
    offset_y = 4,
  },
  ["8"] = {
    treasure_name = "magic_flask",
    treasure_variant = 2,
  },
  ["11"] = {
    treasure_name = "graal",
    treasure_variant = 1,
  },
  -- TODO
}

local chest_content_id_to_treasure_map = {  -- enum Type_Contenu

  ["CARTE"] = {
    treasure_name = "map",
    treasure_variant = 1,
  },
  ["BOUSSOLE"] = {
    treasure_name = "compass",
    treasure_variant = 1,
  },
  ["CLE_BOSS"] = {
    treasure_name = "boss_key",
    treasure_variant = 1,
  },
  ["CLE"] = {
    treasure_name = "small_key",
    treasure_variant = 1,
  },
  ["TUNIQUE_BLEUE"] = {
    treasure_name = "tunic",
    treasure_variant = 2,
  },
  ["TUNIQUE_ROUGE"] = {
    treasure_name = "tunic",
    treasure_variant = 3,
  },
  ["BFEU"] = {
    treasure_name = "fire_rod",
    treasure_variant = 1,
  },
  ["BGLACE"] = {
    treasure_name = "ice_rod",
    treasure_variant = 1,
  },
  ["BOUCLIER_J"] = {
    treasure_name = "shield",
    treasure_variant = 3,
  },
  ["BOTTES"] = {
    treasure_name = "pegasus_shoes",
    treasure_variant = 1,
  },
  ["ARC_FEE"] = {
    treasure_name = "bow",
    treasure_variant = 2,
  },
  -- TODO
}

local src = io.read("*a")

-- Converts an enemy number from ROTH/OLB/3T to an enemy breed for a
-- Solarus quest.
local function enemy_id_to_breed(enemy_id)

  assert(enemy_id ~= nil)

  if enemy_id == "20" or  -- Crystal.
      enemy_id == "70" then  -- Moving walls.
    -- Not a Solarus enemy.
    return nil
  end

  local breed = enemy_breeds[enemy_id]
  assert(breed ~= nil, "Unknown enemy id: " .. enemy_id)
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

-- Converts textual coordinate expressions to Solarus coordinates for an enemy.
local function get_enemy_coords(src_x, src_y, breed)

  local x, y = evaluate_math(src_x), evaluate_math(src_y)
  x, y = x + 8, y + 13  -- Add Solarus origin point.
  return x, y
end

-- Returns a table of enemy descriptions with their properties.
local function parse_enemies(src)
  local entities = {}
  for enemy_id, x, y in src:gmatch("ajouteEnnemi%(([0-9]*), *([-+*0-9]*), *([-+*0-9]*)%)") do
    local entity = {}
    entity.name = "auto_enemy_" .. (#entities + 1)
    entity.direction = 3
    entity.breed = enemy_id_to_breed(enemy_id)
    if entity.breed ~= nil then
      entity.x, entity.y = get_enemy_coords(x, y, entity.breed)
      entity.layer = get_enemy_layer(entity.breed)
      entities[#entities + 1] = entity
    end
  end
  for enemy_id, x, y in src:gmatch("ajoutePiege%(([0-9]*), *([-+*0-9]*), *([-+*0-9]*)%)") do
    local entity = {}
    entity.name = "auto_enemy_" .. (#entities + 1)
    entity.direction = 3
    entity.breed = enemy_id_to_breed(enemy_id)
    entity.x, entity.y = get_enemy_coords(x, y, entity.breed)
    entity.layer = get_enemy_layer(entity.breed)
    entities[#entities + 1] = entity
  end
  return entities
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
  local treasure = pickable_id_to_treasure_map[pickable_id]
  assert(treasure ~= nil, "Unknown item id: " .. pickable_id)
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
    -- TODO
    -- entity.sprite = "entities/vase"
    entity.sprite = "entities/vase_skull"
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

-- Converts textual coordinate expressions to Solarus coordinates for a block.
local function get_block_coords(src_x, src_y)

  local x, y = evaluate_math(src_x), evaluate_math(src_y)
  x, y = x + 8, y + 13  -- Add Solarus origin point.
  return x, y
end

-- Returns a table of blocks descriptions with their properties.
local function parse_blocks(src)
  local entities = {}
  for x, y in src:gmatch("ajouteCaisse%([0-9]*, *([-+*0-9]*), *([-+*0-9]*)%)") do
    local entity = {}
    entity.name = "auto_block_" .. (#entities + 1)
    entity.x, entity.y = get_block_coords(x, y)
    entity.layer = 0
    entities[#entities + 1] = entity
  end
  return entities
end

-- Write blocks in Solarus format.
local function write_blocks(blocks)

  for _, entity in ipairs(blocks) do
    io.write("block{\n")
    io.write("  name = \"" .. entity.name .. "\",\n")
    io.write("  layer = " .. entity.layer .. ",\n")
    io.write("  x = " .. entity.x .. ",\n")
    io.write("  y = " .. entity.y .. ",\n")
    io.write("  sprite = \"entities/block\",\n")
    io.write("  pushable = true,\n")
    io.write("  pullable = false,\n")
    io.write("  maximum_moves = 2,\n")
    io.write("}\n")
    io.write("\n")
  end
end

-- Converts textual coordinate expressions to Solarus coordinates for a crystal.
local function get_crystal_coords(src_x, src_y)

  local x, y = evaluate_math(src_x), evaluate_math(src_y)
  x, y = x + 8, y + 13  -- Add Solarus origin point.
  return x, y
end

-- Returns a table of crystals descriptions with their properties.
local function parse_crystals(src)
  local entities = {}
  for x, y in src:gmatch("ajouteEnnemi%(20, *([-+*0-9]*), *([-+*0-9]*)%)") do
    local entity = {}
    entity.x, entity.y = get_crystal_coords(x, y)
    entity.layer = 0
    entities[#entities + 1] = entity
  end
  return entities
end

-- Write crystals in Solarus format.
local function write_crystals(crystals)

  for _, entity in ipairs(crystals) do
    io.write("crystal{\n")
    io.write("  layer = " .. entity.layer .. ",\n")
    io.write("  x = " .. entity.x .. ",\n")
    io.write("  y = " .. entity.y .. ",\n")
    io.write("  sprite = \"entities/crystal\",\n")
    io.write("}\n")
    io.write("\n")
  end
end

-- Converts a chest content name from ROTH/OLB/3T to a treasure name and variant for a
-- Solarus quest.
local function chest_content_id_to_treasure(chest_content_id)

  assert(chest_content_id ~= nil)
  local treasure = chest_content_id_to_treasure_map[chest_content_id]
  assert(treasure ~= nil, "Unknown chest content id: " .. chest_content_id)
  return treasure
end

-- Converts textual coordinate expressions to Solarus coordinates for a chest.
local function get_chest_coords(src_x, src_y)

  local x, y = evaluate_math(src_x), evaluate_math(src_y)
  x, y = x + 8, y + 13  -- Add Solarus origin point.
  return x, y
end

-- Returns a table of chests descriptions with their properties.
local function parse_chests(src)
  local entities = {}
  for x, y, chest_content_id in src:gmatch("setValeur%( *([-+*0-9]*), *([-+*0-9]*), *303, *-1, *PLEIN, *C_([A-Za-Z_]*)%)") do
    local entity = {}
    local treasure = chest_content_id_to_treasure(chest_content_id)
    entity.x, entity.y = get_chest_coords(x, y)
    entity.layer = 0
    entity.treasure_name, entity.treasure_variant = treasure.treasure_name, treasure.treasure_variant
    entities[#entities + 1] = entity
  end
  return entities
end

-- Write chests in Solarus format.
local function write_chests(chests)

  for _, entity in ipairs(chests) do
    io.write("chest{\n")
    io.write("  layer = " .. entity.layer .. ",\n")
    io.write("  x = " .. entity.x .. ",\n")
    io.write("  y = " .. entity.y .. ",\n")
    io.write("  sprite = \"entities/chest\",\n")
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

local blocks = parse_blocks(src)
write_blocks(blocks)

local crystals = parse_crystals(src)
write_crystals(crystals)

local chests = parse_chests(src)
write_chests(chests)


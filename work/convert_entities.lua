-- Converts C++ code from OLB to Solarus entities.

local src = io.read("*a")

local enemy_breeds = {
  ["3"] = "alttp/tektite_blue",
  ["8"] = "alttp/pikku",
  ["18"] = "alttp/keese",
  -- TODO
}

local breeds_on_high_layer = {
  ["alttp/keese"] = true,
  -- TODO
}

-- Converts an enemy number from OLB to an enemy breed for OLB SE.
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
  for enemy_id, x, y in src:gmatch("ajouteEnnemi%(([0-9]*), *([0-9+*]*), *([0-9+*]*)") do
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

  for _, enemy in ipairs(enemies) do
    io.write("enemy{\n")
    io.write("  name = \"" .. enemy.name .. "\",\n")
    io.write("  layer = " .. enemy.layer .. ",\n")
    io.write("  x = " .. enemy.x .. ",\n")
    io.write("  y = " .. enemy.y .. ",\n")
    io.write("  direction = " .. enemy.direction .. ",\n")
    io.write("  breed = \"" .. enemy.breed .. "\",\n")
    io.write("}\n")
    io.write("\n")
  end
end

local enemies = parse_enemies(src)
write_enemies(enemies)

local destructibles = parse_destructibles(src)
write_destructibles(destructibles)


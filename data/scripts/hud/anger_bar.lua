-- The anger bar of the hero.

local anger_bar_builder = {}

local anger_bar_img = sol.surface.create("hud/anger_bar.png")

function anger_bar_builder:new(game, config)

  local anger_bar = {}

  local dst_x, dst_y = config.x, config.y

  function anger_bar:on_draw(dst_surface)

    if game:has_all_graals() then
      -- The hero is cured.
      return
    end

    local current_anger = game:get_anger()
    local max_anger = game:get_max_anger()

    anger_bar_img:draw_region(0, 0, 10, 42, dst_surface, dst_x, dst_y)
    local src_width = 2
    local src_height = math.floor(current_anger / max_anger * 32)
    local src_x, src_y = 14, 5
    anger_bar_img:draw_region(src_x, src_y, src_width, src_height, dst_surface, dst_x + 4, dst_y + 37 - src_height)
  end

  return anger_bar
end

return anger_bar_builder


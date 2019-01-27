local anim8 = require("anim8")

function loadAnimations()
  walk_img = love.graphics.newImage("assets/gfx/walking.png")
  local walk_grid = anim8.newGrid(player.width, player.height, walk_img:getWidth(), walk_img:getHeight())
  walk_anim_r = anim8.newAnimation(walk_grid("1-3", 1, "2-2", 1), 0.2)
  walk_anim_l = walk_anim_r:clone():flipH()
end
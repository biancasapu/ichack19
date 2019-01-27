local anim8 = require("anim8")

function loadAnimations()
  idle_img = love.graphics.newImage("assets/gfx/idle.png")
  local idle_grid = anim8.newGrid(player.width, player.height, idle_img:getWidth(), idle_img:getHeight())
  idle_anim = anim8.newAnimation(idle_grid("1-3", 1, "2-2", 1), 0.4)

  walk_img = love.graphics.newImage("assets/gfx/walking.png")
  local walk_grid = anim8.newGrid(player.width, player.height, walk_img:getWidth(), walk_img:getHeight())
  walk_anim_r = anim8.newAnimation(walk_grid("1-4", 1), 0.2)
  walk_anim_l = walk_anim_r:clone():flipH()

  jump_img = love.graphics.newImage("assets/gfx/jumping.png")
  local jump_grid = anim8.newGrid(player.width, player.height, jump_img:getWidth(), jump_img:getHeight())
  jump_anim_r = anim8.newAnimation(jump_grid("1-2", 1), 0.14)
  jump_anim_l = jump_anim_r:clone():flipH()
end
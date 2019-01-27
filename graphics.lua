local anim8 = require("anim8")

function loadAnimations()
  sea_img = love.graphics.newImage("assets/gfx/sea.png")
  local sea_grid = anim8.newGrid(800, 350, sea_img:getWidth(), sea_img:getHeight())
  sea_anim = anim8.newAnimation(sea_grid("1-2", 1), 0.7)
  
  shore_img = love.graphics.newImage("assets/gfx/endwater.png")
  local shore_grid = anim8.newGrid(600, 100, shore_img:getWidth(), shore_img:getHeight())
  shore_anim = anim8.newAnimation(shore_grid("1-2", 1), 0.4)

  idle_img = love.graphics.newImage("assets/gfx/idle.png")
  local idle_grid = anim8.newGrid(player.width, player.height, idle_img:getWidth(), idle_img:getHeight())
  idle_anim = anim8.newAnimation(idle_grid("1-3", 1, "2-2", 1), 0.4)
  idle_anim2 = idle_anim:clone():flipH()
  juvele = idle_anim:clone()

  walk_img = love.graphics.newImage("assets/gfx/walking.png")
  local walk_grid = anim8.newGrid(player.width, player.height, walk_img:getWidth(), walk_img:getHeight())
  walk_anim_r = anim8.newAnimation(walk_grid("1-4", 1), 0.2)
  walk_anim_l = walk_anim_r:clone():flipH()

  jump_img = love.graphics.newImage("assets/gfx/jumping.png")
  local jump_grid = anim8.newGrid(player.width, player.height, jump_img:getWidth(), jump_img:getHeight())
  jump_anim_r = anim8.newAnimation(jump_grid("1-2", 1), 0.14)
  jump_anim_l = jump_anim_r:clone():flipH()

  umbrella_img = love.graphics.newImage("assets/gfx/brella.png")
  tree_img = love.graphics.newImage("assets/gfx/tree.png")
  palm_img = love.graphics.newImage("assets/gfx/palm.png")
  fern_img = love.graphics.newImage("assets/gfx/fern.png")
  grass_img = love.graphics.newImage("assets/gfx/grass.png")

  tree_img2 = love.image.newImageData("assets/gfx/tree2.png")
  palm_img2 = love.image.newImageData("assets/gfx/palm2.png")
  fern_img2 = love.image.newImageData("assets/gfx/fern2.png")
end

Prop = {
  x = 0;
  y = GROUND_HEIGHT;
  image = nil;
}

all_props = {}

function Prop:new(image, x, y, o) 
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.image = image
  o.x = x
  o.y = y
  table.insert(all_props, o)
  return o
end

function loadProps()
  Prop:new(palm_img, 20, GROUNDHEIGHT - palm_img:getHeight())
  Prop:new(grass_img, 300, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(fern_img, 200, GROUNDHEIGHT - fern_img:getHeight())
  Prop:new(grass_img, 450, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(grass_img, 400, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(fern_img, 700, GROUNDHEIGHT - fern_img:getHeight())
  Prop:new(tree_img, 1000, GROUNDHEIGHT - tree_img:getHeight())
  Prop:new(grass_img, 1100, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(grass_img, 1360, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(grass_img, 1620, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(fern_img, 1900, GROUNDHEIGHT - fern_img:getHeight())
  Prop:new(palm_img, 2700, GROUNDHEIGHT - palm_img:getHeight())
  Prop:new(grass_img, 1200, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(grass_img, 3100, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(grass_img, 3390, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(fern_img, 3200, GROUNDHEIGHT - fern_img:getHeight())
  Prop:new(grass_img, 4010, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(fern_img, 4230, GROUNDHEIGHT - fern_img:getHeight())
  Prop:new(tree_img, 5100, GROUNDHEIGHT - tree_img:getHeight())
  Prop:new(tree_img, 5300, GROUNDHEIGHT - tree_img:getHeight())
  Prop:new(tree_img, 5520, GROUNDHEIGHT - tree_img:getHeight())
  Prop:new(tree_img, 5000, GROUNDHEIGHT - tree_img:getHeight())
  Prop:new(palm_img, 5400, GROUNDHEIGHT - palm_img:getHeight())
  Prop:new(grass_img, 5580, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(fern_img, 5900, GROUNDHEIGHT - fern_img:getHeight())
  Prop:new(grass_img, 7100, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(fern_img, 7320, GROUNDHEIGHT - fern_img:getHeight())
  Prop:new(fern_img, 7600, GROUNDHEIGHT - fern_img:getHeight())
  Prop:new(grass_img, 8000, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(grass_img, 8500, GROUNDHEIGHT - grass_img:getHeight())
  Prop:new(grass_img, 9000, GROUNDHEIGHT - grass_img:getHeight())
end
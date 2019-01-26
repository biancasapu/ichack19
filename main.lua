require("conf")

function love.load()
  
end

function love.update(dt)

end

function love.draw()
  drawBackground()
  drawGround()
end

function drawBackground()
  love.graphics.setColor(1,1,1,1)
  love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
end

function drawGround()
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill", 0, 500, WIDTH, 100)
end
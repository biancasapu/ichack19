require("conf")

GROUNDHEIGHT = 500;

player = {
    width = 100;
    height = 100;
    x = 400;
    y = GROUNDHEIGHT - 100;
}

function love.load()
  
end

function love.update(dt)

end

function love.draw()
  drawBackground()
  drawGround()
  drawPlayer()
end

function drawBackground()
  love.graphics.setColor(1,1,1,1)
  love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
end

function drawGround()
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill", 0, GROUNDHEIGHT, WIDTH, 100)
end

function drawPlayer()
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill", player.x, player.y, player.height, player.width)
end
require("conf")

GROUNDHEIGHT = 500;
SPEED = 200;
SPEED_DEC = 3;

player = {
    width = 100;
    height = 100;
    x = 400;
    y = GROUNDHEIGHT - 100;
    speed = {
      x = 0;
      y = 0;
    }
}

function love.load()
  
end

function love.update(dt)
  
  if isMovingLeft() then
    player.speed.x = math.min(0, player.speed.x + SPEED_DEC)
  elseif isMovingRight() then
    player.speed.x = math.max(0, player.speed.x - SPEED_DEC)
  end

  checkKeys(dt)

  player.x = player.x + player.speed.x * dt
end

function isMovingLeft()
  return player.speed.x < 0
end

function isMovingRight()
  return player.speed.x > 0
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
  love.graphics.setColor(0.02, 0.3, 0.8, 1)
  love.graphics.rectangle("fill", player.x, player.y, player.height, player.width)
end

function checkKeys(dt)
  if love.keyboard.isDown("left") then
    player.speed.x = -SPEED
  elseif love.keyboard.isDown("right") then
    player.speed.x = SPEED
  end
end
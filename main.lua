require("conf")

GROUNDHEIGHT = 500;
SPEED = 200;
SPEED_DEC = 10;
CAMERA_TRESHOLD = 300;
CAMERA_THRESHOLD_LEFT = CAMERA_TRESHOLD
CAMERA_THRESHOLD_RIGHT = WIDTH - CAMERA_TRESHOLD

player = {
    width = 100;
    height = 100;
    x = 400;
    y = GROUNDHEIGHT - 100;
    draw_x = 400;
    draw_y = GROUNDHEIGHT - 100;
    speed = {
      x = 0;
      y = 0;
    }
}

ground = {
    width = WIDTH - 200;
    height = 100;
    x = 400;
    y = HEIGHT - GROUNDHEIGHT;
    draw_x = 0;
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

  local original_x = player.x;
  player.x = player.x + player.speed.x * dt
    updateDrawCoords(player.x - original_x)
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
  love.graphics.rectangle("fill", ground.draw_x, GROUNDHEIGHT, WIDTH, ground.height)
end

function drawPlayer()
  love.graphics.setColor(0.02, 0.3, 0.8, 1)
  love.graphics.rectangle("fill", player.draw_x, player.y, player.height, player.width)
end

function checkKeys()
  if love.keyboard.isDown("left") then
    player.speed.x = -SPEED
  elseif love.keyboard.isDown("right") then
    player.speed.x = SPEED
  end
end

function updateDrawCoords(delta)
    if CAMERA_THRESHOLD_LEFT < player.draw_x + player.width / 2 + delta and player.draw_x + player.width / 2 + delta < CAMERA_THRESHOLD_RIGHT then
        -- move player
        player.draw_x = player.draw_x + delta
    else
        -- move ground
        ground.draw_x = ground.draw_x - delta
    end
end


require("conf")
require("events")

GROUNDHEIGHT = 500;
SPEED = 200;
SPEED_DEC = 10;
CAMERA_TRESHOLD = 300;
CAMERA_THRESHOLD_LEFT = CAMERA_TRESHOLD
CAMERA_THRESHOLD_RIGHT = WIDTH - CAMERA_TRESHOLD

camera = {
  x = 0;
  y = 0;
}

player = {
    width = 100;
    height = 100;
    x = 350;
    y = GROUNDHEIGHT - 100;
    speed = {
      x = 0;
      y = 0;
    }
}

ground = {
    width = WIDTH - 200;
    height = 100;
    x = 0;
    y = GROUNDHEIGHT;
}

function love.load()
  rain_texture = love.graphics.newImage("assets/gfx/rain.png")
  rain_particles = love.graphics.newParticleSystem(rain_texture, 2000)
  rain_particles:setParticleLifetime(3, 8)
  rain_particles:setEmissionRate(500)
  rain_particles:setEmitterLifetime(-1)
  rain_particles:setEmissionArea("normal", WIDTH, GROUNDHEIGHT, 0, false)
  rain_particles:setLinearAcceleration(-20, 90, -25, 100)
  rain_particles:setSizes(0, 1, 0, 1)

  ev = TextEvent:new(5, 600)
end

function love.update(dt)
  
  if isMovingLeft() then
    player.speed.x = math.min(0, player.speed.x + SPEED_DEC)
  elseif isMovingRight() then
    player.speed.x = math.max(0, player.speed.x - SPEED_DEC)
  end

  local original_x = player.x
  player.x = player.x + player.speed.x * dt
  checkKeys(dt)
  updateCameraCoords(original_x - player.x)
  rain_particles:update(dt)

  ev:update(dt)
end

function isMovingLeft()
  return player.speed.x < 0
end

function isMovingRight()
  return player.speed.x > 0
end

function love.draw()
    drawBackground()
    love.graphics.translate(camera.x, camera.y)
    drawPlayer()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(rain_particles, 0, 0)
    drawGround()
    love.graphics.translate(-camera.x, -camera.y)
    
    local e = running_events_list
    while e do
      e.value:run()
      e = running_events_list.next
    end
end

function drawBackground()
  love.graphics.setColor(0.619,0.619,0.619,1)
  love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
end

function drawGround()
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill", ground.x, ground.y, WIDTH, ground.height)
end

function drawPlayer()
  love.graphics.setColor(0.02, 0.3, 0.8, 1)
  love.graphics.rectangle("fill", player.x, player.y, player.height, player.width)
end

function checkKeys()
  if love.keyboard.isDown("left") then
    player.speed.x = -SPEED
  elseif love.keyboard.isDown("right") then
    player.speed.x = SPEED
  end
end

function updateCameraCoords(distance)
    if CAMERA_THRESHOLD_LEFT < player.x + player.width / 2 + camera.x
    and player.x + player.width / 2 + camera.x < CAMERA_THRESHOLD_RIGHT then
      -- dont move camera
    else
      camera.x = camera.x + distance
    end
end


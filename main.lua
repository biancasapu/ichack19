require("conf")
require("events")

GROUNDHEIGHT = 500;
SPEED_X = 200;
SPEED_Y = 500;
SPEED_DEC_X = 10;
SPEED_DEC_Y = 10;
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
  font = love.graphics.setNewFont("assets/font.ttf", 28)

  local rain_texture = love.graphics.newImage("assets/gfx/rain.png")
  rain_particles = love.graphics.newParticleSystem(rain_texture, 2000)
  rain_particles:setParticleLifetime(3, 8)
  rain_particles:setEmissionRate(500)
  rain_particles:setEmitterLifetime(-1)
  rain_particles:setEmissionArea("normal", WIDTH, GROUNDHEIGHT, 0, false)
  rain_particles:setLinearAcceleration(-20, 90, -25, 100)
  rain_particles:setSizes(0, 1, 0, 1)

  TextEvent:new("ScHeMa", 2, 600)
  TextEvent:new("text message babey....", 5, 600)

  music = love.audio.newSource("assets/sfx/rain-07.mp3", "stream")
  music:setLooping(true)
  music:play()
end

function love.update(dt)
  
  if isMovingLeft() then
    player.speed.x = math.min(0, player.speed.x + SPEED_DEC_X)
  elseif isMovingRight() then
    player.speed.x = math.max(0, player.speed.x - SPEED_DEC_X)
  end

  if isOnGround() and player.speed.y >= 0 then
    player.speed.y = 0
  else
    player.speed.y = player.speed.y + SPEED_DEC_Y
  end

  local original_x = player.x
  player.x = player.x + player.speed.x * dt
  player.y = math.min(player.y + player.speed.y * dt, GROUNDHEIGHT)
  checkKeys(dt)
  updateCameraCoords(original_x - player.x)
  rain_particles:update(dt)

  for _, e in pairs(all_events_list) do
    e:update(dt)
  end
end

function isMovingLeft()
  return player.speed.x < 0
end

function isMovingRight()
  return player.speed.x > 0
end

function isOnGround()
  return player.y >= GROUNDHEIGHT - player.height
end

function love.draw()
    drawBackground()
    love.graphics.translate(camera.x, camera.y)
    drawPlayer()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(rain_particles, 0, 0)
    drawGround()
    love.graphics.translate(-camera.x, -camera.y)
    
    for _, e in pairs(all_events_list) do
      e:run()
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
    player.speed.x = -SPEED_X
  elseif love.keyboard.isDown("right") then
    player.speed.x = SPEED_X
  end

  if love.keyboard.isDown("up") and player.speed.y == 0 and isOnGround() then
    player.speed.y = -SPEED_Y
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


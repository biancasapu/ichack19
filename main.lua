require("conf")
require("events")
require("graphics")
local anim8 = require 'anim8'

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
    x = WIDTH / 2 - 50;
    y = GROUNDHEIGHT - 100;
    speed = {
      x = 0;
      y = 0;
    };
    dir = "still";
    jumping = false;
    collected_umbrella = false;
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
  rain_particles = love.graphics.newParticleSystem(rain_texture, 5000)
  rain_particles:setParticleLifetime(3, 8)
  rain_particles:setEmissionRate(1000)
  rain_particles:setEmitterLifetime(-1)
  rain_particles:setEmissionArea("normal", 7 * WIDTH, GROUNDHEIGHT, 0, false)
  rain_particles:setLinearAcceleration(-20, 90, -25, 100)
  rain_particles:setSizes(0, 1, 0, 1)

  TextEvent:new("Did you really want me to fall? :(", 4, -300)
  TextEvent:new("You're not going to find anything here...", 2, -1500)

  TextEvent:new("...", 2, 1500)
  TextEvent:new("I need an umbrella...", 3, 2250)

  umbrellaEvent = CollisionEvent:new(UMBRELLA_X, UMBRELLA_Y, UMBRELLA_WIDTH, UMBRELLA_HEIGHT)

  function umbrellaEvent:run()
    if self.active then
      self.active = false
      player.collected_umbrella = true
      TextEvent:new("Ah, much better.", 4, player.x - 50)
      music:setVolume(0.5)
    end
  end

  TextEvent:new("It didn't always rain, you know.", 3, 4800)
  TextEvent:new("It used to be sunny once...", 3, 6000)

  loadAnimations()
  
  music = love.audio.newSource("assets/sfx/rain-07.mp3", "stream")
  music:setVolume(0.7)
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

  walk_anim_r:update(dt)
  walk_anim_l:update(dt)
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
    drawUmbrella()
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

  for i in range(10) do
    love.graphics.rectangle("fill", ground.x + (i - 1) * WIDTH, ground.y, WIDTH, ground.height)
  end
end

-- lord forgive me
-- UMBRELLA
UMBRELLA_X = 3750
UMBRELLA_HEIGHT = 50
UMBRELLA_WIDTH = 50

function drawUmbrella()
  love.graphics.setColor(0, 1, 0, 1)

  if not player.collected_umbrella then
    love.graphics.rectangle("fill", UMBRELLA_X, ground.y - UMBRELLA_HEIGHT, UMBRELLA_WIDTH, UMBRELLA_HEIGHT)
  end
end

function drawPlayer()
  love.graphics.setColor(0.02, 0.3, 0.8, 1)
  if player.jumping then
    love.graphics.setColor(0.8, 0.3, 0.8, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.height, player.width)
  elseif (player.dir == "w_right") then
    walk_anim_r:draw(walk_img, player.x, player.y)
  elseif (player.dir == "w_left") then
    walk_anim_l:draw(walk_img, player.x, player.y)
  elseif (player.dir == "still") then
    love.graphics.rectangle("fill", player.x, player.y, player.height, player.width)
  end
end

function checkKeys()
  if love.keyboard.isDown("left") then
    player.speed.x = -SPEED_X
    player.dir = "w_left"
  elseif love.keyboard.isDown("right") then
    player.speed.x = SPEED_X
    player.dir = "w_right"
  else
    player.dir = "still"
  end

  if love.keyboard.isDown("up") and player.speed.y == 0 and isOnGround() then
    player.speed.y = -SPEED_Y
    player.jumping = true
  elseif player.speed.y >= 0 then
    player.jumping = false
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

function range(a, b, step)
  if not b then
    b = a
    a = 1
  end
  step = step or 1
  local f =
  step > 0 and
      function(_, lastvalue)
        local nextvalue = lastvalue + step
        if nextvalue <= b then return nextvalue end
      end or
      step < 0 and
      function(_, lastvalue)
        local nextvalue = lastvalue + step
        if nextvalue >= b then return nextvalue end
      end or
      function(_, lastvalue) return lastvalue end
  return f, nil, a - step
end


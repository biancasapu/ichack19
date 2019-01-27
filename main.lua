require("conf")
require("events")
require("graphics")
local anim8 = require 'anim8'
Timer = require "timer"

GROUNDHEIGHT = 500;
SPEED_X = 800;
SPEED_Y = 200;
SPEED_DEC_X = 10;
SPEED_DEC_Y = 10;
CAMERA_TRESHOLD = 300;
CAMERA_THRESHOLD_LEFT = CAMERA_TRESHOLD
CAMERA_THRESHOLD_RIGHT = WIDTH - CAMERA_TRESHOLD

camera = {
  x = 0;
  y = 0;
}

bg = {
  x = 0.619;
  y = 0.619;
  z = 0.619;
}

player = {
    width = 250;
    height = 350;
    x = WIDTH / 2 - 125;
    y = GROUNDHEIGHT - 350;
    speed = {
      x = 0;
      y = 0;
    };
    dir = "still";
    jumping = false;
    collected_umbrella = false;
    got_rid_of_umbrella = false;
    reached_end = false;
    finished_game = false;
    endgame_timer = 5;
    thanked = false;
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

  loadEvents()

  loadAnimations()
  
  music = love.audio.newSource("assets/sfx/rain-07.mp3", "stream")
  music:setVolume(0.7)
  music:setLooping(true)
  music:play()

  loadProps()
  umbrella_effect = love.audio.newSource("assets/sfx/umbrella_effect.mp3", "stream")

  music2 = love.audio.newSource("assets/sfx/MUZ.mp3", "stream")
  music2:setLooping(true)

end

function loadEvents()
  TextEvent:new("Did you really want me to fall? :(", 4, -300)
  TextEvent:new("You're not going to find anything here...", 2, -1500)

  TextEvent:new("...", 2, 1500)
  TextEvent:new("I really need an umbrella...", 3, 2250)

  umbrellaEvent = CollisionEvent:new(UMBRELLA_X, UMBRELLA_Y, UMBRELLA_WIDTH, UMBRELLA_HEIGHT)

  function umbrellaEvent:run()
    if self.active then
      self.active = false
      player.collected_umbrella = true
      TextEvent:new("Ah. Much better.", 4, player.x - 50)
      umbrella_effect:play()
      music:setVolume(0.5)
    end
  end

  TextEvent:new("It didn't always rain, you know.", 3, 4300)
  TextEvent:new("It used to be sunny around here.", 3, 6000)

  stopRainEvent = PositionEvent:new(7300)

  function stopRainEvent:run()
    if self.active then
      self.active = false
      TextEvent:new("Just like this.", 4, player.x - 50)
      rain_particles:stop()

      for i in range(10) do
        Timer.after(0.3 * i, function() music:setVolume(0.5 - i * 0.05) end)
      end

      Timer.after(3.0, function() music:stop() bg = {x = 0.972; y = 0.964; z = 0.686;} end)

      Timer.after(3.5, function() music2:play() end)
    end
  end

  deadEndEvent = PositionEvent:new(9250)
  function deadEndEvent:run()
    if self.active then
      self.active = false
      player.got_rid_of_umbrella = true
      tree_img:replacePixels(tree_img2)
      palm_img:replacePixels(palm_img2)
      fern_img:replacePixels(fern_img2)
      TextEvent:new("?", 5, player.x)
      Timer.after(5, function() TextEvent:new("Did I get lost?", 2, player.x - 50) end)
      Timer.after(7.5, function() TextEvent:new("Maybe I should be going back.", 3, player.x - 50) end)
      Timer.after(5, function() idle_anim = idle_anim2 end)
      player.reached_end = true
    end
  end

  RevTextEvent:new("It's easy to get lost on a rainy day.", 5, 7600)
  RevTextEvent:new("With this drizzle things might not be what they seem...", 5, 6400)
  RevTextEvent:new("Do you ever think about this?", 5, 4800)
  RevTextEvent:new("Or...", 3, 3800)
  RevTextEvent:new("I wonder where my umbrella went...", 5, 3000)
  RevTextEvent:new("Well, I suppose it's gone...", 3, 1500)
  RevTextEvent:new("I guess it's alright as long as you still get home.", 5, 1000)

  endGameEvent = RevPositionEvent:new(275)
  function endGameEvent:run()
    if self.active then
      self.active = false
      player.finished_game = true
    end
  end
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

  if player.x + player.speed.x * dt > 9350 then
    player.x = 9350
  elseif player.reached_end and player.x + player.speed.x * dt < 275 then
    player.x = 275
  else
    player.x = player.x + player.speed.x * dt
  end

  player.y = math.min(player.y + player.speed.y * dt, GROUNDHEIGHT)
  checkKeys(dt)
  updateCameraCoords(original_x - player.x)
  rain_particles:update(dt)

  for _, e in pairs(all_events_list) do
    e:update(dt)
  end

  sea_anim:update(dt)
  shore_anim:update(dt)
  walk_anim_r:update(dt)
  walk_anim_l:update(dt)
  idle_anim:update(dt)
  idle_anim2:update(dt)
  juvele:update(dt)
  jump_anim_l:update(dt)
  jump_anim_r:update(dt)

  Timer.update(dt)

  if player.finished_game then
    player.endgame_timer = math.max(player.endgame_timer - dt, 0)

    if player.endgame_timer == 0 and not player.thanked then
      player.thanked = true
      ThankEvent:new("Thanks for staying :)", 5, 275)
    end
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
    sea_anim:draw(sea_img, 0, HEIGHT - sea_img:getHeight())
    love.graphics.translate(camera.x, camera.y)
    drawUmbrella()
    drawPlayer()

    if player.reached_end then
      juvele:draw(idle_img, 40, GROUNDHEIGHT - idle_img:getHeight())
    end


    for _, p in pairs(all_props) do
      love.graphics.draw(p.image, p.x, p.y)
    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(rain_particles, 0, 0)
    drawGround()

    love.graphics.translate(-camera.x, -camera.y)

    if player.finished_game then
      love.graphics.setColor(0, 0, 0, 1 - player.endgame_timer / 5)
      love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
      music2:setVolume(player.endgame_timer / 5)
    end

    for _, e in pairs(all_events_list) do
      e:run()
    end
end

function drawBackground()
  love.graphics.setColor(bg.x, bg.y, bg.z, 1)
  love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
end

function drawGround()
  love.graphics.setColor(0,0,0,1)

  for i in range(12) do
    love.graphics.rectangle("fill", ground.x + (i - 1) * WIDTH, ground.y, WIDTH, ground.height)
  end

  love.graphics.setColor(1, 1, 1, 0.6)
  shore_anim:draw(shore_img, ground.x + 12 * WIDTH - 100, ground.y + 30)
end

-- lord forgive me
-- UMBRELLA
UMBRELLA_X = 3750
UMBRELLA_HEIGHT = 150
UMBRELLA_WIDTH = 150

function drawUmbrella()
  if not player.got_rid_of_umbrella then
    love.graphics.setColor(0.9, 0.9, 0.9, 1)

    if not player.collected_umbrella then
      love.graphics.draw(umbrella_img, UMBRELLA_X, ground.y - UMBRELLA_HEIGHT)
    else
      if player.dir == "w_right" or player.dir == "still" then
        love.graphics.draw(umbrella_img, player.x + 5, player.y + 50)
      else
        love.graphics.draw(umbrella_img, player.x + player.width - 5, player.y + 50, 0, -1, 1)
      end
    end
  end
end

function drawPlayer()
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  if player.jumping then
    if (player.dir == "w_right" or player.dir == "still") then 
      jump_anim_r:draw(jump_img, player.x, player.y)
    else
      jump_anim_l:draw(jump_img, player.x, player.y)
    end
  elseif (player.dir == "w_right") then
    walk_anim_r:draw(walk_img, player.x, player.y)
  elseif (player.dir == "w_left") then
    walk_anim_l:draw(walk_img, player.x, player.y)
  elseif (player.dir == "still") then
    idle_anim:draw(idle_img, player.x, player.y)
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


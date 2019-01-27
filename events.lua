TEXT_HEIGHT = 150

TextEvent = {
  x = 400;
  triggered = false;
  active = false;
  message = "NO MESSAGE";
  timer = 3;
}

all_events_list = {}

function TextEvent:new(message, time, x, o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.message = message
  o.timer = time
  o.x = x
  table.insert(all_events_list, o)
  return o
end

function TextEvent:update(dt)
  if player.x * self.x >= 0 and math.abs(player.x) > math.abs(self.x) and not self.triggered then
    self.triggered = true
    self.active = true
  end

  if self.triggered then
    self.timer = self.timer - dt
    if self.timer < 0 then
      self.active = false
    end
  end
end

function TextEvent:run()
  if self.active then
  local alpha = 1
  if self.timer < 2 then
    alpha = alpha - alpha * (2 - self.timer) / 2
  end
    love.graphics.printf({{0, 0, 0, alpha}, self.message}, 0, TEXT_HEIGHT, WIDTH, "center")
  end
end

CollisionEvent = {
  x = 400;
  y = 400;
  width = 50;
  height = 50;
  triggered = false;
  active = false;
}

function CollisionEvent:new(x, y, width, height, o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.x = x
  o.y = y
  o.width = width
  o.height = height
  table.insert(all_events_list, o)
  return o
end

function CollisionEvent:update()
  if (isPointInRectangle(player.x, player.y, self.x, self.y, self.width, self.height) or
      isPointInRectangle(player.x + player.width, player.y, self.x, self.y, self.width, self.height) or
      isPointInRectangle(player.x, player.y + player.height, self.x, self.y, self.width, self.height) or
      isPointInRectangle(player.x + player.width, player.y + player.height, self.x, self.y, self.width, self.height) or
      isPointInRectangle(self.x, self.y, player.x, player.y, player.width, player.height) or
      isPointInRectangle(self.x + self.width, self.y, player.x, player.y, player.width, player.height) or
      isPointInRectangle(self.x, self.y + self.height, player.x, player.y, player.width, player.height) or
      isPointInRectangle(self.x + self.width, self.y + self.height, player.x, player.y, player.width, player.height)) and
      not self.triggered then
    self.triggered = true
    self.active = true
  end
end

function CollisionEvent:run()
  if self.active then
    self.active = false
  end
end

function isPointInRectangle(p_x, p_y, r_x, r_y, r_width, r_height)
  return (p_x - r_x) * (p_x - r_x - r_width) <= 0 and (p_y - r_y) * (p_y - r_y - r_height) <= 0
end

TextEvent = {
  x = 400;
  triggered = false;
  active = false;
  message = "NO MESSAGE";
  timer = 3;
}

all_events_list = nil

function TextEvent:new(message, time, x, o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.message = message
  self.timer = time
  self.x = x
  return o
end

function TextEvent:update(dt)
  if (player.x >= self.x or (player.x * self.x >= 0 and math.abs(player.x) > math.abs(self.x))) and self.triggered == false then
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
    love.graphics.printf({{0, 0, 0, alpha}, self.message}, 0, 200, WIDTH, "center")
  end
end

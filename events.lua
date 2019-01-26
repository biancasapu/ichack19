TextEvent = {
  x = 400;
  triggered = false;
  active = false;
  message = "NO MESSAGE";
  timer = 3;
}

running_events_list = nil

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
  if self.triggered then
    self.timer = self.timer - dt
    if self.timer < 0 then
      self.active = false
    end
  end
  if player.x * self.x > 0 and math.abs(player.x) > math.abs(self.x) and self.triggered == false then
    self.triggered = true
    self.active = true
    running_events_list = {next = running_events_list, value = self}
  end
end

function TextEvent:run()
  local alpha = 1
  if self.timer < 2 then
    alpha = alpha - alpha * (2 - self.timer) / 2
  end

  if self.active then
    love.graphics.print({{0, 0, 0, alpha}, self.message}, 400, 300)
  end
end

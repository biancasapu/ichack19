TextEvent = {
  x = 400;
  triggered = false;
  active = false;
  timer = 3;
}

running_events_list = nil

function TextEvent:new(time, x, o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
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
  if self.active then
    love.graphics.print("benis")
  end
end

Object = require("lib.classic")
local Keys = Object:extend()

function Keys:new()
  self.state = {}
end

function Keys:on(key)
  self.state[key] = true
end

function Keys:off(key)
  self.state[key] = nil
end

function Keys:hasDirection()
  if self.state["up"] then return "up" end
  if self.state["down"] then return "down" end
  if self.state["left"] then return "left" end
  if self.state["right"] then return "right" end
  return nil
end

Keys.getDirection = function (key)
  if key == "up" then
    return 0, -1
  elseif key == "down" then
    return 0, 1
  elseif key == "left" then
    return -1, 0
  elseif key == "right" then
    return 1, 0
  else
    return 0, 0
  end
end

Keys.isDirection = function (key)
  return key == "up" or key == "down" or key == "left" or key == "right"
end

return Keys
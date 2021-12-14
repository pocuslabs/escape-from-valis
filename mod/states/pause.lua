local help = require("mod.helpers")

local pauseState = {}

function pauseState:enter(from)
  self.from = from
  love.graphics.clear()
end

function pauseState:draw()
  local str = "PAUSE"
  local font = love.graphics.getFont()
  local text = love.graphics.newText(font, str)
  local w, h = love.graphics.getDimensions()
  local x = w / 2 - font:getWidth(str) / 2
  local y = h / 2 - font:getHeight() / 2
  love.graphics.setColor(help.rgba(0, 0, 0))
  love.graphics.rectangle("fill", 0, 0, w, h)
  love.graphics.setColor(help.rgba(255, 255, 255))
  love.graphics.draw(text, x, y)
end

function pauseState:keyreleased(key)
  if key == 'return' then
    Gamestate.switch(self.from)
  end
end

return pauseState

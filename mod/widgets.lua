local const = require("mod/constants")
local helpers = require("mod/helpers")

local rgba = helpers.rgba
local DEFAULT_MARGIN = const.DEFAULT_MARGIN

local function makeText(text)
  local winWidth, winHeight = love.graphics.getDimensions()
  local font = love.graphics.getFont()

  local x = DEFAULT_MARGIN
  local w = winWidth - x - DEFAULT_MARGIN * 2
  local h = font:getHeight() * 3 + DEFAULT_MARGIN * 2
  local y = winHeight - h - DEFAULT_MARGIN * 2

  local outerWidth = w
  local outerHeight = h
  local outerX = DEFAULT_MARGIN
  local outerY = outerHeight * 7/8
  love.graphics.setColor(rgba(100, 100, 100))
  love.graphics.rectangle("fill", outerX, outerY, outerWidth, outerHeight)

  local innerX = outerX + DEFAULT_MARGIN
  local innerY = outerY + DEFAULT_MARGIN
  local innerWidth = w - (DEFAULT_MARGIN * 2)
  local innerHeight = h - (DEFAULT_MARGIN * 2)
  love.graphics.setColor(rgba(128, 128, 128))
  love.graphics.rectangle("fill", innerX, innerY, innerWidth, innerHeight)

  local textX = innerX + DEFAULT_MARGIN
  local textY = innerY + DEFAULT_MARGIN
  local textObject = love.graphics.newText(font, text)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(textObject, textX, textY)

  return textObject, { x = x, y = y, w = w, h = h }
end

local widgets = {
  makeText = makeText
}

return widgets

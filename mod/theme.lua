local const = require "mod.constants"
local help = require "mod.helpers"

local theme = {}

function theme.TextBox(text, opt, x, y, w, h)
  local DEFAULT_MARGIN = const.DEFAULT_MARGIN
  local outerWidth = w
  local outerHeight = h
  local outerX = x
  local outerY = y * 7/8
  love.graphics.setColor(help.rgba(100, 100, 100))
  love.graphics.rectangle("fill", outerX, outerY, outerWidth, outerHeight)

  local innerX = outerX + DEFAULT_MARGIN
  local innerY = outerY + DEFAULT_MARGIN
  local innerWidth = w - (DEFAULT_MARGIN * 2)
  local innerHeight = h - (DEFAULT_MARGIN * 2)
  love.graphics.setColor(help.rgba(128, 128, 128))
  love.graphics.rectangle("fill", innerX, innerY, innerWidth, innerHeight)

  local textX = innerX + DEFAULT_MARGIN
  local textY = innerY + DEFAULT_MARGIN
  local textObject = love.graphics.newText(opt.font, text)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(textObject, textX, textY)
end

return theme

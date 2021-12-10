local helium = require "lib/helium"
local const = require "mod/constants"
local helpers = require "mod/helpers"

local rgb = helpers.rgb
local DEFAULT_MARGIN = const.DEFAULT_MARGIN

local font = love.graphics.newFont("fonts/merriweather/Merriweather-Regular.ttf", 32)

local textCreator = helium(function (param, view)
  return function ()
    local outerX = 0
    local outerY = 0
    local outerWidth = view.w
    local outerHeight = view.h
    love.graphics.setColor(rgb(100, 100, 100))
    love.graphics.rectangle("fill", outerX, outerY, outerWidth, outerHeight)

    local innerX = outerX + DEFAULT_MARGIN
    local innerY = outerY + DEFAULT_MARGIN
    local innerWidth = view.w - (DEFAULT_MARGIN * 2)
    local innerHeight = view.h - (DEFAULT_MARGIN * 2)
    love.graphics.setColor(rgb(128, 128, 128))
    love.graphics.rectangle("fill", innerX, innerY, innerWidth, innerHeight)

    local textX = innerX + DEFAULT_MARGIN
    local textY = innerY + DEFAULT_MARGIN
    local textObject = love.graphics.newText(param.font, param.text)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(textObject, textX, textY)
  end
end)

local function makeText(text)
  local winWidth, winHeight = love.graphics.getDimensions()
  local x = 16
  local w = winWidth - x - DEFAULT_MARGIN * 2
  local h = font:getHeight() * 3 + DEFAULT_MARGIN * 2
  local y = winHeight - h - DEFAULT_MARGIN * 2
  local textBox = textCreator({ text = text, font = font }, w, h)
  return textBox, { x = x, y = y, w = w, h = h }
end

local widgets = {
  makeText = makeText
}

return widgets

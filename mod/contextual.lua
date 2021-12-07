local font = love.graphics.newFont("fonts/roboto/RobotoSlab-Regular.ttf", 32)

local DEFAULT_MARGIN = 16

local function rgb(r, g, b)
  return r / 255, g / 255, b / 255
end

local DisplayModes = {
  FULL = "FULL",
  FIT = "FIT"
}

-- say(text, opts)
-- Display the given text in a selected font, with optional parameters to control display
--
-- opts = {
--   display: "FULL" or "FIT"
-- }
--
-- A display option of "FULL" will show a text box the width of the screen, a full size box
-- A display option of "FIT" will center a text box and try to fit the box to the text
local function say(text, opts)
  if not opts then opts = {} end

  local displayMode = opts.display or "FULL"
  if not DisplayModes[displayMode] then return nil end

  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  local outerX = DEFAULT_MARGIN
  local outerY = height * 3/4 - DEFAULT_MARGIN
  local outerWidth = width - DEFAULT_MARGIN * 2
  local outerHeight = height * 1/4
  love.graphics.setColor(rgb(100, 100, 100))
  love.graphics.rectangle("fill", outerX, outerY, outerWidth, outerHeight)

  local innerX = outerX + DEFAULT_MARGIN
  local innerY = outerY + DEFAULT_MARGIN
  local innerWidth = outerWidth - DEFAULT_MARGIN * 2
  local innerHeight = outerHeight - DEFAULT_MARGIN * 2
  love.graphics.setColor(rgb(128, 128, 128))
  love.graphics.rectangle("fill", innerX, innerY, innerWidth, innerHeight)

  local textX = innerX + DEFAULT_MARGIN / 2
  local textY = innerY + DEFAULT_MARGIN / 2
  local textObject = love.graphics.newText(font, text)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(textObject, textX, textY)
end

local contextual = {
  say = say
}

return contextual
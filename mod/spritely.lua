local constants = require("mod/constants")

local function load(filename, opts)
  if not opts then opts = {} end
  local padding = opts.padding or 0
  local margin = opts.margin or 0

  local spritesheet = love.graphics.newImage(filename)

  -- x and y are tile coordinates, 1-indexed
  -- each increment to x / y goes by w / h
  local selector = function (x, y, w, h)
    if not x or not y then return nil end
    if not w then w = constants.TILE end
    if not h then h = constants.TILE end

    if x < 1 then x = 1 end
    if y < 1 then y = 1 end

    local marginLeft
    if x == 1 then
      marginLeft = 0
    else
      marginLeft = margin
    end

    local marginTop
    if y == 1 then
      marginTop = 0
    else
      marginTop = margin
    end

    local prevLeft
    if x == 1 then
      prevLeft = 0
    else
      prevLeft = (x - 1) * w + (x - 1) * padding
    end

    local prevTop
    if y == 1 then
      prevTop = 0
    else
      prevTop = (y - 1) * h + (y - 1) * padding
    end

    local originX = marginLeft + prevLeft + x * w
    local originY = marginTop + prevTop + y * h

    local quad = love.graphics.newQuad(originX, originY, w, h, spritesheet:getDimensions())
    return spritesheet, quad
  end

  return selector
end

local spritely = {
  load = load
}

return spritely

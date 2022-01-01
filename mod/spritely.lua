local constants = require("mod.constants")

local function load(filename, opts)
  if not opts then opts = {} end
  local padding = opts.padding or 0
  local margin = opts.margin or 0

  local spritesheet = love.graphics.newImage(filename)
  local sw, sh = spritesheet:getDimensions()
  local cache = {}

  -- x and y are tile coordinates, 1-indexed
  -- i.e. each increment to x / y goes by w / h units, respectively
  local selector = function (x, y, w, h)
    -- sane defaults
    -- assuming uniform sprite size (i.e. all sprites should be the same size)
    if not x or not y then return nil end
    if not w then w = constants.TILE_SIZE * constants.SCALE end
    if not h then h = constants.TILE_SIZE * constants.SCALE end

    -- make sure the coordinates are 1-indexed!
    if x < 1 then x = 1 end
    if y < 1 then y = 1 end

    local ckey = {x, y, w, h}
    if cache[ckey] then
      return cache[ckey]
    end

    -- this calculates the pixel space taken up by all the sprites to the left
    local prevLeft
    if x == 1 then
      prevLeft = 0
    else
      local spriteSpace = math.max(0, x - 1) * w
      local paddingSpace = math.max(0, x - 2) * padding
      prevLeft = spriteSpace + paddingSpace
    end

    -- same as above, but for sprites above the selected sprite
    -- lower y value == higher on the screen
    local prevTop
    if y == 1 then
      prevTop = 0
    else
      local spriteSpace = math.max(0, y - 1) * h
      local paddingSpace = math.max(0, y - 2) * padding
      prevTop = spriteSpace + paddingSpace
    end

    -- calculate the total x and y offsets
    local originX = margin + prevLeft
    local originY = margin + prevTop
    local quad = love.graphics.newQuad(originX, originY, w, h, sw, sh)
    cache[ckey] = quad

    return quad
  end

  return selector, spritesheet
end

local spritely = {
  load = load
}

return spritely

Object = require("lib.classic")

local const = require("mod.constants")
local help = require("mod.helpers")

local Room = Object:extend()

function Room:new(x, y, w, h)
  -- pass in tile coordinates, but use absolute pixel coordinates internally
  x = x or 1
  y = y or 1
  w = w or 1
  h = h or 1
  self.posX, self.posY = help.tileToPixel(x, y)
  self.w, self.h = help.tileToPixel(w, h)
  self.map = {}

  for ty=1, h do
    local row = {}
    local isRowWall = ty == 1 or ty == h

    for tx=1, w do
      local isWall = isRowWall or tx == 1 or tx == w
      local tile = const.TILES.ground
      if isWall then
        tile = const.TILES.wall
      end

      table.insert(row, tile)
    end

    table.insert(self.map, row)
  end
end

-- this function takes absolute x/y coordinates and tells us
-- whether the room matches the coordinates
function Room:isInside(screenX, screenY)
  local xWithin = screenX >= self.posX and screenX <= (self.posX + self.w)
  local yWithin = screenY >= self.posY and screenY <= (self.posY + self.h)
  return xWithin and yWithin
end

return Room

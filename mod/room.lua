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

function Room:isInside(screenX, screenY)
  local xWithin = screenX >= self.posX and screenX <= (self.posX + self.w)
  local yWithin = screenY >= self.posY and screenY <= (self.posY + self.h)
  return xWithin and yWithin
end

function Room:pixelCenter()
  return self.w / 2, self.h / 2
end

function Room:pathTo(tx, ty)
  local centerX, centerY = self:pixelCenter()
  local targetX, targetY = help.tileToPixel(tx, ty)

  local curX = centerX
  local curY = centerY
  while curX ~= targetX and curY ~= targetY do
    local diffX, diffY = (targetX - curX) / const.TILE_SIZE, (targetY - curY) / const.TILE_SIZE
    local slope = diffY / diffX
    local xSign = 1
    local ySign = 1
    if targetX - curX < 0 then xSign = -1 end
    if targetY - curY < 0 then ySign = -1 end

    if slope > 1 then
      -- y diff is greater
      curY = curY + const.TILE_SIZE * ySign
    else
      -- x diff is greater
      curX = curX + const.TILE_SIZE * xSign
    end

    local tx, ty = help.pixelToTile(curX, curY)
    self.map[ty][tx] = const.TILES.ground
  end
end

return Room

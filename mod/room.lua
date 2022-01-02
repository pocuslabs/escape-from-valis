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
  self.x, self.y = help.tileToPixel(x, y)
  self.w, self.h = help.tileToPixel(w, h)

  self.doors = self:makeDoors()
  self.map = {}

  for ty=1, h do
    local row = {}
    local isRowWall = ty == y or ty == h

    for tx=1, w do
      local isWall = isRowWall or tx == x or tx == w
      local tile = const.TILES.ground
      if isWall then
        tile = const.TILES.wall
        local name = "Tile "..tx..","..ty
        local tileId = { name = name }
        local size = const.TILE_SIZE * const.SCALE
        local px, py = help.tileToPixel(tx, ty)
        Game.world:add(tileId, px, py, size, size)
      end

      table.insert(row, tile)
    end

    table.insert(self.map, row)
  end
end

-- this function takes absolute x/y coordinates and tells us
-- whether the room matches the coordinates
function Room:isInside(ax, ay)
  local hasCoords = ay <= #self.map and ax <= #self.map[1]
  local xWithin = ax >= self.x and ax <= (self.x + self.w)
  local yWithin = ay >= self.y and ay <= (self.y + self.h)
  return hasCoords and xWithin and yWithin
end

function Room:makeDoors()
  local dirs = {
    {0, 1},
    {1, 0},
    {0, -1},
    {-1, 0}
  }

  local numDoors = love.math.random(const.MAX_DOORS)
  local doors = {}
  for _=1, numDoors do
    local idx = love.math.random(#dirs)
    local doorDir = dirs[idx] -- hodor
    dirs[idx] = nil
    table.insert(doors, doorDir)
  end

  return doors
end

return Room

Object = require("lib.classic")

local const = require("mod.constants")
local help = require("mod.helpers")

local Room = Object:extend()

function Room:new(x, y, w, h)
  -- pass in tile coordinates, but use absolute pixel coordinates internally
  self.x = help.tileToPixel(x or 1)
  self.y = help.tileToPixel(y or 1)
  self.w = help.tileToPixel(w or 1)
  self.h = help.tileToPixel(h or 1)

  self.doors = self:makeDoors()
  self.map = {}

  for iy=1, h do
    local row = {}
    local isRowWall = iy == y or iy == h

    for ix=1, w do
      local isWall = isRowWall or ix == x or ix == w
      local tile = const.TILES.ground
      if isWall then
        tile = const.TILES.wall
        local name = "Tile "..ix..","..iy
        local tileId = { name = name }
        local size = const.TILE_SIZE * const.SCALE
        Game.world:add(tileId, ix, iy, size, size)
      end

      table.insert(row, tile)
    end

    table.insert(self.map, row)
  end
end

-- this function takes absolute x/y coordinates and tells us
-- whether the room matches the coordinates
-- note: x and y are tile coordinates NOT pixels
function Room:isInside(ox, oy)
  local hasCoords = oy <= #self.map and ox <= #self.map[1]
  local xWithin = ox >= self.x and ox <= (self.x + self.w)
  local yWithin = oy >= self.y and oy <= (self.y + self.h)
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

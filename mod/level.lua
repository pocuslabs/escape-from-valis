Object = require("lib.classic")
local inspect = require("lib.inspect")

local spritely = require("mod.spritely")
local const = require("mod.constants")
local Room = require("mod.room")
local help = require("mod.helpers")

local Level = Object:extend()

function Level:new(number, pw, ph)
  self.roomCount = love.math.random(const.MAX_ROOMS)

  self.selector, self.spritesheet = spritely.load("gfx/dung2.png", { padding = 2, margin = 2 })
  self.memo = {}
  self.tiles = {}
  self.rooms = {}
  self.map = {}

  self.width, self.height = help.pixelToTile(pw, ph)
  self.maxWidth = 1
  self.maxHeight = 1

  number = number or 1  -- the level we're on

  -- make rooms
  for _=1, self.roomCount do
    -- if this room is bigger than the max, set the max
    local w = love.math.random(const.MIN_SIZE, const.MAX_SIZE)
    local w2 = w * w
    if w2 > self.maxWidth then self.maxWidth = w2 end

    local h = love.math.random(const.MIN_SIZE, const.MAX_SIZE)
    local h2 = h * h
    if h2 > self.maxHeight then self.maxHeight = h2 end

    local x = love.math.random(self.maxWidth)
    local y = love.math.random(self.maxHeight)
    local room = Room(x, y, w, h)
    table.insert(self.rooms, room)
  end

  -- pregenerate a 2D array of w width and h height
  local map = {}
  for y = 1, self.maxHeight do
    map[y] = {}
    for _ = 1, self.maxWidth do
      table.insert(map[y], const.TILES.ground)
    end
  end

  for y=1, self.height do
    for x=1, self.width do
      for _, room in ipairs(self.rooms) do
        local px, py = help.tileToPixel(x, y)
        if room:isInside(px, py) then
          map[y][x] = room.map[y][x]
        end
      end
    end
  end

  self.map = map
end

-- this function operates on tile coordinates, NOT pixels
-- see mod.constants.TILES for examples
function Level:tile(tx, ty)
  local key = tx..","..ty
  if self.tiles[key] then
    return self.tiles[key]
  end

  local quad = self.selector(tx, ty)
  self.tiles[key] = quad
  return quad
end

function Level:tileAtPixels(px, py)
  local tx, ty = help.pixelToTile(px, py)
  local tile = self.map[ty][tx]
  return tile
end

function Level:draw()
  for ty, row in ipairs(self.map) do
    for tx, tile in ipairs(row) do
      local sx, sy = unpack(tile.coordinates)
      local quad = self.selector(sx, sy)
      local px, py = help.tileToPixel(tx, ty)
      love.graphics.draw(self.spritesheet, quad, px, py)
    end
  end
end

return Level

Object = require("lib.classic")
local inspect = require("lib.inspect")

local spritely = require("mod.spritely")
local const = require("mod.constants")
local Room = require("mod.room")
local help = require("mod.helpers")

local Level = Object:extend()

function Level:new(pw, ph)
  self.roomCount = love.math.random(const.MAX_ROOMS)

  self.selector, self.spritesheet = spritely.load("gfx/dung2.png", { padding = 2, margin = 2 })
  self.memo = {}
  self.tiles = {}
  self.rooms = {}
  self.map = {}

  self.width, self.height = help.pixelToTile(pw, ph)
  self.maxWidth = 1
  self.maxHeight = 1

  self:generate()
end

function Level:generate(number)
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

    local ox = love.math.random(self.maxWidth)
    local oy = love.math.random(self.maxHeight)
    local room = Room(ox, oy, w, h)
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

  -- fill in the room tiles
  -- note: ax and ay are absolute map coordinates
  -- (as opposed to room-relative coordinates)
  for ay=1, self.height do
    for ax=1, self.width do
      for _, room in ipairs(self.rooms) do
        local px, py = help.tileToPixel(ax, ay)
        if room:isInside(px, py) then
          map[ay][ax] = room.map[ay][ax]
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
  for y, row in ipairs(self.map) do
    for x, tile in ipairs(row) do
      local tx, ty = unpack(tile.coordinates)
      local quad = self.selector(tx, ty)
      local px, py = help.tileToPixel(x, y)
      love.graphics.draw(self.spritesheet, quad, px, py)
    end
  end
end

return Level

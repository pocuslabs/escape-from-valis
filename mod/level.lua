Object = require("lib.classic")
local bump = require('lib.bump')
local inspect = require("lib.inspect")

local spritely = require("mod.spritely")
local const = require("mod.constants")
local Room = require("mod.room")

local Level = Object:extend()

function Level:new(pw, ph)
  self.roomCount = love.math.random(const.MAX_ROOMS)

  self.selector = spritely.load("gfx/dung2.png", { padding = 2, margin = 2 })
  self.memo = {}
  self.tiles = {}
  self.rooms = {}
  self.map = {}

  self.width = math.ceil(pw / const.TILE_SIZE / const.SCALE)
  self.height = math.ceil(ph / const.TILE_SIZE / const.SCALE)
  self.maxWidth = 1
  self.maxHeight = 1


  self.world = bump.newWorld(const.TILE_SIZE)

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

  end

  -- pregenerate a 2D array of w width and h height
  local map = {}
  for y = 1, self.maxHeight do
    map[y] = {}
    for x = 1, self.maxWidth do
      local tile = {} 
      for k, v in pairs(const.TILES.ground) do
        tile[k] = v
      end
      tile.x = x * const.TILE_SIZE
      tile.y = y * const.TILE_SIZE
      tile.w = const.TILE_SIZE
      tile.h = const.TILE_SIZE
      self.world:add(tile, tile.x, tile.x, tile.w, tile.h) -- x,y, width, height
      table.insert(map[y], const.TILES.ground)
    end
  end

  -- fill in the room tiles
  -- note: ax and ay are absolute map coordinates
  -- (as opposed to room-relative coordinates)
  for ay=1, self.height do
    for ax=1, self.width do
      for _, room in ipairs(self.rooms) do
        if room:isInside(ax, ay) then
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
    return unpack(self.tiles[key])
  end

  local img, quad = self.selector(tx, ty)
  self.tiles[key] = { img, quad }
  return img, quad
end

function Level:tileAtPixels(px, py)
  local tx = math.ceil(px / const.TILE_SIZE / const.SCALE)
  local ty = math.ceil(py / const.TILE_SIZE / const.SCALE)
  local tile = self.map[ty][tx]
  return tile
end

local function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,70)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end

function Level:draw()
  bump.bump_debug.draw(self.world)

  local items = self.world:getItems()
  for _, tile in ipairs(items) do
    drawBox(tile, 0, 222, 0)
    -- -- print("TT", inspect(tile.coordinates))
    -- for k, v in pairs(tile.coordinates) do
    --   -- print(k, v)
    -- end
  end

end

return Level

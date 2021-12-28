Object = require("lib.classic")

local spritely = require("mod.spritely")
local const = require("mod.constants")
local Level = require("mod.level")

local Map = Object:extend()

function Map:new(spritesheet)
  self.spritesheet = spritesheet
  self.selector = spritely.load("gfx/dung2.png", { padding = 2, margin = 2 })
  self.memo = {}
  self.tiles = {}
end

-- this function operates on tile coordinates, NOT pixels
-- see mod.constants.TILES for examples
function Map:tile(tx, ty)
  local key = tx..","..ty
  if self.tiles[key] then
    return table.unpack(self.tiles[key])
  end

  local img, quad = self.selector(tx, ty)
  self.tiles[key] = table.pack(img, quad)
  return img, quad
end

function Map:generate(number)
  number = number or 1  -- the level we're on
  -- we should cache the levels so we can call generate any number of times
  if self.memo[number] then
    return self.memo[number]
  end

  local numRooms = love.math.random(const.MAX_ROOMS)
  local level = Level(numRooms)

  self.memo[number] = level
  return level
end

return Map

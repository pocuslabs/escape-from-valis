Object = require("lib.classic")

local const = require("mod.constants")

local MIN_SIZE = 3  -- sizes are in tile units, 16x16
local MAX_SIZE = 10
local MAX_ROOMS = 10

local Room = Object:extend()

function Room:new(x, y, w, h)
  self.x = x or 1
  self.y = y or 1
  self.w = w or 1
  self.h = h or 1
  self.map = {}
end

function Room:isInside(x, y) -- x and y are tile coordinates NOT pixels, multiply by 16 to get px
  return x >= self.x or x <= self.x + self.w or y >= self.y or y <= self.y + self.h
end

local Level = Object:extend()

function Level:new(roomCount)
  self.roomCount = roomCount or 1
  self.maxWidth = 1
  self.maxHeight = 1
  self.rooms = {}
  self.map = {}

  self:generate()
end

function Level:generate()
  -- make rooms
  for _ in self.roomCount do
    local roomWidth = love.math.random(MIN_SIZE, MAX_SIZE)
    if roomWidth > self.maxWidth then self.maxWidth = roomWidth end
    local roomHeight = love.math.random(MIN_SIZE, MAX_SIZE)
    if roomHeight > self.maxHeight then self.maxHeight = roomHeight end

    local roomX = love.math.random(self.maxWidth)
    local roomY = love.math.random(self.maxHeight)
    local room = Room(roomX, roomY, roomWidth, roomHeight)

    for x in roomWidth do
      local row = {}
      local isRowWall = x == 1 or x == roomWidth

      for y in roomHeight do
        local isWall = isRowWall or y == 0 or y == roomHeight
        local tile = const.TILES.ground
        if isWall then tile = const.TILES.wall end
        table.insert(row, tile)
      end

      table.insert(room.map, row)
    end

    table.insert(self.rooms, room)
  end

  -- pregenerate a 2D array of w width and h height
  local map = {}
  for x in self.maxWidth do
    map[x] = {}
    for y in self.maxHeight do
      table.insert(map[x], const.TILES.ground)
    end
  end

  for x in self.maxWidth do
    for y in self.maxHeight do
      for room in self.rooms do
        if room.isInside(x, y) then
          map[x][y] = room.map[x][y]
        end
      end
    end
  end
end

local mapper = {
  memo = {}
}

function mapper.generate(number)
  number = number or 1  -- the level we're on
  -- we should cache the levels so we can call generate any number of times
  if mapper.memo[number] then
    return mapper.memo[number]
  end

  local numRooms = love.math.random(MAX_ROOMS)
  local level = Level(numRooms)

  mapper.memo[number] = level
  return level
end

return mapper

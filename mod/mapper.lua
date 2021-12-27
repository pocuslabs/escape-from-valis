Object = require("lib.classic")

local const = require("mod.constants")

local Level = Object:extend()

function Level:new(roomCount)
  self.roomCount = roomCount or 1
  self.maxWidth = 1
  self.maxHeight = 1
  self.rooms = {}
  self.map = {}
end

local Room = Object:extend()

local MIN_SIZE = 3  -- sizes are in tile units, 16x16
local MAX_SIZE = 10
local MAX_ROOMS = 10

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

local mapper = {
  memo = {}
}

local function makeRooms(numRooms)
  numRooms = numRooms or 1
  local level = Level(numRooms)

  for _ in numRooms do
    local roomWidth = love.math.random(MIN_SIZE, MAX_SIZE)
    if roomWidth > level.maxWidth then level.maxWidth = roomWidth end
    local roomHeight = love.math.random(MIN_SIZE, MAX_SIZE)
    if roomHeight > level.maxHeight then level.maxHeight = roomHeight end

    local roomX = love.math.random(level.maxWidth)
    local roomY = love.math.random(level.maxHeight)
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

    table.insert(level.rooms, room)
  end
end

function mapper.generate(number)
  number = number or 1  -- the level we're on
  -- we should cache the levels so we can call generate any number of times
  if mapper.memo[number] then
    return mapper.memo[number]
  end

  local numRooms = love.math.random(MAX_ROOMS)
  local rooms = makeRooms(numRooms)

  for room in rooms do
    room.x = love.math.random(rooms.maxWidth)
    room.y = love.math.random(rooms.maxHeight)
  end

  local map = {}
  for x in rooms.maxWidth do
    for y in rooms.maxHeight do
      if rooms.isInside(x, y) then
        map[x][y] = room
      end
    end
  end

  local level = {
    number = number,  -- the number of the level we're on
    rooms = rooms,
    map = map
  }

  mapper.memo[number] = level
  return level
end

return mapper

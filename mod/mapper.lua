local const = require("mod.constants")

local mapper = {
  memo = {}
}

local MIN_SIZE = 3  -- sizes are in tile units, 16x16
local MAX_SIZE = 10
local MAX_ROOMS = 10

local function makeRooms(numRooms)
  numRooms = numRooms or 1
  local rooms = {
    maxWidth = 1,
    maxHeight = 1
  }
  
  for _ in numRooms do
    local roomWidth = love.math.random(MIN_SIZE, MAX_SIZE)
    if roomWidth > rooms.maxWidth then rooms.maxWidth = roomWidth end
    local roomHeight = love.math.random(MIN_SIZE, MAX_SIZE)
    if roomHeight > rooms.maxHeight then rooms.maxHeight = roomHeight end

    local room = {
      w = roomWidth,
      h = roomHeight,
      map = {}  -- this will be a 2D table (array) of tile indices
    }

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

    table.insert(rooms, room)
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

local const = require("mod.constants")

local mapper = {
  memo = {}
}

function mapper.generate(number)
  number = number or 1
  -- we should cache the levels so we can call generate any number of times
  if mapper.memo[number] then
    return mapper.memo[number]
  end

  local level = {
    number = number  -- the number of the level we're on
  }

  local MIN_SIZE = 3  -- sizes are in tile units, 16x16
  local MAX_SIZE = 10
  local MAX_ROOMS = 10
  local numRooms = love.math.random(MAX_ROOMS)
  local maxWidth = 1
  local maxHeight = 1

  local rooms = {}
  for _ in numRooms do
    local roomWidth = love.math.random(MIN_SIZE, MAX_SIZE)
    if roomWidth > maxWidth then maxWidth = roomWidth end
    local roomHeight = love.math.random(MIN_SIZE, MAX_SIZE)
    if roomHeight > maxHeight then maxHeight = roomHeight end

    local room = {
      map = {}
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

  local map = {}
  local roomPositions = {}
  for room in rooms do
    room.x = love.math.random(maxWidth)
    room.y = love.math.random(maxHeight)
  end

  mapper.memo[number] = level
  return level
end

return mapper

Object = require("lib.classic")

local const = require("mod.constants")
local Room = require("mod.room")

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
  for _=1, self.roomCount do
    local roomWidth = love.math.random(const.MIN_SIZE, const.MAX_SIZE)
    if roomWidth > self.maxWidth then self.maxWidth = roomWidth end
    local roomHeight = love.math.random(const.MIN_SIZE, const.MAX_SIZE)
    if roomHeight > self.maxHeight then self.maxHeight = roomHeight end

    local roomX = love.math.random(self.maxWidth)
    local roomY = love.math.random(self.maxHeight)
    local room = Room(roomX, roomY, roomWidth, roomHeight)

    for x=1, roomWidth do
      local row = {}
      local isRowWall = x == 1 or x == roomWidth

      for y=1, roomHeight do
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
  for x=1, self.maxWidth do
    map[x] = {}
    for _=1, self.maxHeight do
      table.insert(map[x], const.TILES.ground)
    end
  end

  -- fill in the room tiles
  for x=1, self.maxWidth do    
    for y=1, self.maxHeight do
      for _, room in ipairs(self.rooms) do
        if room:isInside(x, y) then
          map[x][y] = room.map[x][y]
        end
      end
    end
  end
end

return Level

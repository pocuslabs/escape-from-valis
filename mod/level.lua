Object = require("lib.classic")
local inspect = require("lib.inspect")

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
  for x=1, self.maxWidth do
    map[x] = {}
    for _=1, self.maxHeight do
      table.insert(map[x], const.TILES.ground)
    end
  end

  -- fill in the room tiles
  -- note: ax and ay are absolute map coordinates
  -- (as opposed to room-relative coordinates)
  for ax=1, self.maxWidth do
    for ay=1, self.maxHeight do
      for _, room in ipairs(self.rooms) do
        if room:isInside(ax, ay) then
          map[ax][ay] = room.map[ax][ay]
        end
      end
    end
  end
end

return Level

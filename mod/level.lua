Object = require("lib.classic")

local spritely = require("mod.spritely")
local const = require("mod.constants")
local help = require("mod.helpers")

local Level = Object:extend()

function Level:new(number, pixelW, pixelH)
  self.selector, self.spritesheet = spritely.load("gfx/dung2.png", { padding = 2, margin = 2 })
  self.map = {}
  self.rooms = {}

  self.width, self.height = pixelW, pixelH
  self.tilew, self.tileh = help.pixelToTile(pixelW, pixelH)
  self.roomCount = love.math.random(const.MIN_ROOMS, const.MAX_ROOMS)

  number = number or 1  -- the level we're on

  -- pregenerate a 2D array of w width and h height
  local map = {}
  for y = 1, self.tileh do
    map[y] = {}
    for _ = 1, self.tilew do
      table.insert(map[y], const.TILES.ground)
    end
  end

  -- make rooms
  for roomNumber=1, self.roomCount do
    local roomw = love.math.random(const.MIN_SIZE + 1, const.MAX_SIZE + 1) * const.TILE_SIZE
    local roomh = love.math.random(const.MIN_SIZE + 1, const.MAX_SIZE + 1) * const.TILE_SIZE
    local roomx = love.math.random(self.width - roomw)
    local roomy = love.math.random(self.height - roomh)

    local room = {
      x = roomx,
      y = roomy,
      w = roomw,
      h = roomh,
      map = {}
    }
    for ty=1, self.tileh do
      local row = {}
      local isRowWall = ty == 1 or ty == self.tileh

      for tx=1, self.tilew do
        local isWall = isRowWall or tx == 1 or tx == self.tilew
        local tile = const.TILES.ground
        if isWall then
          tile = const.TILES.wall
        end

        table.insert(row, tile)
      end

      table.insert(room.map, row)
    end

    table.insert(self.rooms, room)
  end

  -- fill in the room tiles
  for _, room in ipairs(self.rooms) do
    for ty, row in ipairs(room.map) do
      for tx, tile in ipairs(row) do
        local originTX, originTY = help.pixelToTile(room.x, room.y)
        local actualX, actualY = math.min(#map[1], originTX + tx), math.min(#map, originTY + ty)

        if tile.solid then
          local tileName = "Tile "..tx..","..ty
          local tileId = { name = tileName }
          local px, py = help.tileToPixel(actualX, actualY)
          Game.world:add(tileId, px, py, const.TILE_SIZE, const.TILE_SIZE)
        end

        if actualY > #map then
          actualY = #map - 1
        end

        if actualX > #map[1] then
          actualX = #map[1] - 1
        end

        map[actualY][actualX] = tile
      end
    end
  end

  self.map = map
end

function Level:draw()
  for ty, row in ipairs(self.map) do
    for tx, tile in ipairs(row) do
      local spriteX, spriteY = unpack(tile.coordinates)
      local quad = self.selector(spriteX, spriteY)
      local px, py = help.tileToPixel(tx, ty)
      love.graphics.draw(self.spritesheet, quad, px, py)
    end
  end
end

return Level
